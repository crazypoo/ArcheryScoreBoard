//
//  ZAlertView.m
//  顶部提示
//
//  Created by YYKit on 2017/5/27.
//  Copyright © 2017年 YZ. All rights reserved.
//

#import "ZAlertView.h"
#import <PooTools/UIImage+BlurGlass.h>
#import <Masonry/Masonry.h>
#import <PooTools/PMacros.h>
#import "CGBaseMarcos.h"
#import "CGBaseGobalTools.h"

#define Font_Size 20.0f

@implementation ZAlertView

#pragma mark 初始化
- (instancetype)init
{
    self = [super init];
    if (self)
    {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(removeAlert)];
        [tap setCancelsTouchesInView:NO];
        [self addGestureRecognizer:tap];
        
        if (_bgView == nil) {
            _bgView = [UIImageView new];
            [self addSubview:_bgView];
            [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
                if (@available(iOS 13.0, *)) {
                    make.left.right.bottom.equalTo(self);
                    make.top.equalTo(self).offset(HEIGHT_STATUS);
                } else {
                    make.left.right.top.bottom.equalTo(self);
                }
            }];
        }
        
        if (@available(iOS 13.0, *)) {
            kViewBorderRadius(self.bgView, AppRadius*2, 0, kClearColor);
        }

        if (_alertInfoView == nil) {
            _alertInfoView = [UIView new];
            [self addSubview:_alertInfoView];
            [self.alertInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.width.right.equalTo(self);
                make.height.offset(NavigationBarNormalHeight-HEIGHT_STATUS);
                make.top.equalTo(self.mas_bottom).offset(-(NavigationBarNormalHeight-HEIGHT_STATUS));
            }];
        }
        
        if (_imageView == nil)
        {
            _imageView = [[UIImageView alloc]init];
            [self.alertInfoView addSubview:_imageView];
            [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.alertInfoView.mas_centerY);
                make.left.equalTo(self.alertInfoView).offset(ViewSpace);
                make.width.height.offset(24);
            }];
        }
        
        if (_tipsLabel == nil)
        {
            _tipsLabel = [[UILabel alloc]init];
            _tipsLabel.numberOfLines = 0;
            _tipsLabel.lineBreakMode = NSLineBreakByCharWrapping;
            _tipsLabel.textAlignment = NSTextAlignmentLeft;
            _tipsLabel.font = APPFONT(Font_Size);
            [self.alertInfoView addSubview:_tipsLabel];
            [self.tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.imageView.mas_right).offset(10);
                make.right.equalTo(self.alertInfoView.mas_right).offset(-10);
                make.top.height.equalTo(self.alertInfoView);
            }];
        }
    }
    return self;
}

- (void)removeAlert
{
    [self dismiss];
}

// 改变UIColor的Alpha
- (UIColor *)getNewColorWith:(UIColor *)color {
    CGFloat red = 0.0;
    CGFloat green = 0.0;
    CGFloat blue = 0.0;
    CGFloat alpha = 0.0;
    [color getRed:&red green:&green blue:&blue alpha:&alpha];
    UIColor *newColor = [UIColor colorWithRed:red green:green blue:blue alpha:0.8];
    return newColor;
}

#pragma mark 设置type
- (void)topAlertViewTypewWithType:(AlertViewType)type title:(NSString *)title
{
    self.navH = NavigationBarNormalHeight;
    
    if (@available(iOS 13.0, *)) {
        self.frame = CGRectMake(ViewSpace, -self.navH, kSCREEN_WIDTH-ViewSpace*2, self.navH);
    }
    else
    {
        self.frame = CGRectMake(0, -self.navH, kSCREEN_WIDTH, self.navH);
    }
    
    self.backgroundColor = kClearColor;
    self.tipsLabel.text = title;

    UIColor *normalColor = [CGBaseGobalTools AppCellBGColor];
    UIColor *errorColor = [CGBaseGobalTools AppRed];
    UIColor *textColor;

    NSString *successName;
    NSString *noNetWorkName = @"image_zalert_nonetwork";
    NSString *errorName = @"image_zalert_error";
    NSString *wifiName;
    NSString *refreshName;
    NSString *mobileName;
    
    if ([[CGBaseGobalTools getBundleID] isEqualToString:@"com.crazykidhao.LandloardTool"]) {
        successName = @"image_zalert_done_l";
        wifiName = @"image_zalert_wifi_l";
        refreshName = @"image_zalert_refresh_l";
        mobileName = @"image_zalert_mobile_l";
        textColor = [CGBaseGobalTools AppAlertButtonColor];
    }
    else if ([[CGBaseGobalTools getBundleID] isEqualToString:@"com.crazykidhao.CloudGateCustom"]) {
        successName = @"image_zalert_done_c";
        wifiName = @"image_zalert_wifi_c";
        refreshName = @"image_zalert_refresh_c";
        mobileName = @"image_zalert_mobile_c";
        textColor = [CGBaseGobalTools AppOrange];
    }
    else
    {
        successName = @"image_zalert_done_l";
        wifiName = @"image_zalert_wifi_l";
        refreshName = @"image_zalert_refresh_l";
        mobileName = @"image_zalert_mobile_l";
        textColor = [CGBaseGobalTools AppAlertButtonColor];
    }
    
    switch (type)
    {
        case AlertViewTypeSuccess:
        {
            self.bgView.image = [[Utils createImageWithColor:[self getNewColorWith:normalColor]] imgWithBlur];
            self.imageView.image = [CGBaseGobalTools image:successName compatibleWithTraitCollection:self.traitCollection];
            self.tipsLabel.textColor = textColor;
        }
            break;
        case AlertViewTypeError:
        {
            self.bgView.image = [[Utils createImageWithColor:[self getNewColorWith:errorColor]] imgWithBlur];
            self.imageView.image = [CGBaseGobalTools image:errorName compatibleWithTraitCollection:self.traitCollection];
            self.tipsLabel.textColor = textColor;
        }
            break;
        case AlertViewTypeMessage:
        {
            self.bgView.image = [[Utils createImageWithColor:[self getNewColorWith:normalColor]] imgWithBlur];
            self.imageView.image = [CGBaseGobalTools image:noNetWorkName compatibleWithTraitCollection:self.traitCollection];
            self.tipsLabel.textColor = textColor;
        }
            break;
        case AlertViewTypeHouseMessage:
        {
            self.bgView.image = [[Utils createImageWithColor:[self getNewColorWith:normalColor]] imgWithBlur];
            self.imageView.image = [CGBaseGobalTools image:noNetWorkName compatibleWithTraitCollection:self.traitCollection];
            self.tipsLabel.textColor = textColor;
        }
            break;
        case AlertViewTypeNetStatusNo:
        {
            self.bgView.image = [[Utils createImageWithColor:[self getNewColorWith:errorColor]] imgWithBlur];
            self.imageView.image = [CGBaseGobalTools image:noNetWorkName compatibleWithTraitCollection:self.traitCollection];
            self.tipsLabel.textColor = [UIColor whiteColor];
        }
            break;
        case AlertViewTypeNetStatusWifi:
        {
            self.bgView.image = [[Utils createImageWithColor:[self getNewColorWith:normalColor]] imgWithBlur];
            self.imageView.image = [CGBaseGobalTools image:wifiName compatibleWithTraitCollection:self.traitCollection];
            self.tipsLabel.textColor = textColor;
        }
            break;
        case AlertViewTypeNetStatusMobile:
        {
            self.bgView.image = [[Utils createImageWithColor:[self getNewColorWith:normalColor]] imgWithBlur];
            self.imageView.image = [CGBaseGobalTools image:mobileName compatibleWithTraitCollection:self.traitCollection];
            self.tipsLabel.textColor = textColor;
        }
            break;
        case AlertViewTypeRefreshing:
        {
            self.bgView.image = [[Utils createImageWithColor:[self getNewColorWith:normalColor]] imgWithBlur];
            self.imageView.image = [CGBaseGobalTools image:refreshName compatibleWithTraitCollection:self.traitCollection];
            self.tipsLabel.textColor = textColor;
        }
            break;
        case AlertViewTypeNoMore:
        {
            self.bgView.image = [[Utils createImageWithColor:[self getNewColorWith:normalColor]] imgWithBlur];
            self.imageView.image = [CGBaseGobalTools image:noNetWorkName compatibleWithTraitCollection:self.traitCollection];
            self.tipsLabel.textColor = textColor;
        }
            break;
        default:
            break;
    }
}

#pragma mark 显示
- (void)show
{
    [UIView animateWithDuration:0.618f
                          delay:0
         usingSpringWithDamping:0.9f
          initialSpringVelocity:10.0f
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.center = CGPointMake(self.center.x, self.navH/2);
                         [kAppDelegateWindow addSubview:self];
                     }
                     completion:^(BOOL finished) {
                     }];

}

#pragma mark 移除
- (void)dismiss
{
    [UIView animateWithDuration:0.618f
                          delay:0
         usingSpringWithDamping:0.99f
          initialSpringVelocity:15.0f
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.center = CGPointMake(self.center.x, -(self.navH/2));
                     }
                     completion:^(BOOL finished) {
                         [self removeFromSuperview];
                     }];

}


@end
