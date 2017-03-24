//
//  CBHistoryCollectionViewCell.m
//  CreateBill
//
//  Created by 邓杰豪 on 2016/8/8.
//  Copyright © 2016年 邓杰豪. All rights reserved.
//

#import "CBHistoryCollectionViewCell.h"

@implementation CBHistoryCollectionViewCell

@synthesize imageView = _imageView;
@synthesize nameLabel = _nameLabel;
@synthesize btn = _btn;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        [self.contentView setFrame:CGRectMake(0, 0, (SCREEN_WIDTH-20)/2, (SCREEN_HEIGHT-30-HEIGHT_NAVBAR)/2)];

        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.contentView.frame.size.width, self.contentView.frame.size.height-40)];
        [self.contentView addSubview:self.imageView];

        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.contentView.frame.size.height-40, self.contentView.frame.size.width, 20)];
        self.nameLabel.textAlignment = NSTextAlignmentCenter;
        self.nameLabel.textColor = [UIColor blackColor];
        self.nameLabel.font = DEFAULT_FONT(FontName, 12);
        [self.contentView addSubview:self.nameLabel];

        self.btn = [CBButton buttonWithType:UIButtonTypeCustom];
        self.btn.frame = CGRectMake(0, self.contentView.frame.size.height-20, self.contentView.frame.size.width, 20);
        self.btn.backgroundColor = [UIColor redColor];
        [self.btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.btn.titleLabel.font = DEFAULT_FONT(FontName, 16);
        [self.btn setTitle:@"图片操作" forState:UIControlStateNormal];
        [self.contentView addSubview:self.btn];

    }
    return self;
}

@end
