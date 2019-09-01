//
//  CGGobalAnimation.h
//  CloudGateCustom
//
//  Created by crazypoo on 2019/6/10.
//  Copyright © 2019 邓杰豪. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger,CGAnimationXY){
    CGAnimationX = 0,
    CGAnimationY = 1,
};
NS_ASSUME_NONNULL_BEGIN

@interface CGGobalAnimation : NSObject
+(CABasicAnimation *)opacityForever_Animation:(float)time;
+(CABasicAnimation *)moveX:(float)time X:(NSNumber *)x withType:(CGAnimationXY)type;
+(CABasicAnimation *)scale:(NSNumber *)Multiple orgin:(NSNumber *)orginMultiple durTimes:(float)time Rep:(float)repertTimes;
+(CAAnimationGroup *)groupAnimation:(NSArray *)animationAry durTimes:(float)time Rep:(float)repeatTimes;
+(CAKeyframeAnimation *)keyframeAnimation:(CGMutablePathRef)path durTimes:(float)time Rep:(float)repeatTimes;
+(CABasicAnimation *)rotation:(float)dur degree:(float)degree direction:(int)direction repeatCount:(int)repeatCount;
@end

NS_ASSUME_NONNULL_END
