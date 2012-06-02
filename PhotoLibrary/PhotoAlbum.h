//
//  PhotoAlbum.h
//  PhotoLibrary
//
//  Created by 刘 大兵 on 12-5-11.
//  Copyright (c) 2012年 中华中等专业学校. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PhotoAlbum : NSObject
@property(nonatomic,retain) NSString *albumName;
@property(nonatomic,retain) UIImage *albumPostImage;
@property(nonatomic) NSInteger numberOfAssets;
@property(nonatomic,retain) NSMutableArray *assetsArray;
@end
