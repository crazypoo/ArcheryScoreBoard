//
//  CGSettingHeader.m
//  CloudGateCustom
//
//  Created by 邓杰豪 on 2019/1/29.
//  Copyright © 2019年 邓杰豪. All rights reserved.
//

#import "CGSettingHeader.h"
#import <Masonry/Masonry.h>
#import "CGBaseGobalTools.h"
#import "CGBaseMarcos.h"

@implementation CGSettingHeader
-(instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.contentView.backgroundColor = [CGBaseGobalTools AppTableBGColor];
        [self configSubView];
    }
    return self;
}

-(void)configSubView
{
    self.hTitle = [UILabel new];
    self.hTitle.font = AppFontNormal;
    self.hTitle.textColor = [UIColor whiteColor];
    self.hTitle.textAlignment = NSTextAlignmentCenter;
    if ([[CGBaseGobalTools getBundleID] isEqualToString:@"com.crazykidhao.LandloardTool"]) {
        self.hTitle.backgroundColor = [CGBaseGobalTools AppAlertButtonColor];
    }
    else if ([[CGBaseGobalTools getBundleID] isEqualToString:@"com.crazykidhao.CloudGateCustom"]) {
        self.hTitle.backgroundColor = [CGBaseGobalTools AppOrange];
    }
    else
    {
        self.hTitle.backgroundColor = [CGBaseGobalTools AppOrange];
    }
    [self addSubview:self.hTitle];
    [self.hTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(ViewSpace);
        make.right.equalTo(self).offset(-ViewSpace);
        make.top.equalTo(self).offset(CellHeaderHeighSpace);
        make.bottom.equalTo(self).offset(-CellHeaderHeighSpace);
    }];
    kViewBorderRadius(self.hTitle, AppRadius, 0, kClearColor);
}

@end
