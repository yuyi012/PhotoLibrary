//
//  PhotoPickerController.m
//  PhotoLibrary
//
//  Created by 刘 大兵 on 12-5-11.
//  Copyright (c) 2012年 中华中等专业学校. All rights reserved.
//

#import "PhotoPickerController.h"
#import "PhotoAssets.h"
#import <AVFoundation/AVFoundation.h>
#import "TapCameraController.h"

@implementation PhotoPickerController
#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    pickerController = [[UIImagePickerController alloc]init];
    pickerController.delegate = self;
    pickerController.allowsEditing = YES;
}

- (void)dealloc {
    [pickerController release];
    [super dealloc];
}

-(IBAction)pickerButton:(id)sender{
    //自带navigationController，不用象使用newPersonController一样赋予一个navigationController
//    [self presentModalViewController:pickerController animated:YES];
    //弹自定义多图片选取的controller
    MultiImagePickerController *multiImageController = [[MultiImagePickerController alloc]init];
    multiImageController.delegate = self;
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:multiImageController];
//    multiImageController.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self presentModalViewController:nav animated:YES];
    [multiImageController release];
    [nav release];
}

-(void)multiImagePickDone:(NSArray*)imageArray{
    if (imageArray.count>0) {
        //取第一个图片显示
        [self dismissModalViewControllerAnimated:YES];
        PhotoAssets *firstAssets = [imageArray objectAtIndex:0];
        displayImageView.image = firstAssets.thumnail;
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo{
    NSLog(@"editingInfo:%@",editingInfo);
    //AVAssetImageGenerator *imageGeneratoe = [AVAssetImageGenerator 
    //拍摄照片完成以后调用
    [picker dismissModalViewControllerAnimated:YES];
    displayImageView.image = image;
}

//- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
//    //拍摄视频完成以后调用
//    [picker dismissModalViewControllerAnimated:YES];
//    NSLog(@"info:%@",info);
//    //判断是否info里面包含了视频
//    if ([[info objectForKey:UIImagePickerControllerMediaType]isEqualToString:@"public.movie"]) {
//        NSLog(@"url:%@,class:%@",[info objectForKey:UIImagePickerControllerMediaURL],
//              NSStringFromClass([[info objectForKey:UIImagePickerControllerMediaURL]class]));
//        //url不能当作字符串用
//        NSURL *mediaURL = [info objectForKey:UIImagePickerControllerMediaURL];
//        //avasset初始化和ALAssets不是一样的
//        AVAsset *avassets = [AVAsset assetWithURL:mediaURL];
//        //视频图像截取
//        AVAssetImageGenerator *imageGenerator = [AVAssetImageGenerator assetImageGeneratorWithAsset:avassets];
//        //截取第一秒的图像
//        CGImageRef imageRef = [imageGenerator copyCGImageAtTime:CMTimeMake(0, 1) actualTime:NULL error:NULL];
//        //显示在imageView中
//        displayImageView.image = [UIImage imageWithCGImage:imageRef];
//    }
//}

-(IBAction)cameraButton:(id)sender{
    //判断用户的设备是否有相机,因为一代ipad，老的ipod touch都没有相机
    //如果用户的设备没有相机，还调研相机，会导致程序crash，程序crash是不允许的
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        //有相机
        UIImagePickerController *cameraController = [[UIImagePickerController alloc]init];
        cameraController.sourceType = UIImagePickerControllerSourceTypeCamera;
        //指定可以拍摄图片和视频
        cameraController.mediaTypes = [NSArray arrayWithObjects:@"public.movie",@"public.image", nil];
        cameraController.delegate = self;
        //把拍摄模式指定为视频
        cameraController.cameraCaptureMode = UIImagePickerControllerCameraCaptureModeVideo;
        [self presentModalViewController:cameraController animated:YES];
        [cameraController release];
    }else{
        //没有相机
        UIAlertView *errorAlert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您的设备没有相机" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [errorAlert show];
        [errorAlert release];
    }
}
@end
