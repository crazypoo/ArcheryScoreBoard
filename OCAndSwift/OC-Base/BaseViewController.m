//
//  BaseViewController.m
//  OC-Base
//
//  Created by MYX on 2017/3/21.
//  Copyright © 2017年 邓杰豪. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@property (nonatomic, strong) UIView * buttomView;

@end

@implementation BaseViewController

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
    
    if (self.buttomView) {
        if (!self.buttomView.superview) {
            [self.navigationController.view addSubview:self.buttomView];
            [self.buttomView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.buttomView.superview);
                make.right.equalTo(self.buttomView.superview);
                make.bottom.equalTo(self.buttomView.superview.mas_bottom).offset(self.buttomView.frame.size.height);
            }];
            self.buttomView.alpha = 0.0;
            [self.buttomView.superview layoutIfNeeded];
        }
        __weak typeof(self) weakself = self;
        [self.buttomView.layer removeAllAnimations];
        [UIView animateWithDuration:0.3 animations:^{
            [weakself.buttomView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(weakself.buttomView.superview.mas_bottom);
            }];
            [weakself.buttomView.superview layoutIfNeeded];
            self.buttomView.alpha = 1.0;
        }];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    __weak typeof(self) weakself = self;
    if (self.buttomView) {
        [self.buttomView.layer removeAllAnimations];
        [UIView animateWithDuration:0.3 animations:^{
            weakself.buttomView.alpha = 0.0;
        } completion:^(BOOL finished) {
            if (finished) {
                [weakself.buttomView removeFromSuperview];
                weakself.buttomView = nil;
            }
        }];
    }
}

- (void)dealloc
{
    NSLog(@"ViewController Dealloc: %@", self);
}

- (void)viewDidLoad
{
    NSLog(@"ViewController ViewDidLoad: %@", self);
    
    [super viewDidLoad];
    
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (UIView *)buttomView {
    if (!_buttomView) {
        _buttomView = [self setNavigationBottomView];
    }
    return _buttomView;
}

- (UIView *) setNavigationBottomView {
    return nil;

}

@end

