//
//  PMotion.h
//  adasdasdadadasdasdadadadad
//
//  Created by MYX on 2017/4/21.
//  Copyright © 2017年 邓杰豪. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PMotionDelegate <NSObject>
-(void)callBackWithStep:(NSString *)step status:(NSString *)status speed:(NSString *)speed;
@end

@interface PMotion : NSObject
+ (instancetype)defaultMonitor;
-(void)getMotion;
@property (nonatomic, weak) id<PMotionDelegate>delegate;
@end
