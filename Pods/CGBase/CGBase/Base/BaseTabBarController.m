//
//  BaseTabBarController.m
//  OC-Base
//
//  Created by MYX on 2017/3/21.
//  Copyright © 2017年 邓杰豪. All rights reserved.
//

#import "BaseTabBarController.h"

#import <LSSafeProtector/LSSafeProtector.h>
#import "CGBaseMarcos.h"
#import "BaseViewConfig.h"
#import <PooTools/PBugReporter.h>

@interface BaseTabBarController ()
{
    UIStatusBarStyle statusStyle;
}
@end

@implementation BaseTabBarController

- (UIStatusBarStyle)preferredStatusBarStyle{
    return statusStyle;
}

-(void)setStatusBar:(UIStatusBarStyle)style
{
    statusStyle = style;
    [self setNeedsStatusBarAppearanceUpdate];
}

- (void)dealloc
{
    NSLog(@"TabBarController Dealloc: %@", self);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 49)];
    self.tabBar.opaque = YES;
    
    NSLog(@"TabBarController viewDidLoad: %@", self);
    BOOL isDEBUG;
#if DEBUG
    isDEBUG = YES;
#else
    isDEBUG = NO;
#endif
    [LSSafeProtector openSafeProtectorWithIsDebug:isDEBUG block:^(NSException *exception, LSSafeProtectorCrashType crashType) {
        [PBugReporter TakeException:exception];
        //        //此方法方便在bugly后台查看bug崩溃位置，而不用点击跟踪数据，再点击crash_attach.log来查看崩溃位置
        //        [Bugly reportExceptionWithCategory:3 name:exception.name reason:[NSString stringWithFormat:@"%@  崩溃位置:%@",exception.reason,exception.userInfo[@"location"]] callStack:@[exception.userInfo[@"callStackSymbols"]] extraInfo:exception.userInfo terminateApp:NO];
    }];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setStatusBar:UIStatusBarStyleDefault];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setNav:(UIColor *)navColor hideLine:(BOOL)isHideLine tintColor:(UIColor *)tColor
{
    if (navColor == [CGBaseGobalTools AppWhite]) {
        [self.navigationController.navigationBar setTintColor:tColor];
        [self setStatusBar:UIStatusBarStyleDefault];
    }
    else
    {
        [self setStatusBar:UIStatusBarStyleLightContent];
        [self.navigationController.navigationBar setTintColor:[CGBaseGobalTools AppWhite]];
    }
    
    [self.navigationController.navigationBar setBackgroundImage:[BaseViewConfig createImageWithColor:navColor] forBarMetrics:UIBarMetricsDefault];
    if (isHideLine) {
        [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    }
}

@end
