//
//  IGApiResponseResult.h
//  Dagongzai
//
//  Created by 何桂强 on 14-10-15.
//  Copyright (c) 2014年 Pactera. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IGApiResponseResult : NSObject

@property (nonatomic,assign) BOOL accessSuccess;
@property (nonatomic,strong) NSString *errorMsg;
@property (nonatomic,strong) NSObject *data;

+(instancetype)resultWithAccess:(BOOL)b andMsg:(NSString*)msg;
+(instancetype)resultWithAccess:(BOOL)b msg:(NSString*)msg andData:(NSObject*)obj;

@end
