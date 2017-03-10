//
//  LBaseViewController.h
//  OMCN
//
//  Created by 邓杰豪 on 16/3/22.
//  Copyright © 2016年 doudou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Masonry/Masonry.h>

@interface LBaseViewController : UIViewController
-(UIImage*)createImageWithColor:(UIColor*)color;
- (UIView *) setNavigationBottomView;

@property (nonatomic, retain) UIButton *leftNavBtn;
@property (nonatomic, strong) UIColor *navColor;
@end
