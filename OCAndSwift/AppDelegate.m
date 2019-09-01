//
//  AppDelegate.m
//  OCAndSwift
//
//  Created by MYX on 2017/3/24.
//  Copyright © 2017年 邓杰豪. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
//微信SDK头文件
#import "WXApi.h"
//新浪微博SDK头文件
#import "WeiboSDK.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    ViewController *main = [[ViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:main];
    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];
    
    [self createInitData];
    [self initButton];
    
    [ShareSDK registPlatforms:^(SSDKRegister *platformsRegister) {
//        [platformsRegister setupQQWithAppId:TencentQQ appkey:TencentQQKEY];
        //微信
        [platformsRegister setupWeChatWithAppId:@"wxe4937e4b5579f5ed" appSecret:@"cd2fc8f9db40174fa3c2e72caa99b035"];
        //新浪
        [platformsRegister setupSinaWeiboWithAppkey:@"3120996567" appSecret:@"7c6fdf6f374524fdfb37a4b9c7286bd0" redirectUrl:@"http://github.com"];
        
        [platformsRegister setupSMSOpenCountryList:NO];
    }];

    return YES;
}

-(void)initButton
{
    _avatar = [[RCDraggableButton alloc] initInView:[AppDelegate appDelegate].window WithFrame:CGRectMake(0, 333.5, 160, 30)];
    [_avatar setTag:100];
    _avatar.backgroundColor = [UIColor redColor];
    _avatar.adjustsImageWhenHighlighted = NO;
    [_avatar setLongPressBlock:^(RCDraggableButton *avatar) {
        NSLog(@"\n\tAvatar in keyWindow ===  LongPress!!! ===");
        //More todo here.
        
    }];
    
    [_avatar setTapBlock:^(RCDraggableButton *avatar) {
        NSLog(@"\n\tAvatar in keyWindow ===  Tap!!! ===");
        //More todo here.
    }];
    
    [_avatar setDoubleTapBlock:^(RCDraggableButton *avatar) {
        NSLog(@"\n\tAvatar in keyWindow ===  DoubleTap!!! ===");
        //More todo here.
        
    }];
    
    [_avatar setDraggingBlock:^(RCDraggableButton *avatar) {
        NSLog(@"\n\tAvatar in keyWindow === Dragging!!! ===");
        //More todo here.
        
    }];
    
//    [_avatar setDragDoneBlock:^(RCDraggableButton *avatar) {
//        NSLog(@"\n\tAvatar in keyWindow === DragDone!!! ===");
//        //More todo here.
//        
//    }];
    
    [_avatar setAutoDockingBlock:^(RCDraggableButton *avatar) {
        NSLog(@"\n\tAvatar in keyWindow === AutoDocking!!! ===");
        //More todo here.
        
    }];
    
//    [_avatar setAutoDockingDoneBlock:^(RCDraggableButton *avatar) {
//        NSLog(@"\n\tAvatar in keyWindow === AutoDockingDone!!! ===");
//        //More todo here.
//        
//    }];
}

-(void)createInitData
{
    
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    NSString *pathDocuments = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    NSString *createHistoryPath = [NSString stringWithFormat:@"%@/History", pathDocuments];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:createHistoryPath]) {
        [fileManager createDirectoryAtPath:createHistoryPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    else
    {
        NSLog(@"FileDir is exists.");
    }
    
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"group.com.omcn.Archery"]) {
        [[NSUserDefaults standardUserDefaults] setObject:0 forKey:@"group.com.omcn.Archery"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }

}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

+ (AppDelegate *)appDelegate {
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

@end
