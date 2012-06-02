//
//  MultiImagePickerController.h
//  PhotoLibrary
//
//  Created by 刘 大兵 on 12-5-14.
//  Copyright (c) 2012年 中华中等专业学校. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MultiImagePickerControllerDelegate <NSObject>
-(void)multiImagePickDone:(NSArray*)imageArray;
@end

@interface MultiImagePickerController : UIViewController<UITableViewDelegate,UITableViewDataSource>{
    UITableView *DataTable;
    NSMutableArray *imageArray;
    UIActivityIndicatorView *loadView;
    //在屏幕下方，点击了图片把图片加入到scrollView，表示已经选中
    UIScrollView *scrollView;
    NSMutableArray *selectedImageArray;
}
@property(nonatomic,assign) id<MultiImagePickerControllerDelegate> delegate;
@end
