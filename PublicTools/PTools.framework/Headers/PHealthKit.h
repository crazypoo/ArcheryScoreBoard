//
//  PHealthKit.h
//  adasdasdadadasdasdadadadad
//
//  Created by MYX on 2017/4/21.
//  Copyright © 2017年 邓杰豪. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <HealthKit/HealthKit.h>

@protocol PHealthKitDelegate <NSObject>
-(void)kitDataIsload:(BOOL)isload stepStr:(NSString *)stepStr;
@end

@interface PHealthKit : NSObject
@property (nonatomic ,strong) HKHealthStore *healthStore;
+ (instancetype)shareInstance;
-(void)stepAllCount;
@property (nonatomic, weak) id<PHealthKitDelegate>delegate;
@end
