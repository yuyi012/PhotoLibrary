//
//  MultiImagePickerController.m
//  PhotoLibrary
//
//  Created by 刘 大兵 on 12-5-14.
//  Copyright (c) 2012年 中华中等专业学校. All rights reserved.
//

#import "MultiImagePickerController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "PhotoAssets.h"

#define kAssetsImageViewTag 100

@implementation MultiImagePickerController
@synthesize delegate;
-(void)loadView{
    self.navigationItem.title = @"多图片选取";
    UIView *container = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 416)];
    self.view = container;
    [container release];
    
    self.navigationController.view.userInteractionEnabled = YES;
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone
 target:self action:@selector(imagePickDone)]autorelease];
    
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    self.navigationController.navigationBar.alpha = 0.5;
    
    DataTable = [[UITableView alloc]initWithFrame:CGRectMake(0, -64, 320, 400)];
    DataTable.delegate = self;
    DataTable.dataSource = self;
    DataTable.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
    DataTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:DataTable];
    
    scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 400-64, 320, 416-336)];
    scrollView.backgroundColor = [UIColor scrollViewTexturedBackgroundColor];
    scrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:scrollView];
    
    loadView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    loadView.center = CGPointMake(160, 200);
    [self.view addSubview:loadView];
}

- (void)dealloc {
    [DataTable release];
    [scrollView release];
    [loadView release];
    [selectedImageArray release];
    [super dealloc];
}

-(void)imagePickDone{
    //判断delegate是否实现了方法，没有实现方法直接调用会crash
    if ([delegate respondsToSelector:@selector(multiImagePickDone:)]) {
        [delegate multiImagePickDone:selectedImageArray];
    }
}

-(void)viewDidLoad{
    [super viewDidLoad];
    imageArray = [[NSMutableArray alloc]init];
    //已经选中的图片都保存在selectedImageArray中
    selectedImageArray = [[NSMutableArray alloc]init];
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc]init];
    [loadView startAnimating];
    [library enumerateGroupsWithTypes:ALAssetsGroupAlbum
                           usingBlock:^(ALAssetsGroup *group, BOOL *stop){
                               //取出了所有的相册
                               if (group!=nil) {
                                   //循环相册内所有的照片
                                   [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop){
                                       if (result!=nil) {
                                           //result代表每个图片
                                           PhotoAssets *photoAssets = [[PhotoAssets alloc]init];
                                           photoAssets.thumnail = [UIImage imageWithCGImage:result.thumbnail];
                                           photoAssets.fullImage = [UIImage imageWithCGImage:result.defaultRepresentation.fullScreenImage];
                                           [imageArray addObject:photoAssets];
                                           [photoAssets release];
                                       } 
                                   }];
                               }else{
                                   [loadView stopAnimating];
                                   [DataTable reloadData];
                               }
                           }failureBlock:^(NSError *error){
                               
                           }];
    [library release];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //图片要分成4列显示，就是图片数量除以4，可能会除不尽，加一
    NSInteger rowCount = imageArray.count/4;
    if (imageArray.count%4!=0) {
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
        if (indexPath.row*4+i<imageArray.count) {
            assetImageView.hidden = NO;
            PhotoAssets *photoAssets = [imageArray objectAtIndex:indexPath.row*4+i];
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
    PhotoAssets *photoAssets = [imageArray objectAtIndex:index];
    //点击了图片以后，把图片加入到scrollView，表示已经选中
    UIButton *selectedImageButton = [[UIButton alloc]initWithFrame:CGRectMake(10+selectedImageArray.count*80, 10, 75, 75)];
    [selectedImageButton setBackgroundImage:photoAssets.thumnail forState:UIControlStateNormal];
    [selectedImageButton addTarget:self
                            action:@selector(removeFromSelectedImage:)
                  forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:selectedImageButton];
    [selectedImageButton release];
    [selectedImageArray addObject:photoAssets];
    //设置contentSize
    scrollView.contentSize = CGSizeMake(10+80*selectedImageArray.count, 75);
}

-(void)removeFromSelectedImage:(UIButton*)theButton{
    //点击选中的图片，把他删除
    for (PhotoAssets *photoAssets in selectedImageArray) {
        //判断photoAsset的图片和按钮的图片是否一致
        if ([photoAssets.thumnail isEqual:[theButton backgroundImageForState:UIControlStateNormal]]) {
            [selectedImageArray removeObject:photoAssets];
            break;
        }
    }
    CGFloat xOffset = theButton.frame.origin.x;
    //从scroll移除点击的button
    [theButton removeFromSuperview];
    //重新计算点击按钮右边的其他按钮的位置
    for (UIButton *rightButton in scrollView.subviews) {
        //判断是否右边的按钮
        if (rightButton.frame.origin.x>xOffset) {
            //右边的按钮都往左移80像素
            //0.5的动画
            [UIView animateWithDuration:0.3
                             animations:^{
                                 CGRect rightButtonFrame = rightButton.frame;
                                 rightButtonFrame.origin.x -= 80;
                                 rightButton.frame = rightButtonFrame;
                             }];

        }
    }
}
@end
