//
//  PLaunchAdMonitor.h
//  adasdasdadadasdasdadadadad
//
//  Created by MYX on 2017/4/6.
//  Copyright © 2017年 邓杰豪. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

extern NSString * _Nullable PLaunchAdDetailDisplayNotification;

@interface PLaunchAdMonitor : NSObject
+ (void)showAdAtPath:(nonnull NSArray *)path onView:(nonnull UIView *)container timeInterval:(NSTimeInterval)interval detailParameters:(nullable NSDictionary *)param years:(nullable NSString *)year comName:(nullable NSString * )comname callback:(void(^_Nullable)())callback;

@end
