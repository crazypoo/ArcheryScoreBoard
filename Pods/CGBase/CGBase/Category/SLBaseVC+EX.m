//
//  SLBaseVC+EX.m
//  CloudGateCustom
//
//  Created by 邓杰豪 on 2018/7/31.
//  Copyright © 2018年 邓杰豪. All rights reserved.
//

#import "SLBaseVC+EX.h"
#import <PooTools/PMacros.h>
#import "CGBaseMarcos.h"
#import <PooTools/UIView+ModifyFrame.h>
#import <PooTools/UIButton+ImageTitleSpacing.h>
#import "CGBaseGobalTools.h"

@implementation SL_BaseViewController (EX)

-(void)setNavBack:(NSString *)title
{
    UIColor *navBackBtnColor;
    if ([[CGBaseGobalTools getBundleID] isEqualToString:@"com.crazykidhao.LandloardTool"]) {
        navBackBtnColor = [CGBaseGobalTools AppAlertButtonColor];
    }
    else if ([[CGBaseGobalTools getBundleID] isEqualToString:@"com.crazykidhao.CloudGateCustom"]) {
        navBackBtnColor = [CGBaseGobalTools AppOrange];
    }
    else
    {
        navBackBtnColor = [CGBaseGobalTools AppBlue];
    }
    
    [self.navigationBar.btnBack setImage:kImageNamed(@"image_Back") forState:UIControlStateNormal];
    [self.navigationBar.btnBack setTitle:title forState:UIControlStateNormal];
    [self.navigationBar.btnBack setTitleColor:navBackBtnColor forState:UIControlStateNormal];
    self.navigationBar.btnBack.titleLabel.font = AppLargeTitleFont_BOLD;
    [self.navigationBar.btnBack layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleLeft imageTitleSpace:BackBtnSpace];
    self.navigationBar.btnBack.width = BackImageW+BackBtnSpace+AppLargeTitleFont_SIZE*self.navigationBar.btnBack.titleLabel.text.length;
}

-(void)setNavBack_White:(NSString *)title
{
    [self.navigationBar.btnBack setImage:[CGBaseGobalTools image:@"image_back_white" compatibleWithTraitCollection:self.traitCollection] forState:UIControlStateNormal];
    [self.navigationBar.btnBack setTitle:title forState:UIControlStateNormal];
    [self.navigationBar.btnBack setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.navigationBar.btnBack.titleLabel.font = AppLargeTitleFont_BOLD;
    [self.navigationBar.btnBack layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleLeft imageTitleSpace:BackBtnSpace];
    self.navigationBar.btnBack.width = BackImageW+BackBtnSpace+AppLargeTitleFont_SIZE*self.navigationBar.btnBack.titleLabel.text.length;
}

@end
