//
//  IGApiResponseResult.m
//  Dagongzai
//
//  Created by 何桂强 on 14-10-15.
//  Copyright (c) 2014年 Pactera. All rights reserved.
//

#import "IGApiResponseResult.h"

@implementation IGApiResponseResult

@synthesize accessSuccess,errorMsg,data;

+(instancetype)resultWithAccess:(BOOL)b andMsg:(NSString*)msg{
    return [IGApiResponseResult resultWithAccess:(BOOL)b msg:msg andData:nil];
}
+(instancetype)resultWithAccess:(BOOL)b msg:(NSString*)msg andData:(NSObject*)obj{
    IGApiResponseResult *result = [[IGApiResponseResult alloc] init];
    result.accessSuccess = b;
    result.errorMsg = msg;
    result.data = obj;
    return result;
}
@end
