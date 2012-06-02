//
//  CustomPlayerView.m
//  PhotoLibrary
//
//  Created by 刘 大兵 on 12-5-16.
//  Copyright (c) 2012年 中华中等专业学校. All rights reserved.
//

#import "CustomPlayerView.h"

@implementation CustomPlayerView
+(Class)layerClass{
    return [AVPlayerLayer class];
}
//重写play的读取方法，为了能够设置player的时候同时改变layer
-(AVPlayer*)player{
    return [(AVPlayerLayer*)[self layer]player];
}

-(void)setPlayer:(AVPlayer *)thePlayer{
    [(AVPlayerLayer*)[self layer]setPlayer:thePlayer];
}
@end
