//
//  ALAssetsController.m
//  PhotoLibrary
//
//  Created by 刘 大兵 on 12-5-11.
//  Copyright (c) 2012年 中华中等专业学校. All rights reserved.
//

#import "ALAssetsController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "PhotoAlbum.h"
#import "PhotoAssets.h"
#import "AlbumPhotoListController.h"

#define kCellAssetsNumLabelTag 100

@implementation ALAssetsController
#pragma mark - View lifecycle

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
    UIView *container = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 367)];
    self.view = container;
    [container release];
    
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    self.navigationController.navigationBar.alpha = 0.5;
    //frame的orgin.y改成负的就可以显示在透明的navigationbar和statusbar上面
    DataTable = [[UITableView alloc]initWithFrame:CGRectMake(0, -64, 320, 367+44)];
    DataTable.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
    DataTable.delegate = self;
    DataTable.dataSource = self;
    [self.view addSubview:DataTable];
}

- (void)dealloc {
    [DataTable release];
    [groupArray release];
    [super dealloc];
}
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    groupArray = [[NSMutableArray alloc]init];
    //使用ALAssetsLibrary取照片
    ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc]init];
    //循环取出相册集
    [assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAlbum 
     usingBlock:^(ALAssetsGroup *group, BOOL *stop){
         //循环的最后一次group是nil
         if (group!=nil) {
             NSLog(@"groupName:%@",[group valueForProperty:ALAssetsGroupPropertyName]);
             PhotoAlbum *photoAlbum = [[PhotoAlbum alloc]init];
             //相册名称
             photoAlbum.albumName = [group valueForProperty:ALAssetsGroupPropertyName];
             //相册封面图片
             photoAlbum.albumPostImage = [UIImage imageWithCGImage:group.posterImage];
             //相册中照片数量
             photoAlbum.numberOfAssets = group.numberOfAssets;
             //相册中照片数组
             [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop){
                 if (result) {
                     //因为alasset循环结束就会实效，所有要取出属性封装成自己的model
                     PhotoAssets *photoAssets = [[PhotoAssets alloc]init];
                     //小图
                     photoAssets.thumnail = [UIImage imageWithCGImage:result.thumbnail];
                     //全图
                     photoAssets.fullImage = [UIImage imageWithCGImage:result.defaultRepresentation.fullResolutionImage];
                     [photoAlbum.assetsArray addObject:photoAssets];
                     [photoAssets release]; 
                 }
             }];
             [groupArray addObject:photoAlbum];
             [photoAlbum release];
         }else{
             //循环结束
             [DataTable reloadData];
         }
    } failureBlock:^(NSError *error){
        
    }];
    [assetsLibrary release];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return groupArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *groupCell = [DataTable dequeueReusableCellWithIdentifier:@"groupCell"];
    if (groupCell==nil) {
        groupCell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"groupCell"]autorelease];
        groupCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        //用灰色颜色label显示照片
        UILabel *numLabel = [[UILabel alloc]initWithFrame:CGRectMake(70, 0, 80, 44)];
        numLabel.textAlignment = UITextAlignmentCenter;
        numLabel.backgroundColor = [UIColor clearColor];
        numLabel.textColor = [UIColor lightGrayColor];
        numLabel.tag = kCellAssetsNumLabelTag;
        [groupCell.contentView addSubview:numLabel];
        [numLabel release];
    }
    PhotoAlbum *photoAlbum = [groupArray objectAtIndex:indexPath.row];
    groupCell.imageView.image = photoAlbum.albumPostImage;
    groupCell.textLabel.text = photoAlbum.albumName;
    //获取numLabel，计算frame
    //NSLog(@"textLabel:%@",NSStringFromCGRect(groupCell.textLabel.frame));
    //54是44（图片的宽度）＋10（图片和文字的间隔）
    CGFloat xOffset = 44;
    xOffset += [groupCell.textLabel.text sizeWithFont:[UIFont boldSystemFontOfSize:16] constrainedToSize:CGSizeMake(CGFLOAT_MAX, 20)].width;
    UILabel *numLabel = (UILabel*)[groupCell.contentView viewWithTag:kCellAssetsNumLabelTag];
    CGRect numFrame = numLabel.frame;
    numFrame.origin.x = xOffset;
    numLabel.frame = numFrame;
    //设置图片数量文字,可能被textLabel挡住了，bringToFront可以带到顶部
    [groupCell.contentView bringSubviewToFront:numLabel];
    numLabel.text = [NSString stringWithFormat:@"(%d)",photoAlbum.numberOfAssets];
    return groupCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    PhotoAlbum *photoAlbum = [groupArray objectAtIndex:indexPath.row];
    AlbumPhotoListController *photoListController = [[AlbumPhotoListController alloc]init];
    photoListController.photoAlbum = photoAlbum;
    [self.navigationController pushViewController:photoListController animated:YES];
    [photoListController release];
}
@end
