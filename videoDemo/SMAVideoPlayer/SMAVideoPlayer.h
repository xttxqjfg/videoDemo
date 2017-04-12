//
//  SMAVideoPlayer.h
//  videoDemo
//
//  Created by 易博 on 2017/4/11.
//  Copyright © 2017年 易博. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SMAVideoPlayer : UIView

@property (nonatomic,strong) NSURL *mediaURL;
@property (nonatomic,assign) BOOL isFullscreenModel;

- (void)showInView:(UIView *)view;

@end
