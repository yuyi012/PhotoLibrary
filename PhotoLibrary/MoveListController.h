//
//  MoveListController.h
//  PhotoLibrary
//
//  Created by 刘 大兵 on 12-5-16.
//  Copyright (c) 2012年 中华中等专业学校. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MoveListController : UIViewController<UITableViewDelegate,UITableViewDataSource>{
    UITableView *DataTable;
    //从assetlibrary读出的视频
    NSMutableArray *assetArray;
    //从资源读出的视频
    NSMutableArray *fileArray;
}
@end
