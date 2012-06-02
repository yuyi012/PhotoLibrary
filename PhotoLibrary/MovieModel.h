//
//  MovieModel.h
//  PhotoLibrary
//
//  Created by 刘 大兵 on 12-5-16.
//  Copyright (c) 2012年 中华中等专业学校. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MovieModel : NSObject
@property(nonatomic,retain) NSURL *movieURL;
@property(nonatomic,retain) UIImage *thumnail;
@property(nonatomic) CGFloat duration;
@end
