//
//  PhotoAssets.m
//  PhotoLibrary
//
//  Created by 刘 大兵 on 12-5-11.
//  Copyright (c) 2012年 中华中等专业学校. All rights reserved.
//

#import "PhotoAssets.h"

@implementation PhotoAssets
@synthesize thumnail;
@synthesize fullImage;
- (void)dealloc {
    [thumnail release];
    [fullImage release];
    [super dealloc];
}
@end
