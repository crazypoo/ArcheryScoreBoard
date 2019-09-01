//
//  CGMessageTableViewHeader.h
//  LandloardTool
//
//  Created by 邓杰豪 on 2019/2/17.
//  Copyright © 2019年 邓杰豪. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CGMessageTableViewHeader : UITableViewHeaderFooterView
@property (nonatomic,strong) UIView *badgeView;
@property (nonatomic,strong) UIButton *indicatorView;
@property (nonatomic, strong) UILabel *hTitle;
@end

NS_ASSUME_NONNULL_END
