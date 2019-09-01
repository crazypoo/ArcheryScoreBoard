//
//  BaseNavigationController.m
//  OC-Base
//
//  Created by MYX on 2017/3/21.
//  Copyright © 2017年 邓杰豪. All rights reserved.
//

#import "BaseNavigationController.h"

#import <LSSafeProtector/LSSafeProtector.h>
#import <PooTools/PBugReporter.h>
#import "CGBaseMarcos.h"
#import "BaseViewConfig.h"

@interface BaseNavigationController () <UINavigationControllerDelegate>

@end

@implementation BaseNavigationController

- (void)dealloc
{
    NSLog(@"NavigationController Dealloc: %@", self);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = self;
    
    NSLog(@"NavigationController viewDidLoad: %@", self);
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
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

-(UIViewController *)childViewControllerForStatusBarStyle
{
    return self.topViewController;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)pushViewController:(UIViewController *)vc animated:(BOOL)animated {
    if (self.viewControllers.count > 0) {
        vc.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:vc animated:animated];
}

- (nullable UIViewController *)popViewControllerAnimated:(BOOL)animated {
    return [super popViewControllerAnimated:animated];
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    viewController.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStylePlain target:nil action:nil];

}
    
-(void)setNav:(UIColor *)navColor hideLine:(BOOL)isHideLine tintColor:(UIColor *)tColor
{
    if (navColor == [CGBaseGobalTools AppWhite]) {
        [self.navigationController.navigationBar setTintColor:tColor];
//        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    }
    else
    {
//        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        [self.navigationController.navigationBar setTintColor:[CGBaseGobalTools AppWhite]];
    }
    
    [self.navigationController.navigationBar setBackgroundImage:[BaseViewConfig createImageWithColor:navColor] forBarMetrics:UIBarMetricsDefault];
    if (isHideLine) {
        [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    }
}

@end

