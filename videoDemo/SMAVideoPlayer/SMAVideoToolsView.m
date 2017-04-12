//
//  SMAVideoToolsView.m
//  videoDemo
//
//  Created by 易博 on 2017/4/11.
//  Copyright © 2017年 易博. All rights reserved.
//

#import "SMAVideoToolsView.h"
#import <MediaPlayer/MediaPlayer.h>
#import "SMAVideoPlayerConst.h"

@interface SMAVideoToolsView()
//点击手势
@property (nonatomic, strong) UIPanGestureRecognizer *tapGesture;

@end

@implementation SMAVideoToolsView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.topBar.frame             = CGRectMake(CGRectGetMinX(self.bounds), CGRectGetMinY(self.bounds), CGRectGetWidth(self.bounds), SMA_VideoControlBarHeight);
    
    self.closeBtn.frame        = CGRectMake(0, CGRectGetMinX(self.topBar.bounds), CGRectGetWidth(self.closeBtn.bounds), CGRectGetHeight(self.closeBtn.bounds));
    
    self.bottomBar.frame          = CGRectMake(CGRectGetMinX(self.bounds), CGRectGetHeight(self.bounds) - SMA_VideoControlBarHeight, CGRectGetWidth(self.bounds), SMA_VideoControlBarHeight);
    
    self.progressSlider.frame     = CGRectMake(0, -0, CGRectGetWidth(self.bounds), SMA_VideoControlSliderHeight);
    
    self.playBtn.frame         = CGRectMake(CGRectGetMinX(self.bottomBar.bounds), CGRectGetHeight(self.bottomBar.bounds)/2 - CGRectGetHeight(self.playBtn.bounds)/2 + CGRectGetHeight(self.progressSlider.frame) * 0.6, CGRectGetWidth(self.playBtn.bounds), CGRectGetHeight(self.playBtn.bounds));
    
    self.pauseBtn.frame        = self.playBtn.frame;
    
    self.fullScreenBtn.frame   = CGRectMake(CGRectGetWidth(self.bottomBar.bounds) - CGRectGetWidth(self.fullScreenBtn.bounds) - 5, self.playBtn.frame.origin.y, CGRectGetWidth(self.fullScreenBtn.bounds), CGRectGetHeight(self.fullScreenBtn.bounds));
    
    self.smallScreenBtn.frame = self.fullScreenBtn.frame;
    
    self.hudView.center     = CGPointMake(CGRectGetWidth(self.bounds) / 2, CGRectGetHeight(self.bounds) / 2);
    
    self.timeLabel.frame          = CGRectMake(CGRectGetMaxX(self.playBtn.frame), self.playBtn.frame.origin.y, CGRectGetWidth(self.bottomBar.bounds), CGRectGetHeight(self.timeLabel.bounds));
    
}

#pragma mark - 私有方法
- (void)setupView {
    
    self.backgroundColor = [UIColor clearColor];
    
    [self.layer addSublayer:self.bgLayer];
    [self addSubview:self.topBar];
    [self addSubview:self.hudView];
    [self addSubview:self.bottomBar];
    [self addSubview:self.hudView];
    
    [self.topBar    addSubview:self.closeBtn];
    [self.bottomBar addSubview:self.playBtn];
    [self.bottomBar addSubview:self.pauseBtn];
    [self.bottomBar addSubview:self.fullScreenBtn];
    [self.bottomBar addSubview:self.smallScreenBtn];
    [self.bottomBar addSubview:self.progressSlider];
    [self.bottomBar addSubview:self.timeLabel];
    
    self.pauseBtn.hidden = YES;
    self.smallScreenBtn.hidden = YES;
    
    [self addGestureRecognizer:self.tapGesture];
}

- (void)responseTapImmediately {
    self.bottomBar.alpha == 0 ? [self animateShow] : [self animateHide];
}

#pragma mark - 代理方法

#pragma mark - 接口方法

/**
 隐藏工具栏，全屏效果
 */
- (void)animateHide
{
    [UIView animateWithDuration:SMA_VideoControlAnimationTimeinterval animations:^{
        self.topBar.alpha = 0;
        self.bottomBar.alpha = 0;
    } completion:^(BOOL finished) {
    }];
}

/**
 显示工具栏
 */
- (void)animateShow
{
    [UIView animateWithDuration:SMA_VideoControlAnimationTimeinterval animations:^{
        self.topBar.alpha = 1;
        self.bottomBar.alpha = 1;
    } completion:^(BOOL finished) {
        [self autoFadeOutControlBar];
    }];
}

- (void)autoFadeOutControlBar
{
    //如果有延迟执行在队列中，则取消延时执行
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(animateHide) object:nil];
    //开始延迟执行
    [self performSelector:@selector(animateHide) withObject:nil afterDelay:SMA_VideoControlBarAutoFadeOutTimeinterval];
}

- (void)cancelAutoFadeOutControlBar
{
    //如果有延迟执行在队列中，则取消延时执行
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(animateHide) object:nil];
}

#pragma mark - 屏幕触摸事件
- (void)tapGestureAction:(UIPanGestureRecognizer *)pan {
    
}
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    if (touch.tapCount > 0) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self responseTapImmediately];
        });
    }
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self responseTapImmediately];
}

#pragma mark - 懒加载
- (UIView *)topBar
{
    if (!_topBar) {
        _topBar = [UIView new];
        _topBar.backgroundColor = [UIColor clearColor];
    }
    return _topBar;
}

- (UIView *)bottomBar
{
    if (!_bottomBar) {
        _bottomBar = [UIView new];
        _bottomBar.backgroundColor = kRGB(27, 27, 27);
    }
    return _bottomBar;
}

- (UIButton *)playBtn
{
    if (!_playBtn) {
        _playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_playBtn setImage:[UIImage imageNamed:@"Play"] forState:UIControlStateNormal];
        _playBtn.bounds = CGRectMake(0, 0, SMA_VideoControlBarHeight, SMA_VideoControlBarHeight);
    }
    return _playBtn;
}

- (UIButton *)pauseBtn
{
    if (!_pauseBtn) {
        _pauseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_pauseBtn setImage:[UIImage imageNamed:@"Pause"] forState:UIControlStateNormal];
        _pauseBtn.bounds = CGRectMake(0, 0, SMA_VideoControlBarHeight, SMA_VideoControlBarHeight);
    }
    return _pauseBtn;
}

- (UIButton *)fullScreenBtn
{
    if (!_fullScreenBtn) {
        _fullScreenBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_fullScreenBtn setImage:[UIImage imageNamed:@"FullScreen"] forState:UIControlStateNormal];
        _fullScreenBtn.bounds = CGRectMake(0, 0, SMA_VideoControlBarHeight, SMA_VideoControlBarHeight);
    }
    return _fullScreenBtn;
}

- (UIButton *)smallScreenBtn
{
    if (!_smallScreenBtn) {
        _smallScreenBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_smallScreenBtn setImage:[UIImage imageNamed:@"MinScreen"] forState:UIControlStateNormal];
        _smallScreenBtn.bounds = CGRectMake(0, 0, SMA_VideoControlBarHeight, SMA_VideoControlBarHeight);
    }
    return _smallScreenBtn;
}


- (UISlider *)progressSlider
{
    if (!_progressSlider) {
        _progressSlider = [[UISlider alloc] init];
        [_progressSlider setThumbImage:[UIImage imageNamed:@"PlayerNob"] forState:UIControlStateNormal];
        [_progressSlider setMinimumTrackTintColor:kRGB(239, 71, 94)];
        [_progressSlider setMaximumTrackTintColor:kRGB(157, 157, 157)];
        [_progressSlider setBackgroundColor:[UIColor clearColor]];
        _progressSlider.value = 0.f;
        _progressSlider.continuous = YES;
    }
    return _progressSlider;
}

- (UIButton *)closeBtn
{
    if (!_closeBtn) {
        _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeBtn setImage:[UIImage imageNamed:@"PlayerClose"] forState:UIControlStateNormal];
        _closeBtn.bounds = CGRectMake(0, 0, SMA_VideoControlBarHeight, SMA_VideoControlBarHeight);
    }
    return _closeBtn;
}

- (UILabel *)timeLabel
{
    if (!_timeLabel) {
        _timeLabel = [UILabel new];
        _timeLabel.backgroundColor = [UIColor clearColor];
        _timeLabel.font = [UIFont systemFontOfSize:SMA_VideoControlTimeLabelFontSize];
        _timeLabel.textColor = [UIColor lightGrayColor];
        _timeLabel.textAlignment = NSTextAlignmentLeft;
        _timeLabel.bounds = CGRectMake(0, 0, SMA_VideoControlTimeLabelFontSize, SMA_VideoControlBarHeight);
    }
    return _timeLabel;
}

- (CALayer *)bgLayer {
    if (!_bgLayer) {
        _bgLayer = [CALayer layer];
        _bgLayer.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"VideoBg"]].CGColor;
        _bgLayer.bounds = self.frame;
        _bgLayer.position = CGPointMake(CGRectGetWidth(self.bounds) / 2, CGRectGetHeight(self.bounds) / 2);
    }
    return _bgLayer;
}

- (SMAVideoHUDView *)hudView {
    if (!_hudView) {
        _hudView = [[SMAVideoHUDView alloc] init];
        _hudView.bounds = CGRectMake(0, 0, 100, 100);
    }
    return _hudView;
}

- (UIPanGestureRecognizer *)tapGesture {
    if (!_tapGesture) {
        _tapGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureAction:)];
    }
    return _tapGesture;
}


@end
