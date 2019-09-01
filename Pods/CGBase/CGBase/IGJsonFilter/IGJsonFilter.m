//
//  IGJsonFilter.m
//  IGTool
//
//  Created by 何桂强 on 14/11/10.
//  Copyright (c) 2014年 Gavin. All rights reserved.
//

#import "IGJsonFilter.h"

@implementation IGJsonFilter

+(void)filteringNullInstanceInMutableJsonObject:(id)jsonObject{
    if (jsonObject) {
        if ([jsonObject isKindOfClass:[NSNull class]]) {
            return;
        }else if ([jsonObject isKindOfClass:[NSMutableArray class]]) {
            [IGJsonFilter filteringNullInstanceInMutableArray:jsonObject];
        }else if ([jsonObject isKindOfClass:[NSMutableDictionary class]]) {
            [IGJsonFilter filteringNullInstanceInMutableDictionary:jsonObject];
        }
    }
}

+(void)filteringNullInstanceInMutableArray:(NSMutableArray*)array{
    if (!array || ![array isKindOfClass:[NSMutableArray class]]) {
        return;
    }
    
    NSMutableIndexSet *needRemoveIDs = [[NSMutableIndexSet alloc] init];
    
    for (int i = 0 ; i<array.count; i++) {
        id subObject = array[i];
        if ([subObject isKindOfClass:[NSNull class]]) {
            [needRemoveIDs addIndex:i];
        }else if ([subObject isKindOfClass:[NSMutableArray class]]) {
            [IGJsonFilter filteringNullInstanceInMutableArray:subObject];
        }else if ([subObject isKindOfClass:[NSMutableDictionary class]]) {
            [IGJsonFilter filteringNullInstanceInMutableDictionary:subObject];
        }
    }
    
    [array removeObjectsAtIndexes:needRemoveIDs];
}

+(void)filteringNullInstanceInMutableDictionary:(NSMutableDictionary*)dict{
    if (!dict || ![dict isKindOfClass:[NSMutableDictionary class]]) {
        return;
    }
    
    NSMutableArray *needRemoveKeys = [[NSMutableArray alloc] init];
    for (NSString *key in [dict allKeys]) {
        id subObject = dict[key];
        
        if ([subObject isKindOfClass:[NSNull class]]) {
            [needRemoveKeys addObject:key];
        }else if ([subObject isKindOfClass:[NSMutableArray class]]) {
            [self filteringNullInstanceInMutableArray:subObject];
        }else if ([subObject isKindOfClass:[NSMutableDictionary class]]) {
            [self filteringNullInstanceInMutableDictionary:subObject];
        }
    }
    
    [dict removeObjectsForKeys:needRemoveKeys];
}

@end
