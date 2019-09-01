//
//  BaseTableViewController.h
//  OC-Base
//
//  Created by MYX on 2017/3/21.
//  Copyright © 2017年 邓杰豪. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>

@interface BaseTableViewController : UITableViewController <DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>

- (UIView *) setNavigationBottomView;
-(void)setNav:(UIColor *)navColor hideLine:(BOOL)isHideLine tintColor:(UIColor *)tColor;
-(void)setStatusBar:(UIStatusBarStyle)style;
@end
