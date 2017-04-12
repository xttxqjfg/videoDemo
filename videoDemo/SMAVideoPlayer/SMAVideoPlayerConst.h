//
//  SMAVideoPlayerConst.h
//  videoDemo
//
//  Created by 易博 on 2017/4/11.
//  Copyright © 2017年 易博. All rights reserved.
//

#define kMediaLength self.player.media.length
#define kHUDCenter CGPointMake(CGRectGetWidth(self.bounds) / 2, CGRectGetHeight(self.bounds) / 2);
#define kRGB(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
#define kSCREEN_BOUNDS [[UIScreen mainScreen] bounds]

static const CGFloat SMA_ProgressWidth = 3.0f;
static const CGFloat SMA_VideoControlBarHeight = 40.0;
static const CGFloat SMA_VideoControlSliderHeight = 10.0;
static const CGFloat SMA_VideoControlAnimationTimeinterval = 0.3;
static const CGFloat SMA_VideoControlTimeLabelFontSize = 10.0;
static const CGFloat SMA_VideoControlBarAutoFadeOutTimeinterval = 4.0;
static const CGFloat SMA_VideoControlCorrectValue = 3;
static const CGFloat SMA_VideoControlAlertAlpha = 0.75;

static const NSTimeInterval kHUDCycleTimeInterval = 0.8f;
static const CGFloat kHUDCycleLineWidth = 3.0f;
