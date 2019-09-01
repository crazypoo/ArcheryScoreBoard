//
//  CGBaseFont.h
//  CGBase_Example
//
//  Created by crazypoo on 2019/7/26.
//  Copyright © 2019 crazypoo. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
typedef void (^fontDidChange)(void);

@interface CGBaseFont : NSObject
+ (CGBaseFont *)shareManager;

-(NSNumber *)getSystemFontSize;
-(UIFont *)appNormalFont;
-(UIFont *)appNormalFont_Bold;

-(CGFloat)appSmallFont_Size;
-(UIFont *)appSmallFont;
-(UIFont *)appSmallFont_Bold;

-(CGFloat)appLargeFont_Size;
-(UIFont *)appLargeFont;
-(UIFont *)appLargeFont_Bold;

-(CGFloat)appSuperLargeFont_Size;
-(UIFont *)appSuperLargeFont;
-(UIFont *)appSuperLargeFont_Bold;
@property (nonatomic,copy) fontDidChange fontDidChangeBlock;
@end

NS_ASSUME_NONNULL_END
