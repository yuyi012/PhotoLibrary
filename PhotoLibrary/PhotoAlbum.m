//
//  PhotoAlbum.m
//  PhotoLibrary
//
//  Created by 刘 大兵 on 12-5-11.
//  Copyright (c) 2012年 中华中等专业学校. All rights reserved.
//

#import "PhotoAlbum.h"

@implementation PhotoAlbum
@synthesize albumName;
@synthesize albumPostImage;
@synthesize assetsArray;
@synthesize numberOfAssets;
- (id)init {
    self = [super init];
    if (self) {
        assetsArray = [[NSMutableArray alloc]init];
    }
    return self;
}
- (void)dealloc {
    [albumPostImage release];
    [albumName release];
    [assetsArray release];
    [super dealloc];
}
@end
