//
//  CGCheckPrivacyView.m
//  CloudGateCustom
//
//  Created by 邓杰豪 on 2019/5/10.
//  Copyright © 2019 邓杰豪. All rights reserved.
//

#import "CGCheckPrivacyView.h"

#import <Masonry/Masonry.h>
#import <PooTools/PMacros.h>
#import "CGBaseGobalTools.h"
#import "CGBaseMarcos.h"
#import <PooTools/UIButton+ImageTitleSpacing.h>
#import <PooTools/UIButton+Block.h>

@interface CGCheckPrivacyView ()
@property (nonatomic, assign)BOOL checkDone;
@property (nonatomic, strong)UIButton *doneBtn;
@end

@implementation CGCheckPrivacyView

-(NSArray *)privacyArr
{
    return @[@"获取定位权限",@"获取相机权限",@"获取相册权限"];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    kWeakSelf(self);

    UIView *customView = [UIView new];
    customView.backgroundColor = [CGBaseGobalTools AppWhite];
    [self addSubview:customView];
    [customView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(250);
        make.height.offset(CellHeight*self.privacyArr.count+GobalViewAndViewSpace*(self.privacyArr.count+1));
        make.centerY.centerX.equalTo(self);
    }];
    kViewBorderRadius(customView, AppRadius, 0, kClearColor);
    
    for (int i = 0; i < self.privacyArr.count; i++) {
        UIButton *pBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [pBtn setTitleColor:[CGBaseGobalTools AppBlue] forState:UIControlStateNormal];
        [pBtn setTitle:self.privacyArr[i] forState:UIControlStateNormal];
        pBtn.tag = i;
        [pBtn setImage:kImageNamed(@"weixuanzhong_icon") forState:UIControlStateNormal];
        [pBtn setImage:kImageNamed(@"xuanzhong_icon") forState:UIControlStateSelected];
        [pBtn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleLeft imageTitleSpace:10];
        [pBtn addActionHandler:^(UIButton *sender) {
            if (!sender.selected) {
                [weakself check:i withSender:sender];
            }
        }];
        [customView addSubview:pBtn];
        [pBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.offset(CellHeight);
            make.left.right.equalTo(customView);
            make.top.equalTo(customView).offset(GobalViewAndViewSpace+CellHeight*i+GobalViewAndViewSpace*i);
        }];
        [self check:i withSender:pBtn];
    }
    
    UILabel *customLabel = [UILabel new];
    customLabel.font = AppLargeTitleFont_BOLD;
    customLabel.textAlignment = NSTextAlignmentCenter;
    customLabel.textColor = [CGBaseGobalTools AppWhite];
    customLabel.text = @"应用获取对应权限,以便获取更好的体验!";
    [self addSubview:customLabel];
    [customLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.bottom.equalTo(customView.mas_top).offset(-GobalViewAndViewSpace);
        make.height.offset(30);
    }];
    
    self.doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.doneBtn.backgroundColor = [CGBaseGobalTools AppWhite];
    [self.doneBtn setTitleColor:[CGBaseGobalTools AppBlue] forState:UIControlStateNormal];
    [self.doneBtn setTitle:@"完成" forState:UIControlStateNormal];
    [self.doneBtn addActionHandler:^(UIButton *sender) {
        weakself.dismissBlock();
    }];
    [self addSubview:self.doneBtn];
    [self.doneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(customView);
        make.height.offset(ButtonH);
        make.top.equalTo(customView.mas_bottom).offset(GobalViewAndViewSpace);
    }];
    kViewBorderRadius(self.doneBtn, AppRadius, 0, kClearColor);
}

-(void)check:(NSInteger)i withSender:(UIButton *)sender
{
    PrivacyPermissionType type;
    switch (i) {
        case 0:
        {
            type = PrivacyPermissionTypeLocation;
        }
            break;
        case 1:
        {
            type = PrivacyPermissionTypeCamera;
        }
            break;
        case 2:
        {
            type = PrivacyPermissionTypePhoto;
        }
            break;
        default:
        {
            type = PrivacyPermissionTypeLocation;
        }
            break;
    }
    [[PrivacyPermission sharedInstance] accessPrivacyPermissionWithType:type completion:^(BOOL response, PrivacyPermissionAuthorizationStatus status) {
        GCDWithMain(^{
            sender.selected = (status != PrivacyPermissionAuthorizationStatusDenied) ? YES : NO;
        });
    }];
}

-(void)check:(void (^)(BOOL status))block
{
    __block BOOL a;
    __block BOOL b;
    __block BOOL c;
    
    [[PrivacyPermission sharedInstance] accessPrivacyPermissionWithType:PrivacyPermissionTypeLocation completion:^(BOOL response, PrivacyPermissionAuthorizationStatus status) {
        a = response;
        [[NSUserDefaults standardUserDefaults] setBool:response forKey:kUserSetLocation];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }];
    
    [[PrivacyPermission sharedInstance] accessPrivacyPermissionWithType:PrivacyPermissionTypeCamera completion:^(BOOL response, PrivacyPermissionAuthorizationStatus status) {
        b = response;
    }];
    
    [[PrivacyPermission sharedInstance] accessPrivacyPermissionWithType:PrivacyPermissionTypePhoto completion:^(BOOL response, PrivacyPermissionAuthorizationStatus status) {
        c = response;
    }];
    
    if (a || b || c) {
        block(YES);
    }
    else
    {
        block(NO);
    }
}
@end
