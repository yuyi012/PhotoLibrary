//
//  MovieModel.m
//  PhotoLibrary
//
//  Created by 刘 大兵 on 12-5-16.
//  Copyright (c) 2012年 中华中等专业学校. All rights reserved.
//

#import "MovieModel.h"

@implementation MovieModel
@synthesize movieURL;
@synthesize thumnail;
@synthesize duration;
- (void)dealloc {
    [movieURL release];
    [thumnail release];
    [super dealloc];
}
@end
