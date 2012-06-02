//
//  TapCameraController.m
//  PhotoLibrary
//
//  Created by 刘 大兵 on 12-5-15.
//  Copyright (c) 2012年 中华中等专业学校. All rights reserved.
//

#import "TapCameraController.h"

@implementation TapCameraController
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    //隐藏默认的拍照，切换摄像头的控件
    self.showsCameraControls = NO;
    UIImage *overlayImage = [UIImage imageNamed:@"camera_overlay.png"];
    UIImageView *cameraOverlay = [[UIImageView alloc]initWithImage:overlayImage];
    self.cameraOverlayView = cameraOverlay;
    [cameraOverlay release];
    //加手势，点击屏幕任一区域完成拍照
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapToTakePicture)];
    [self.view addGestureRecognizer:tapGesture];
    [tapGesture release];
}

-(void)tapToTakePicture{
    [self takePicture];
}
@end
