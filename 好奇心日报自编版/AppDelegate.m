//
//  AppDelegate.m
//  好奇心日报自编版
//
//  Created by qianfeng on 15/10/30.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "AppDelegate.h"
#import "LeftSlideViewController.h"
#import "LeftVC.h"
#import "ContentVC.h"
#import "MagicalRecord.h"
#import "CoreAnimLaunchImageView.h"
#import "UMSocial.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    [UMSocialData setAppKey:@"56171e5867e58eed0a0003c9"];
    
     [MagicalRecord setupCoreDataStackWithStoreNamed:@"FirstBlood.sqlite"];
    
    self.window=[[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor=[UIColor clearColor];
    [self.window makeKeyAndVisible];

    LeftVC *lvc=[LeftVC new];
    ContentVC *cvc=[ContentVC new];
    LeftSlideViewController *VC=[[LeftSlideViewController alloc] initWithLeftView:lvc andMainView:[[UINavigationController alloc]initWithRootViewController: cvc ]];
    cvc.block=^(){
        [VC openLeftView];
    };
    lvc.delegate=cvc;
    
    lvc.block=^(){
        [VC closeLeftView];
    };
    [VC setPanEnabled:YES];
    self.window.rootViewController=VC;

    [CoreAnimLaunchImageView show];

    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    //在程序结束时，结束所有对数据库的操作
    [MagicalRecord cleanUp];
}

@end
