//
//  CustomMoviePlayerController.m
//  PhotoLibrary
//
//  Created by 刘 大兵 on 12-5-16.
//  Copyright (c) 2012年 中华中等专业学校. All rights reserved.
//

#import "CustomMoviePlayerController.h"

@implementation CustomMoviePlayerController
@synthesize playerItem;
-(void)loadView{
    UIView *container = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 416)];
    self.view = container;
    [container release];
    
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    self.navigationController.navigationBar.alpha = 0.5;
    
    playerView = [[CustomPlayerView alloc]initWithFrame:CGRectMake(0, -64, 320, 480)];
    [self.view addSubview:playerView];
    AVPlayer *player = [[AVPlayer alloc]initWithPlayerItem:self.playerItem];
    [playerView setPlayer:player];
    [playerView.player play];
    [player release];
    //在播放两秒后隐藏navigationbar 和statusbar，获取更多的空间
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(hiddenNavigationBar) userInfo:nil repeats:NO];
    //调用一下可以去掉警告
    if ([timer isValid]) {
        //do nothing
    }
}

- (void)dealloc {
    [playerView release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    //使用avplayerItem初始化avplayer

}

-(void)hiddenNavigationBar{
    //隐藏navigaionbar
    self.navigationController.navigationBarHidden = YES;
    //隐藏statusbar
    [[UIApplication sharedApplication]setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
}
@end
