//
//  BaseTabBarController.m
//  OC-Base
//
//  Created by MYX on 2017/3/21.
//  Copyright © 2017年 邓杰豪. All rights reserved.
//

#import "BaseTabBarController.h"

@interface BaseTabBarController ()

@end

@implementation BaseTabBarController

- (void)dealloc
{
    NSLog(@"TabBarController Dealloc: %@", self);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 49)];
    bgView.backgroundColor = [[PConfigurationTheme shareInstance] getThemeColorWithName:@"bgColor"];
    [self.tabBar insertSubview:bgView atIndex:0];
    self.tabBar.opaque = YES;
    
    NSLog(@"TabBarController viewDidLoad: %@", self);
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
    
    bgView.backgroundColor = [[PConfigurationTheme shareInstance] getThemeColorWithName:@"bgColor"];

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
    // Dispose of any resources that can be recreated.
}

@end
