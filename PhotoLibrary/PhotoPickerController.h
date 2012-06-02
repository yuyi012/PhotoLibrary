//
//  PhotoPickerController.h
//  PhotoLibrary
//
//  Created by 刘 大兵 on 12-5-11.
//  Copyright (c) 2012年 中华中等专业学校. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MultiImagePickerController.h"

@interface PhotoPickerController : UIViewController<UINavigationControllerDelegate, UIImagePickerControllerDelegate,MultiImagePickerControllerDelegate>{
    IBOutlet UIImageView *displayImageView;
    //提前初始化好，因为在点按钮以后再初始化会造成1到2秒的延迟
    UIImagePickerController *pickerController;
}
-(IBAction)pickerButton:(id)sender;
-(IBAction)cameraButton:(id)sender;
@end
