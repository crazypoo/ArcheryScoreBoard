//
//  UIViewController+Extension.m
//  CloudGateCustom
//
//  Created by 邓杰豪 on 2019/4/14.
//  Copyright © 2019 邓杰豪. All rights reserved.
//

#import "UIViewController+Extension.h"
#import <PooTools/PMacros.h>

@implementation UIViewController (Extension)

-(void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    PNSLog(@"motionBegan");
}

-(void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    PNSLog(@"motionEnded");
}

-(void)motionCancelled:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    PNSLog(@"motionCancelled");
}

@end
