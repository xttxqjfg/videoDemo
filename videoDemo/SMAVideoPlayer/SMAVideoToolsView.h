//
//  SMAVideoToolsView.h
//  videoDemo
//
//  Created by 易博 on 2017/4/11.
//  Copyright © 2017年 易博. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMAVideoHUDView.h"

@interface SMAVideoToolsView : UIView

//顶部的工具栏，目前包含关闭按钮
@property (nonatomic,strong) UIView *topBar;
//底部的工具栏，目前包含播放、暂停、全屏、进度条、时间等
@property (nonatomic,strong) UIView *bottomBar;
//播放按钮
@property (nonatomic,strong) UIButton *playBtn;
//暂停按钮
@property (nonatomic,strong) UIButton *pauseBtn;
//全屏按钮
@property (nonatomic, strong) UIButton *fullScreenBtn;
//退出全屏按钮
@property (nonatomic, strong) UIButton *smallScreenBtn;
//进度条
@property (nonatomic, strong) UISlider *progressSlider;
//退出按钮
@property (nonatomic, strong) UIButton *closeBtn;
//时间
@property (nonatomic, strong) UILabel *timeLabel;
//背景层
@property (nonatomic, strong) CALayer *bgLayer;
//加载层
@property (nonatomic, strong) SMAVideoHUDView *hudView;

//动画消失
- (void)animateHide;
//动画显示
- (void)animateShow;

//取消延时执行
- (void)autoFadeOutControlBar;
//取消延时执行
- (void)cancelAutoFadeOutControlBar;

@end
