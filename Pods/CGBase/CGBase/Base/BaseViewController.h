//
//  BaseViewController.h
//  OC-Base
//
//  Created by MYX on 2017/3/21.
//  Copyright © 2017年 邓杰豪. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController

@property (nonatomic,assign)BOOL orientationLand;

-(UIView *)setNavigationBottomView;
-(void)setNav:(UIColor *)navColor hideLine:(BOOL)isHideLine tintColor:(UIColor *)tColor;
-(void)backAction:(UIButton *)sender;
-(void)setStatusBar:(UIStatusBarStyle)style;
@end
