//
//  BaseTableViewCell.m
//  CloudGateCustom
//
//  Created by 邓杰豪 on 2019/3/2.
//  Copyright © 2019年 邓杰豪. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "CGBaseMarcos.h"
#import <Masonry/Masonry.h>
#import "CGBaseGobalTools.h"

@interface BaseTableViewCell ()
@property (nonatomic, assign) float appearanceSpeed;
@end

@implementation BaseTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = [CGBaseGobalTools AppCellBGColor];
        
        self.customView = [UIView new];
        self.customView.backgroundColor = [CGBaseGobalTools AppSuperLightGray];
        [self.contentView addSubview:self.customView];
        [self.customView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.offset(LineHeigh);
            make.left.equalTo(self.contentView).offset(ViewSpace);
            make.right.equalTo(self.contentView).offset(-ViewSpace);
            make.bottom.equalTo(self.contentView);
        }];
        
        if (@available(iOS 13.0, *)) {
            self.customView.hidden = YES;
        } else {
            self.customView.hidden = NO;
        }

    }
    return self;
}

@end
