//
//  BaseTableViewCell.h
//  CloudGateCustom
//
//  Created by 邓杰豪 on 2019/3/2.
//  Copyright © 2019年 邓杰豪. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger) {
    CLOSE  = 0, //关闭
    OPEN  = 1, //打开
}BtnType;

NS_ASSUME_NONNULL_BEGIN

@interface BaseTableViewCell : UITableViewCell
@property (nonatomic, strong) UIView *customView;
@end

NS_ASSUME_NONNULL_END
