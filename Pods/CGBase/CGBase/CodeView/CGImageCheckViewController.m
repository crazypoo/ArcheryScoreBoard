//
//  CGImageCheckViewController.m
//  CloudGateCustom
//
//  Created by 邓杰豪 on 2019/5/8.
//  Copyright © 2019 邓杰豪. All rights reserved.
//

#import "CGImageCheckViewController.h"

#import "WMZCodeView.h"
#import "SLBaseVC+EX.h"
#import "CGBaseMarcos.h"

@interface CGImageCheckViewController ()
@property(nonatomic,strong)WMZCodeView *codeView;
@property(nonatomic,copy)ViewBlock viewBlock;
@end

@implementation CGImageCheckViewController

-(instancetype)initWithDismissBlock:(ViewBlock)block
{
    self = [super init];
    if (self)
    {
        self.viewBlock = block;
    }
    return self;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
//    [(SLBackGroundView*)self.view bgScroll].scrollEnabled = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationBar.scrollType = SL_NavigationBarScrollType_BigViewToSmallView;
    [self.navigationBar.btnBack addTarget:self action:@selector(viewDismiss:) forControlEvents:UIControlEventTouchUpInside];
    [self setNavBack:@"滑块验证"];
    
    [self.codeView removeFromSuperview];
    
    NSUInteger r = arc4random_uniform(3);
    self.codeView = [[WMZCodeView shareInstance] addCodeViewWithType:r withImageName:@"A" witgFrame:CGRectMake(ViewSpace, MyViewControllerNavHeight+20+HEIGHT_STATUS, kSCREEN_WIDTH-ViewSpace*2, 300)  withBlock:^(BOOL success) {
        if (success) {
            [self dismissViewControllerAnimated:YES completion:^{
                self.viewBlock(YES);
            }];
        }
        else
        {
            self.viewBlock(NO);
        }
    }];
    [self.view addSubview:self.codeView];
}

-(void)viewDismiss:(UIButton *)sender
{
    self.viewBlock(NO);
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}

@end
