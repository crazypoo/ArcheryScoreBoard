//
//  BaseTableViewController.m
//  OC-Base
//
//  Created by MYX on 2017/3/21.
//  Copyright © 2017年 邓杰豪. All rights reserved.
//

#import "BaseTableViewController.h"

#import <LSSafeProtector/LSSafeProtector.h>
#import "CGBaseMarcos.h"
#import "BaseViewConfig.h"
#import <PooTools/PBugReporter.h>
#import <Masonry/Masonry.h>
#import <PooTools/NSString+WPAttributedMarkup.h>

@interface BaseTableViewController ()
{
    UIStatusBarStyle statusStyle;
}
@property (nonatomic, strong) UIView * buttomView;

@end

@implementation BaseTableViewController

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
    NSLog(@"TableViewController Dealloc: %@", self);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"ViewController viewDidLoad: %@", self);
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
    
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    self.tableView.backgroundColor = [CGBaseGobalTools AppWhite];
    self.tableView.tableFooterView = [UIView new];
    
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setStatusBar:UIStatusBarStyleDefault];

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
    return AppNullDataImage;
}

- (nullable NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *emptyString = AppNullDataString;
    NSString *emptyTapString = AppNullDataTapString;
    NSDictionary *style = @{
                            @"HEAD":@[AppFontNormal,[CGBaseGobalTools AppRed]],
                            @"END":@[AppFontNormal,[CGBaseGobalTools AppGray]]
                            };
    
    return [[NSString stringWithFormat:@"<HEAD>%@</HEAD>\n<END>%@</END>",emptyString,emptyTapString] attributedStringWithStyleBook:style];
}
    
- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView {
    return NO;
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
