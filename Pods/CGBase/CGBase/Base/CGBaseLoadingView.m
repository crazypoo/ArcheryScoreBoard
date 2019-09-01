//
//  CGBaseLoadingView.m
//  CGBase_Example
//
//  Created by crazypoo on 2019/6/22.
//  Copyright © 2019 crazypoo. All rights reserved.
//

#import "CGBaseLoadingView.h"

#import <PooTools/PMacros.h>
#import <Masonry/Masonry.h>
#import "CGBaseMarcos.h"
#import "CGBaseGobalTools.h"

#define LoadingViewH 60.f
#define LoadingImageWH LoadingViewH/2
#define LoadingViewSpace 15.f

@implementation CGBaseLoadingView

-(void)loadingViewShow
{
    [kAppDelegateWindow addSubview:self];
    self.backgroundColor = kClearColor;
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(kAppDelegateWindow);
    }];
        
    UIImage *cloud = [CGBaseGobalTools image:@"cloud" compatibleWithTraitCollection:self.traitCollection];
    UIImage *h = [CGBaseGobalTools image:@"h" compatibleWithTraitCollection:self.traitCollection];
    UIImage *o = [CGBaseGobalTools image:@"o" compatibleWithTraitCollection:self.traitCollection];
    UIImage *m = [CGBaseGobalTools image:@"m" compatibleWithTraitCollection:self.traitCollection];
    UIImage *e = [CGBaseGobalTools image:@"e" compatibleWithTraitCollection:self.traitCollection];
    
    NSArray *imageArr = @[cloud,h,o,m,e];
    
    UIView *loadingView = [UIView new];
    loadingView.backgroundColor = kDevMaskBackgroundColor;
    [self addSubview:loadingView];
    [loadingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(imageArr.count*LoadingImageWH+LoadingViewSpace*2);
        make.height.offset(LoadingViewH);
        make.centerX.centerY.equalTo(self);
    }];
    kViewBorderRadius(loadingView, AppRadius, 0, kClearColor);
    
    for (int i = 0; i < imageArr.count; i++) {
        UIImageView *iconV = [UIImageView new];
        iconV.image = imageArr[i];
        [loadingView addSubview:iconV];
        [iconV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(loadingView).offset(LoadingViewSpace+LoadingImageWH*i);
            make.centerY.equalTo(loadingView);
            make.width.height.offset(LoadingImageWH);
        }];
        [iconV.layer addAnimation:[self opacityForever_Animation:0.6] forKey:nil];
    }
}

-(void)loadingViewDismiss
{
    [self removeFromSuperview];
}

-(CABasicAnimation *)opacityForever_Animation:(float)time
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];//必须写opacity才行。
    animation.fromValue = [NSNumber numberWithFloat:1.0f];
    animation.toValue = [NSNumber numberWithFloat:0.0f];//这是透明度。
    animation.autoreverses = YES;
    animation.duration = time;
    animation.repeatCount = MAXFLOAT;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];///没有的话是均匀的动画。
    return animation;
}

@end
