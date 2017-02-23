//
//  AppDelegate.m
//  Archery Score
//
//  Created by Staff on 2017/2/14.
//  Copyright © 2017年 邓杰豪. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"

#import "UIViewController+Swizzled.h"
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
    SWIZZ_IT;

    [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, DEFAULT_FONT(FontName,24), NSFontAttributeName, nil]];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent ;

    ViewController *mainView = [[ViewController alloc] init];
    UINavigationController *mainNav = [[UINavigationController alloc] initWithRootViewController:mainView];
    self.window.rootViewController = mainNav;
    [self.window makeKeyAndVisible];

    [self createInitData];

    [IMSdk initWithAccountID:@"99ddbda039274043bdfc7998f386d0ba"];
    [IMSdk setLogLevel:kIMSDKLogLevelDebug];

    [IMSdk setGender:kIMSDKGenderFemale];
    [IMSdk setGender:kIMSDKGenderMale];
    [IMSdk setAgeGroup:kIMSDKAgeGroupBelow18];
    [IMSdk setAgeGroup:kIMSDKAgeGroupBetween18And20];
    [IMSdk setAgeGroup:kIMSDKAgeGroupBetween21And24];
    [IMSdk setAgeGroup:kIMSDKAgeGroupBetween25And34];
    [IMSdk setAgeGroup:kIMSDKAgeGroupBetween35And54];
    [IMSdk setAgeGroup:kIMSDKAgeGroupAbove55];

    CLLocationManager *mgr = [[CLLocationManager alloc] init];
    CLLocation *loc = mgr.location;
    [IMSdk setLocation:loc];

    /**
     *  设置ShareSDK的appKey，如果尚未在ShareSDK官网注册过App，请移步到http://mob.com/login 登录后台进行应用注册
     *  在将生成的AppKey传入到此方法中。
     *  方法中的第二个第三个参数为需要连接社交平台SDK时触发，
     *  在此事件中写入连接代码。第四个参数则为配置本地社交平台时触发，根据返回的平台类型来配置平台信息。
     *  如果您使用的时服务端托管平台信息时，第二、四项参数可以传入nil，第三项参数则根据服务端托管平台来决定要连接的社交SDK。
     */
    [ShareSDK registerApp:@"iosv1101"

          activePlatforms:@[
                            @(SSDKPlatformTypeSinaWeibo),
                            @(SSDKPlatformTypeMail),
                            @(SSDKPlatformTypeSMS),
                            @(SSDKPlatformTypeCopy),
                            @(SSDKPlatformTypeWechat)]
                 onImport:^(SSDKPlatformType platformType)
     {
         switch (platformType)
         {
             case SSDKPlatformTypeWechat:
                 [ShareSDKConnector connectWeChat:[WXApi class]];
                 break;
             case SSDKPlatformTypeSinaWeibo:
                 [ShareSDKConnector connectWeibo:[WeiboSDK class]];
                 break;
             default:
                 break;
         }
     }
          onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo)
     {

         switch (platformType)
         {
             case SSDKPlatformTypeSinaWeibo:
                 //设置新浪微博应用信息,其中authType设置为使用SSO＋Web形式授权
                 [appInfo SSDKSetupSinaWeiboByAppKey:@"568898243"
                                           appSecret:@"38a4f8204cc784f81f9f0daaf31e02e3"
                                         redirectUri:@"http://www.sharesdk.cn"
                                            authType:SSDKAuthTypeBoth];
                 break;
             case SSDKPlatformTypeWechat:
                 [appInfo SSDKSetupWeChatByAppId:@"wx4868b35061f87885"
                                       appSecret:@"64020361b8ec4c99936c0e3999a9f249"];
                 break;
            default:
                 break;
         }
     }];

    return YES;
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
