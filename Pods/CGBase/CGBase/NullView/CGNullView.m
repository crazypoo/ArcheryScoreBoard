//
//  CGNullView.m
//  CloudGateCustom
//
//  Created by 邓杰豪 on 2019/3/25.
//  Copyright © 2019年 邓杰豪. All rights reserved.
//

#import "CGNullView.h"

#import "CGBaseMarcos.h"
#import <PooTools/NSString+WPAttributedMarkup.h>
#import <Masonry/Masonry.h>
#import "CGBaseGobalTools.h"
#import <PooTools/UIView+ModifyFrame.h>

@interface CGNullView ()
@property (nonatomic,strong) NSString *emptyInfo;
@property (nonatomic,strong) NSString *emptyTitle;
@property (nonatomic,copy) NullViewTapBlock tapBlock;
@property (nonatomic,strong) UILabel *nullLabel;
@property (nonatomic,strong) UIImageView *nullImage;
@property (nonatomic,strong) UIImage *nullImageMetaData;
@end

@implementation CGNullView

-(NSDictionary *)labelStyle:(UIFont *)font
{
    return @{
             @"HEAD":@[font,[CGBaseGobalTools AppRed]],
             @"END":@[font,[CGBaseGobalTools AppGray]]
             };
}

-(instancetype)initWithEmptyTitle:(NSString *)title withEmptyInfo:(NSString *)info handle:(NullViewTapBlock)block
{
    self = [super init];
    if (self)
    {
        self.emptyTitle = title;
        self.emptyInfo = info;
        self.tapBlock = block;
        
        [self configView];
    }
    return self;
}

-(void)configView
{
    self.nullImage = [UIImageView new];
    self.nullImage.contentMode = UIViewContentModeScaleAspectFit;
    self.nullImageMetaData = [CGBaseGobalTools image:@"image_nulldata" compatibleWithTraitCollection:self.traitCollection];
    self.nullImage.image = self.nullImageMetaData;
    [self addSubview:self.nullImage];
    
    self.nullLabel = [UILabel new];
    self.nullLabel.textAlignment = NSTextAlignmentCenter;
    self.nullLabel.numberOfLines = 0;
    self.nullLabel.lineBreakMode = NSLineBreakByCharWrapping;
    [self addSubview:self.nullLabel];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(reloadViewData)];
    tapGesture.numberOfTapsRequired    = 1;
    [self addGestureRecognizer:tapGesture];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat labelH = IS_IPAD ? 80 : NullLabelH;
    
    UIFont *font;
    UIDevice *device = [UIDevice currentDevice];
    switch (device.orientation) {
        case UIDeviceOrientationLandscapeLeft:
        {
            font = kDEFAULT_FONT(FontName, 16);
        }
            break;
         case UIDeviceOrientationLandscapeRight:
        {
            font = kDEFAULT_FONT(FontName, 16);
        }
            break;
        default:
        {
            font = AppFontNormal;
        }
            break;
    }
    
    self.nullLabel.attributedText = [[NSString stringWithFormat:@"<HEAD>%@</HEAD>\n<END>%@</END>",self.emptyTitle,self.emptyInfo] attributedStringWithStyleBook:[self labelStyle:font]];

    [self.nullImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.centerY.equalTo(self.mas_centerY).offset(-(self.nullImageMetaData.size.height/2));
        make.height.offset(self.nullImageMetaData.size.height);
        make.width.offset(self.nullImageMetaData.size.width);
    }];
    
    [self.nullLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.width.equalTo(self);
        make.top.equalTo(self.nullImage.mas_bottom);
        make.height.offset(labelH);
    }];
}

-(void)reloadViewData
{
    self.tapBlock();
}
@end
