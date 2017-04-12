//
//  ViewController.m
//  videoDemo
//
//  Created by 易博 on 2017/4/11.
//  Copyright © 2017年 易博. All rights reserved.
//

#import "ViewController.h"
#import "SMAVideoPlayer.h"

@implementation ViewController

//播放远端视频
- (IBAction)playRemoteVideo:(UIButton *)sender {
    SMAVideoPlayer *player = [[SMAVideoPlayer alloc] init];
    
    player.bounds = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.width / 16 * 9);
    player.center = self.view.center;
    player.mediaURL = [NSURL URLWithString:@"http://172.20.90.117/www2/video/1.mp4"];
    
    [player showInView:self.view.window];
    
    [self prefersStatusBarHidden];
}

-(BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
