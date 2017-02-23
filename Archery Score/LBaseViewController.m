//
//  LBaseViewController.m
//  OMCN
//
//  Created by 邓杰豪 on 16/3/22.
//  Copyright © 2016年 doudou. All rights reserved.
//

#import "LBaseViewController.h"

@interface LBaseViewController ()
{
    UIImageView *navigationImageView;
}

@end

@implementation LBaseViewController

#pragma mark ---------------> AboutView
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    navigationImageView.hidden = YES;
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    navigationImageView.hidden = YES;
}

#pragma mark --------------->CreateImageWithColor
-(UIImage*)createImageWithColor:(UIColor*) color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.leftNavBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.leftNavBtn.frame = CGRectMake(0, 0, 40, 40);
    [self.leftNavBtn setImage:[UIImage imageNamed:@"image_back"] forState:UIControlStateNormal];
    [self.leftNavBtn addTarget:self action:@selector(backAct:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:self.leftNavBtn]];

    [self.navigationController.navigationBar setBackgroundImage:[self createImageWithColor:PRGBAColor(0, 149, 227,1)] forBarMetrics:UIBarMetricsDefault];

    navigationImageView = [self findHairlineImageViewUnder:self.navigationController.navigationBar];
}

#pragma mark --------------->NAV底部黑线去掉
-(UIImageView *)findHairlineImageViewUnder:(UIView *)view {

    if ([view isKindOfClass:UIImageView.class] && view.bounds.size.height <= 1.0) {
        return (UIImageView *)view;
    }
    for (UIView *subview in view.subviews) {
        UIImageView *imageView = [self findHairlineImageViewUnder:subview];
        if (imageView) {
            return imageView;
        }
    }
    return nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)backAct:(UIButton *)sender
{
    NSArray *viewcontrollers = self.navigationController.viewControllers;
    if (viewcontrollers.count>1) {
        if ([viewcontrollers objectAtIndex:viewcontrollers.count-1] == self) {
            //push方式
            ReturnsToTheUpperLayer
        }
    }
    else
    {
        //present方式
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }
}
@end
