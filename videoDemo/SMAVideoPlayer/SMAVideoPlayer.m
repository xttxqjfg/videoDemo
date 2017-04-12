//
//  SMAVideoPlayer.m
//  videoDemo
//
//  Created by 易博 on 2017/4/11.
//  Copyright © 2017年 易博. All rights reserved.
//

#import "SMAVideoPlayer.h"
#import <MobileVLCKit/MobileVLCKit.h>
#import "SMAVideoToolsView.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import "SMAVideoPlayerConst.h"

@interface SMAVideoPlayer()<VLCMediaPlayerDelegate>
{
    CGRect _originFrame;
}
@property (nonatomic,strong) VLCMediaPlayer *player;
@property (nonatomic, nonnull,strong) SMAVideoToolsView *toolsView;
@end

@implementation SMAVideoPlayer

- (instancetype)init {
    if (self = [super init]) {
        [self setupNotification];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    [self setupPlayer];
    [self setupView];
    [self setupControlView];
}

#pragma mark - 接口方法
- (void)showInView:(UIView *)view {
    
    NSAssert(_mediaURL != nil, @"MRVLCPlayer Exception: mediaURL could not be nil!");
    
    [view addSubview:self];
    
    self.alpha = 0.0;
    [UIView animateWithDuration:SMA_VideoControlAnimationTimeinterval animations:^{
        self.alpha = 1.0;
    } completion:^(BOOL finished) {
        [self play];
    }];
}

- (void)dismiss {
    [self.player stop];
    self.player.delegate = nil;
    self.player.drawable = nil;
    self.player = nil;
    
    // 注销通知
    [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [self removeFromSuperview];
}

#pragma mark - Private Method
- (void)setupView {
    [self setBackgroundColor:[UIColor blackColor]];
}

- (void)setupPlayer {
    [self.player setDrawable:self];
    self.player.media = [[VLCMedia alloc] initWithURL:self.mediaURL];
}

- (void)setupControlView {
    
    [self addSubview:self.toolsView];
    
    //添加控制界面的监听方法
    [self.toolsView.playBtn addTarget:self action:@selector(playButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.toolsView.pauseBtn addTarget:self action:@selector(pauseButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.toolsView.closeBtn addTarget:self action:@selector(closeButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.toolsView.fullScreenBtn addTarget:self action:@selector(fullScreenButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.toolsView.smallScreenBtn addTarget:self action:@selector(shrinkScreenButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.toolsView.progressSlider addTarget:self action:@selector(progressClick) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setupNotification {
    
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(orientationHandler)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil
     ];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationWillEnterForeground)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationWillResignActive)
                                                 name:UIApplicationWillResignActiveNotification
                                               object:nil];
}

/**
 *    强制横屏
 *
 *    @param orientation 横屏方向
 */
- (void)forceChangeOrientation:(UIInterfaceOrientation)orientation
{
    int val = orientation;
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        SEL selector = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }
}

#pragma mark Notification Handler
/**
 *    屏幕旋转处理
 */
- (void)orientationHandler {
    
    if (UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation)) {
        self.isFullscreenModel = YES;
        
    }else {
        self.isFullscreenModel = NO;
    }
    [self.toolsView autoFadeOutControlBar];
}

/**
 *    即将进入后台的处理
 */
- (void)applicationWillEnterForeground {
    [self play];
}

/**
 *    即将返回前台的处理
 */
- (void)applicationWillResignActive {
    [self pause];
}


#pragma mark Button Event
- (void)playButtonClick {
    
    [self play];
    
}

- (void)pauseButtonClick {
    
    [self pause];
}

- (void)closeButtonClick {
    [self dismiss];
}

- (void)fullScreenButtonClick {
    
    [self forceChangeOrientation:UIInterfaceOrientationLandscapeRight];
}

- (void)shrinkScreenButtonClick {
    
    [self forceChangeOrientation:UIInterfaceOrientationPortrait];;
}

- (void)progressClick {
    
    int targetIntvalue = (int)(self.toolsView.progressSlider.value * (float)kMediaLength.intValue);
    
    VLCTime *targetTime = [[VLCTime alloc] initWithInt:targetIntvalue];
    
    [self.player setTime:targetTime];
    
    [self.toolsView autoFadeOutControlBar];
}

#pragma mark Player Logic
- (void)play {
    [self.player play];
    self.toolsView.playBtn.hidden = YES;
    self.toolsView.pauseBtn.hidden = NO;
    [self.toolsView autoFadeOutControlBar];
}

- (void)pause {
    [self.player pause];
    self.toolsView.playBtn.hidden = NO;
    self.toolsView.pauseBtn.hidden = YES;
    [self.toolsView autoFadeOutControlBar];
}

- (void)stop {
    [self.player stop];
    self.toolsView.progressSlider.value = 1;
    self.toolsView.playBtn.hidden = NO;
    self.toolsView.pauseBtn.hidden = YES;
}

#pragma mark - Delegate
#pragma mark VLC
- (void)mediaPlayerStateChanged:(NSNotification *)aNotification {
    // Every Time change the state,The VLC will draw video layer on this layer.
    [self bringSubviewToFront:self.toolsView];
    if (self.player.media.state == VLCMediaStateBuffering) {
        self.toolsView.hudView.hidden = NO;
        self.toolsView.bgLayer.hidden = NO;
    }else if (self.player.media.state == VLCMediaStatePlaying) {
        self.toolsView.hudView.hidden = YES;
        self.toolsView.bgLayer.hidden = YES;
    }else if (self.player.state == VLCMediaPlayerStateStopped) {
        [self stop];
    }else {
        self.toolsView.bgLayer.hidden = NO;
    }
    
}

- (void)mediaPlayerTimeChanged:(NSNotification *)aNotification {
    
    [self bringSubviewToFront:self.toolsView];
    
    if (self.toolsView.progressSlider.state != UIControlStateNormal) {
        return;
    }
    
    float precentValue = ([self.player.time.numberValue floatValue]) / ([kMediaLength.numberValue floatValue]);
    
    [self.toolsView.progressSlider setValue:precentValue animated:YES];
    
    [self.toolsView.timeLabel setText:[NSString stringWithFormat:@"%@/%@",_player.time.stringValue,kMediaLength.stringValue]];
}

#pragma mark - 懒加载
- (VLCMediaPlayer *)player {
    if (!_player) {
        _player = [[VLCMediaPlayer alloc] init];
        _player.delegate = self;
    }
    return _player;
}

- (SMAVideoToolsView *)toolsView {
    if (!_toolsView) {
        _toolsView = [[SMAVideoToolsView alloc] initWithFrame:self.bounds];
    }
    return _toolsView;
}


- (void)setIsFullscreenModel:(BOOL)isFullscreenModel {
    
    if (_isFullscreenModel == isFullscreenModel) {
        return;
    }
    
    _isFullscreenModel = isFullscreenModel;
    
    if (isFullscreenModel) {
        _originFrame = self.frame;
        CGFloat height = kSCREEN_BOUNDS.size.width;
        CGFloat width = kSCREEN_BOUNDS.size.height;
        CGRect frame = CGRectMake((height - width) / 2, (width - height) / 2, width, height);
        [UIView animateWithDuration:SMA_VideoControlAnimationTimeinterval animations:^{
            /**
             *    此判断是为了适配项目在Deployment Info中是否勾选了横屏
             */
            if (UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation)) {
                self.frame = frame;
                self.transform = CGAffineTransformMakeRotation(M_PI_2);
            }else {
                self.frame = self.frame = kSCREEN_BOUNDS;
            }
            self.toolsView.frame = self.bounds;
            [self.toolsView layoutIfNeeded];
            self.toolsView.fullScreenBtn.hidden = YES;
            self.toolsView.smallScreenBtn.hidden = NO;
        } completion:^(BOOL finished) {}];
        
    }else {
        [UIView animateWithDuration:SMA_VideoControlAnimationTimeinterval animations:^{
            self.transform = CGAffineTransformIdentity;
            self.frame = _originFrame;
            self.toolsView.frame = self.bounds;
            [self.toolsView layoutIfNeeded];
            self.toolsView.fullScreenBtn.hidden = NO;
            self.toolsView.smallScreenBtn.hidden = YES;
            
        } completion:^(BOOL finished) {}];
        
        
    }
    
}
@end
