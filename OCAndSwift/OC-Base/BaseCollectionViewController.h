//
//  BaseCollectionViewController.h
//  OC-Base
//
//  Created by MYX on 2017/3/21.
//  Copyright © 2017年 邓杰豪. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseCollectionViewController : UICollectionViewController
{
    UIImageView *navigationImageView;
}

@property (nonatomic, strong) UIColor *navColor;
@property (nonatomic, assign) BOOL isHideNavLine;
- (UIView *) setNavigationBottomView;
@end
