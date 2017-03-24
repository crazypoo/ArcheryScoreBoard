//
//  HealthKitManager.h
//  Archery Score
//
//  Created by MYX on 2017/3/24.
//  Copyright © 2017年 邓杰豪. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <HealthKit/HealthKit.h>

@interface HealthKitManager : NSObject
@property (nonatomic ,strong) HKHealthStore *healthStore;
+ (instancetype)shareInstance;
@end
