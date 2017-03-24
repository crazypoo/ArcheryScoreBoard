//
//  YXCustomAlertView.m
//  YXCustomAlertView
//
//  Created by Houhua Yan on 16/7/12.
//  Copyright © 2016年 YanHouhua. All rights reserved.

//

#import "YXCustomAlertView.h"

#define RGB(r, g, b)   [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]

@interface YXCustomAlertView()

@property (nonatomic, strong) UILabel *titleLabel;

@end


@implementation YXCustomAlertView


- (instancetype) initAlertViewWithFrame:(CGRect)frame andSuperView:(UIView *)superView onlyOkButton:(BOOL)yesOrNo
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.middleView.frame = superView.frame;
        [superView addSubview:_middleView];
        
        
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 8;
        self.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2, _centerY);
        [superView addSubview:self];
        
        
        self.titleLabel.frame = CGRectMake(0, 15, frame.size.width, 20);
        self.titleLabel.font = DEFAULT_FONT(FontName, 18);
        [self addSubview:_titleLabel];
        

        if (yesOrNo)
        {
            CGRect confirmF = CGRectMake(0, frame.size.height-42, frame.size.width, 42);
            UIButton *confirmBtn = [self creatButtonWithFrame:confirmF title:@"确定"];
            [self addSubview:confirmBtn];
            [confirmBtn addTarget:self action:@selector(confirmBtnClick) forControlEvents:UIControlEventTouchUpInside];

            UIView *horLine = [[UIView alloc] initWithFrame:CGRectMake(0, frame.size.height-43, frame.size.width, 0.5)];
            horLine.backgroundColor = RGB(213, 213, 215);
            [self addSubview:horLine];

        }
        else
        {
            CGRect cancelFrame = CGRectMake(0, frame.size.height-42, frame.size.width/2, 42);
            UIButton *cancelBtn = [self creatButtonWithFrame:cancelFrame title:@"取消"];
            [self addSubview:cancelBtn];
            [cancelBtn addTarget:self action:@selector(leftCancelClick) forControlEvents:UIControlEventTouchUpInside];


            CGRect confirmF = CGRectMake(frame.size.width/2, cancelBtn.frame.origin.y, cancelBtn.frame.size.width, cancelBtn.frame.size.height);
            UIButton *confirmBtn = [self creatButtonWithFrame:confirmF title:@"确定"];
            [self addSubview:confirmBtn];
            [confirmBtn addTarget:self action:@selector(confirmBtnClick) forControlEvents:UIControlEventTouchUpInside];

            //两条分割线
            UIView *horLine = [[UIView alloc] initWithFrame:CGRectMake(0, frame.size.height-43, frame.size.width, 0.5)];
            horLine.backgroundColor = RGB(213, 213, 215);
            [self addSubview:horLine];

            UIView *verLine = [[UIView alloc] initWithFrame:CGRectMake(frame.size.width/2-1,frame.size.height-43, 0.5, 43)];
            verLine.backgroundColor = horLine.backgroundColor;
            [self addSubview:verLine];
        }
    }
    
    return self;
    
}

- (UIButton *) creatButtonWithFrame:(CGRect) frame title:(NSString *) title
{
    UIButton *cancelBtn =  [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = frame;
    [cancelBtn setTitleColor:RGB(0, 123, 251) forState:UIControlStateNormal];
    [cancelBtn setTitle:title forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = DEFAULT_FONT(FontName, 18);
    
    return cancelBtn;
}


#pragma mark - Action
- (void) leftCancelClick
{
    if ([_delegate respondsToSelector:@selector(customAlertView:clickedButtonAtIndex:)]) {
        [_delegate customAlertView:self clickedButtonAtIndex:0];
    }
}

- (void) confirmBtnClick
{
    if ([_delegate respondsToSelector:@selector(customAlertView:clickedButtonAtIndex:)]) {
        [_delegate customAlertView:self clickedButtonAtIndex:1];
    }
    
}


#pragma mark - 注销视图
- (void) dissMiss
{
    
    if (_middleView) {
        [_middleView removeFromSuperview];
        _middleView = nil;
    }
    
    [self removeFromSuperview];

    if ([_delegate respondsToSelector:@selector(customAlertViewWasDismiss)]) {
        [_delegate customAlertViewWasDismiss];
    }
}

#pragma mark - getter And setter

- (void) setTitleStr:(NSString *)titleStr
{
    _titleLabel.text = titleStr;
}


- (UIView *) middleView
{
    if (_middleView == nil) {
        _middleView = [[UIView alloc] init];
        _middleView.backgroundColor = [UIColor blackColor];
        _middleView.alpha = 0.65;
    }
    
    return _middleView;
}

- (UILabel *) titleLabel{
    
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont boldSystemFontOfSize:18];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.backgroundColor = [UIColor clearColor];
    }
    
    return _titleLabel;
}


@end
