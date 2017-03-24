//
//  BaseTableViewController.m
//  OC-Base
//
//  Created by MYX on 2017/3/21.
//  Copyright © 2017年 邓杰豪. All rights reserved.
//

#import "BaseTableViewController.h"

@interface BaseTableViewController ()<DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>


@property (nonatomic, strong) UIView * buttomView;

@end

@implementation BaseTableViewController

- (void)dealloc
{
    NSLog(@"TableViewController Dealloc: %@", self);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"ViewController viewDidLoad: %@", self);
    
    if (self.navColor) {
        [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
        [self.navigationController.navigationBar setBackgroundImage:[BaseViewConfig createImageWithColor:self.navColor] forBarMetrics:UIBarMetricsDefault];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    }
    
    if (self.isHideNavLine) {
        navigationImageView = [BaseViewConfig findHairlineImageViewUnder:self.navigationController.navigationBar];
    }

    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.tableFooterView = [UIView new];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(themeNotification:) name:ThemeChangeNotification object:nil];

}

- (void)themeNotification:(NSNotification *)notification {
    [self loadThemeImage];
}

- (void)loadThemeImage {
    
    //使用颜色设置navigationBar的背景颜色
    self.navigationController.navigationBar.barTintColor = [[PConfigurationTheme shareInstance] getThemeColorWithName:@"ygColor"];
    self.tableView.backgroundColor = [[PConfigurationTheme shareInstance] getThemeColorWithName:@"ygColor"];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (nullable UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"test"];
}

- (nullable NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    return [[NSAttributedString alloc] initWithString:@"aaaaaaaaa"];
}

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView {
    return YES;
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
