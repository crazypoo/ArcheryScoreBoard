//
//  CGLoadingHub.m
//  CGBase_Example
//
//  Created by crazypoo on 2019/6/16.
//  Copyright © 2019 crazypoo. All rights reserved.
//

#import "CGBaseLoadingHub.h"

@implementation CGBaseLoadingHub

+(void)showLoadingHub:(UIColor *)hubColor
{
    [WMHub setColors:@[hubColor,hubColor]];
    [WMHub setLineWidth:10];
    [WMHub show];
}
@end
