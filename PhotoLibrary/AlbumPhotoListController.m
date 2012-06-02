//
//  AlbumPhotoListController.m
//  PhotoLibrary
//
//  Created by 刘 大兵 on 12-5-11.
//  Copyright (c) 2012年 中华中等专业学校. All rights reserved.
//

#import "AlbumPhotoListController.h"
#import "PhotoAssets.h"
#import "FullImageController.h"

#define kAssetsImageViewTag 100

@implementation AlbumPhotoListController
@synthesize photoAlbum;
- (void)loadView
{
    UIView *container = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 367)];
    self.view = container;
    [container release];
    
    DataTable = [[UITableView alloc]initWithFrame:CGRectMake(0, -64, 320, 367+44)];
    DataTable.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
    DataTable.delegate = self;
    DataTable.dataSource = self;
    [self.view addSubview:DataTable];
}

- (void)dealloc {
    [DataTable release];
    [photoAlbum release];
    [super dealloc];
}

-(void)viewDidLoad{
    [super viewDidLoad];
    self.navigationItem.title = photoAlbum.albumName;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //图片要分成4列显示，就是图片数量除以4，可能会除不尽，加一
    NSInteger rowCount = photoAlbum.numberOfAssets/4;
    if (photoAlbum.numberOfAssets%4!=0) {
        rowCount++;
    }
    return rowCount;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 75+5*2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *assetCell = [DataTable dequeueReusableCellWithIdentifier:@"assetCell"];
    if (assetCell==nil) {
        assetCell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault
                                           reuseIdentifier:@"assetCell"]autorelease];
        assetCell.selectionStyle = UITableViewCellSelectionStyleNone;
        //一个cell加一个手势，通过cell的indexPath和点击的区域来判断是哪一个图片
    }
    //循环加4个imageView,100 101 102 103
    for (NSInteger i=0; i<4; i++) {
        //判断imageView是否已经存在
        UIButton *assetImageView = (UIButton*)[assetCell.contentView viewWithTag:kAssetsImageViewTag+i];
        if (assetImageView==nil) {
            //4 75 4 75 4 75 4 75 4 
            assetImageView = [[UIButton alloc]initWithFrame:CGRectMake(4+(4+75)*i, 5, 75, 75)];
            assetImageView.tag = kAssetsImageViewTag+i;
            assetImageView.contentMode = UIViewContentModeScaleAspectFit;
            [assetImageView addTarget:self
                               action:@selector(imageButtonClick:)
                     forControlEvents:UIControlEventTouchUpInside];
            [assetCell.contentView addSubview:assetImageView];
            [assetImageView release];
        }
        //计算这一行，这一列对应的photoAssets
        //0 1 2 3 indexPath.row = 0
        //4 5 6 7 indexPath.row = 1
        //判断下标是否数组越界
        if (indexPath.row*4+i<photoAlbum.numberOfAssets) {
            assetImageView.hidden = NO;
            PhotoAssets *photoAssets = [photoAlbum.assetsArray objectAtIndex:indexPath.row*4+i];
            [assetImageView setBackgroundImage:photoAssets.thumnail
                                      forState:UIControlStateNormal];
            //assetImageView.image = photoAssets.thumnail;
        }else{
            //数组越界，隐藏imageView
            assetImageView.hidden = YES;
        }
    }
    return assetCell;
}

-(void)imageButtonClick:(UIButton*)theButton{
    //先取出cell的indexPath
    NSIndexPath *indexPath = [DataTable indexPathForCell:(UITableViewCell*)theButton.superview.superview];
    //theButton.tag是kAssetsImageViewTag+i
    NSInteger index = indexPath.row*4+theButton.tag-kAssetsImageViewTag;
    PhotoAssets *photoAssets = [photoAlbum.assetsArray objectAtIndex:index];
    FullImageController *fullImageController = [[FullImageController alloc]init];
    fullImageController.image = photoAssets.fullImage;
    [self.navigationController pushViewController:fullImageController animated:YES];
    [fullImageController release];
}
@end
