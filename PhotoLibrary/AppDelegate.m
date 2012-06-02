//
//  AppDelegate.m
//  PhotoLibrary
//
//  Created by 刘 大兵 on 12-5-11.
//  Copyright (c) 2012年 中华中等专业学校. All rights reserved.
//

#import "AppDelegate.h"
#import "PhotoPickerController.h"
#import "ALAssetsController.h"
#import "MoveListController.h"

@implementation AppDelegate

@synthesize window = _window;

- (void)dealloc
{
    [_window release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
    UITabBarController *tabBarController = [[UITabBarController alloc]init];
    //使用UIImagePickerController选取照片
    PhotoPickerController *pickerController = [[PhotoPickerController alloc]init];
    ALAssetsController *asssetsGroupController = [[ALAssetsController alloc]init];
    MoveListController *movieListController =[[MoveListController alloc]init];
    UINavigationController *assetsNav = [[UINavigationController alloc]initWithRootViewController:asssetsGroupController];
    UINavigationController *moviewNav = [[UINavigationController alloc]initWithRootViewController:movieListController];
    [tabBarController setViewControllers:[NSArray arrayWithObjects:pickerController,assetsNav,moviewNav,nil]];
    [asssetsGroupController release];
    [assetsNav release];
    [moviewNav release];
    [movieListController release];
    self.window.rootViewController = tabBarController;
    [tabBarController release];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

@end
