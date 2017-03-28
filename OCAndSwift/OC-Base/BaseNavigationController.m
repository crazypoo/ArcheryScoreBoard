//
//  BaseNavigationController.m
//  OC-Base
//
//  Created by MYX on 2017/3/21.
//  Copyright © 2017年 邓杰豪. All rights reserved.
//

#import "BaseNavigationController.h"

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
    if (self.navColor) {
        [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
        [self.navigationController.navigationBar setBackgroundImage:[BaseViewConfig createImageWithColor:self.navColor] forBarMetrics:UIBarMetricsDefault];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    }
    else
    {
        [self.navigationController.navigationBar setBackgroundImage:[BaseViewConfig createImageWithColor:[UIColor whiteColor]] forBarMetrics:UIBarMetricsDefault];
    }
    
    if (self.isHideNavLine) {
        navigationImageView = [BaseViewConfig findHairlineImageViewUnder:self.navigationController.navigationBar];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(themeNotification:) name:ThemeChangeNotification object:nil];

}

- (void)themeNotification:(NSNotification *)notification {
    [self loadThemeImage];
}

- (void)loadThemeImage {
    
    self.navigationController.navigationBar.barTintColor = [[PConfigurationTheme shareInstance] getThemeColorWithName:@"ygColor"];
    self.view.backgroundColor = [[PConfigurationTheme shareInstance] getThemeColorWithName:@"ygColor"];
    
    if ([[PConfigurationTheme shareInstance].themeName isEqualToString:@"默认"]) {
        if (self.navColor) {
            [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
            [self.navigationController.navigationBar setBackgroundImage:[BaseViewConfig createImageWithColor:self.navColor] forBarMetrics:UIBarMetricsDefault];
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        }
        else
        {
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
            
        }
    }
    else
    {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    if (self.isHideNavLine) {
        navigationImageView.hidden = NO;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.isHideNavLine) {
        navigationImageView.hidden = YES;
    }
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

@end

