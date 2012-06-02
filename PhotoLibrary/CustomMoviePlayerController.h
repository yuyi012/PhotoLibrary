//
//  CustomMoviePlayerController.h
//  PhotoLibrary
//
//  Created by 刘 大兵 on 12-5-16.
//  Copyright (c) 2012年 中华中等专业学校. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomPlayerView.h"
#import <AVFoundation/AVFoundation.h>

@interface CustomMoviePlayerController : UIViewController{
    CustomPlayerView *playerView;
}
@property(nonatomic,retain) AVPlayerItem *playerItem;
@end
