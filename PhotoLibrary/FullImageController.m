//
//  FullImageController.m
//  WangyiNewsDemo
//
//  Created by 俞 億 on 12-4-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "FullImageController.h"

@interface FullImageController ()

@end

@implementation FullImageController
@synthesize image = _image;
- (void)dealloc
{
    [scrollView release];
    [imageView release];
    [_image release];
    [super dealloc];
}

-(void)loadView{
    UIView *container = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 416)];
    self.view = container;
    [container release];
    
    scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, -64, 320, 416+64)];
    scrollView.delegate = self;
    scrollView.minimumZoomScale = 0.7;
    scrollView.maximumZoomScale = 1.5;
    [self.view addSubview:scrollView];
    scrollView.contentSize = self.view.bounds.size;
    
    imageView = [[UIImageView alloc]initWithFrame:self.view.bounds];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [scrollView addSubview:imageView];
}

-(void)viewDidLoad{
    [super viewDidLoad];
    imageView.image = _image;
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)theScroll{
    return imageView;
}


- (void)scrollViewDidScroll:(UIScrollView *)theScroll{
    //如果图片缩放比例小于1，则居中
    //如果大于一，则左上角对齐
    if (scrollView.zoomScale<1) {
        //居中
        imageView.center = CGPointMake(160, 200);
    }else{
        CGRect scrollViewFrame = imageView.frame;
        scrollViewFrame.origin = CGPointMake(0, 0);
        imageView.frame = scrollViewFrame;
    }
}
@end
