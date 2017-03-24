//
//  HealthKitManager.m
//  Archery Score
//
//  Created by MYX on 2017/3/24.
//  Copyright © 2017年 邓杰豪. All rights reserved.
//

#import "HealthKitManager.h"

@interface HealthKitManager ()


@end


@implementation HealthKitManager

+ (instancetype)shareInstance {
    
    static HealthKitManager *kitManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        kitManager = [[HealthKitManager alloc] init];
        [kitManager initSetting];
    });
    return kitManager;
}
- (void)author {
    
}
- (void)initSetting {
    
    if ([HKHealthStore isHealthDataAvailable]) {
        _healthStore = [[HKHealthStore alloc] init];
    } else {
        NSLog(@"HKHealthStore is not available");
    }
}
@end

