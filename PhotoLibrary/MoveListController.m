//
//  MoveListController.m
//  PhotoLibrary
//
//  Created by 刘 大兵 on 12-5-16.
//  Copyright (c) 2012年 中华中等专业学校. All rights reserved.
//

#import "MoveListController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "MovieModel.h"
#import <AVFoundation/AVFoundation.h>
#import <CoreMedia/CoreMedia.h>
#import <MediaPlayer/MediaPlayer.h>
#import "CustomMoviePlayerController.h"

@implementation MoveListController
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
    UIView *container = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 367)];
    self.view = container;
    [container release];
    //充分利用屏幕，把datatable移到statusbar位置
    DataTable = [[UITableView alloc]initWithFrame:CGRectMake(0, -64, 320, 367+64)];
    DataTable.dataSource = self;
    DataTable.delegate = self;
    //移动第一行使其到正确位置
    DataTable.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
    [self.view addSubview:DataTable];
}

- (void)dealloc {
    [DataTable release];
    [assetArray release];
    [fileArray release];
    [super dealloc];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    assetArray = [[NSMutableArray alloc]init];
    //NSString *resoucePath = [[NSBundle mainBundle]resourcePath];
    //NSLog(@"resoucePath:%@",resoucePath);
    //使用assetlibrary循环读取视频
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc]init];
    [library enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos usingBlock:^(ALAssetsGroup *group, BOOL *stop){
        //注意要判断是否为空，因为循环的最后一次就是空的
        //过滤，只取视频
        [group setAssetsFilter:[ALAssetsFilter allVideos]];
        if (group!=nil) {
            [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop){
                if (result!=nil) {
                    //把视频的信息都放入model中，因为循环结束alasset会无效
                    MovieModel *movieModel = [[MovieModel alloc]init];
                    movieModel.movieURL = [result defaultRepresentation].url;
                    movieModel.thumnail = [UIImage imageWithCGImage:[result thumbnail]];
                    movieModel.duration = [[result valueForProperty:ALAssetPropertyDuration]floatValue];
//                    NSLog(@"url:%@.thumbnail:%@,duration:%f",movieModel.movieURL,movieModel.thumnail,movieModel.duration);
                    [assetArray addObject:movieModel];
                    [movieModel release];
                }
            }];
        }else{
            //循环完成，重载tableview显示
            [DataTable reloadData];
        }
    }failureBlock:^(NSError *error){
        
    }];
    [library release];
    fileArray = [[NSMutableArray alloc]init];
    NSArray *moviePathArray = [[NSBundle mainBundle]pathsForResourcesOfType:@"MOV" inDirectory:nil];
    for (NSString *moviePath in moviePathArray) {
        //使用文件路径初始化avassets
        AVAsset *movieAsset = [AVAsset assetWithURL:[NSURL fileURLWithPath:moviePath]];
        //获取视频的截图,截第0秒的视频的图片
        AVAssetImageGenerator *assetImageGenerator = [AVAssetImageGenerator assetImageGeneratorWithAsset:movieAsset];
        CGImageRef imageRef = [assetImageGenerator copyCGImageAtTime:CMTimeMake(0, 1) actualTime:NULL error:NULL];
        UIImage *thumbnail = [UIImage imageWithCGImage:imageRef];
        MovieModel *movieModel = [[MovieModel alloc]init];
        movieModel.thumnail = thumbnail;
        CMTime cmTime = [movieAsset duration];
        //获取视频的时长需要使用cmtime除一下
        movieModel.duration = cmTime.value/cmTime.timescale;
        movieModel.movieURL = [NSURL fileURLWithPath:moviePath];
        [fileArray addObject:movieModel];
        [movieModel release];
    }
}

- (void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    NSLog(@"video save complete:%@",videoPath);
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    NSString *titleForHeader;
    if (section==0) {
        titleForHeader = @"从手机的照片库中读取(AssetsLibrary)";
    }else if(section==1){
        titleForHeader = @"从资源目录中读取(Supporting Files)";
    }
    return titleForHeader;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    //从assetsLibrary读取d的视频占一个section，从资源目录中读取的占另外一个
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger numberOfRows;
    if (section==0) {
        numberOfRows = assetArray.count;
    }else if(section==1){
        numberOfRows = fileArray.count;
    }
    return numberOfRows;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = nil;
    UITableViewCell *assetsCell = [DataTable dequeueReusableCellWithIdentifier:@"assetsCell"];
    if (assetsCell==nil) {
        assetsCell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"assetsCell"]autorelease];
    }
    MovieModel *movieModel;
    if (indexPath.section==0) {
        movieModel = [assetArray objectAtIndex:indexPath.row];
    }else if(indexPath.section==1){
        movieModel = [fileArray objectAtIndex:indexPath.row];
    }
    NSLog(@"url:%@.thumbnail:%@,duration:%f",movieModel.movieURL,movieModel.thumnail,movieModel.duration);
    assetsCell.imageView.image = movieModel.thumnail;
    assetsCell.textLabel.text = [NSString stringWithFormat:@"视频时长%f",movieModel.duration];
    cell = assetsCell;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MovieModel *movieModel;
    if (indexPath.section==0) {
        movieModel = [assetArray objectAtIndex:indexPath.row];
    }else if(indexPath.section==1){
        movieModel = [fileArray objectAtIndex:indexPath.row];
    }
//    MPMoviePlayerViewController *moviePlayerControlle = [[MPMoviePlayerViewController alloc]initWithContentURL:movieModel.movieURL];
//    moviePlayerControlle.moviePlayer.controlStyle = MPMovieControlStyleNone;
//    [self presentMoviePlayerViewControllerAnimated:moviePlayerControlle];
//    [moviePlayerControlle release];
    CustomMoviePlayerController *customPlayerController = [[CustomMoviePlayerController alloc]init];
    //使用url初始化avplayeritem
    AVPlayerItem *playerItem = [[AVPlayerItem alloc]initWithURL:movieModel.movieURL];
    customPlayerController.playerItem = playerItem;
    [playerItem release];
    UINavigationController *navigationController = [[UINavigationController alloc]initWithRootViewController:customPlayerController];
    [self presentModalViewController:navigationController animated:YES];
    [customPlayerController release];
    [navigationController release];
}
@end
