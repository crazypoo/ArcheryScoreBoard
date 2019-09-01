//
//  CGMessageTableViewHeader.m
//  LandloardTool
//
//  Created by 邓杰豪 on 2019/2/17.
//  Copyright © 2019年 邓杰豪. All rights reserved.
//

#import "CGMessageTableViewHeader.h"
#import <Masonry/Masonry.h>
#import "CGBaseGobalTools.h"
#import "CGBaseMarcos.h"

@implementation CGMessageTableViewHeader

-(instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self configSubView];
    }
    return self;
}

-(void)configSubView
{
    self.backgroundView = ({
        UIView * view = [[UIView alloc] initWithFrame:self.bounds];
        view.backgroundColor = [CGBaseGobalTools AppTableBGColor];
        view;
    });
    
    UIView *headerView = [UIView new];
    if ([[CGBaseGobalTools getBundleID] isEqualToString:@"com.crazykidhao.LandloardTool"]) {
        headerView.backgroundColor = [CGBaseGobalTools AppAlertButtonColor];
    }
    else if ([[CGBaseGobalTools getBundleID] isEqualToString:@"com.crazykidhao.CloudGateCustom"]) {
        headerView.backgroundColor = [CGBaseGobalTools AppOrange];
    }
    else
    {
        headerView.backgroundColor = [CGBaseGobalTools AppBlue];
    }
    [self.contentView addSubview:headerView];
    [headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(ViewSpace);
        make.right.equalTo(self.contentView).offset(-ViewSpace);
        make.top.equalTo(self.contentView).offset(CellHeaderHeighSpace);
        make.bottom.equalTo(self.contentView).offset(-CellHeaderHeighSpace);
    }];
    kViewBorderRadius(headerView, AppRadius, 0, kClearColor);

    self.hTitle = [UILabel new];
    self.hTitle.font = AppLargeTitleFont_BOLD;
    self.hTitle.textColor = [UIColor whiteColor];
    self.hTitle.textAlignment = NSTextAlignmentCenter;
    [headerView addSubview:self.hTitle];
    [self.hTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(self);
        make.centerX.centerY.equalTo(headerView);
    }];
    
    self.indicatorView = [UIButton buttonWithType:UIButtonTypeCustom];
    self.indicatorView.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.indicatorView setImage:[CGBaseGobalTools image:@"image_arrow_white_right" compatibleWithTraitCollection:kAppDelegateWindow.rootViewController.traitCollection] forState:UIControlStateSelected];
    [self.indicatorView setImage:[CGBaseGobalTools image:@"image_arrow_white_down" compatibleWithTraitCollection:kAppDelegateWindow.rootViewController.traitCollection] forState:UIControlStateNormal];
    [self.contentView addSubview:self.indicatorView];
    [self.indicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.offset(RightArrowWH);
        make.right.equalTo(headerView).offset(-5);
        make.centerY.equalTo(headerView);
    }];
}

@end
