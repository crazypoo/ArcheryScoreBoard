//
//  IGJsonFilter.h
//  IGTool
//
//  Created by 何桂强 on 14/11/10.
//  Copyright (c) 2014年 Gavin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IGJsonFilter : NSObject

+(void)filteringNullInstanceInMutableJsonObject:(id)jsonObject;
+(void)filteringNullInstanceInMutableArray:(NSMutableArray*)array;
+(void)filteringNullInstanceInMutableDictionary:(NSMutableDictionary*)dict;

@end
