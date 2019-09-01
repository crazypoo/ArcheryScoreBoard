//
//  CGBaseFont.m
//  CGBase_Example
//
//  Created by crazypoo on 2019/7/26.
//  Copyright © 2019 crazypoo. All rights reserved.
//

#import "CGBaseFont.h"
#import "CGBaseMarcos.h"

@implementation CGBaseFont

+ (CGBaseFont *)shareManager
{
    static CGBaseFont *shareManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareManager = [[CGBaseFont alloc]init];
        [shareManager createNotifi];
    });
    return shareManager;
}

-(void)createNotifi
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(contentSizeChanged:) name:UIContentSizeCategoryDidChangeNotification object:nil];
}

-(NSNumber *)getSystemFontSize
{
    UIFont *font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];

    UIFontDescriptor *ctFont = font.fontDescriptor;

    return [ctFont objectForKey:@"NSFontSizeAttribute"];
}

-(void)contentSizeChanged:(NSNotification *)object
{
    self.fontDidChangeBlock();
}

-(UIFont *)appNormalFont
{
    return kDEFAULT_FONT(FontName, [[self getSystemFontSize] floatValue]);
}

-(UIFont *)appNormalFont_Bold
{
    return kDEFAULT_FONT(FontNameBold, [[self getSystemFontSize] floatValue]);
}

-(CGFloat)appSmallFont_Size
{
    return [[self getSystemFontSize] floatValue]*(3/4);
}

-(UIFont *)appSmallFont
{
    return kDEFAULT_FONT(FontName, [self appSmallFont_Size]);
}

-(UIFont *)appSmallFont_Bold
{
    return kDEFAULT_FONT(FontNameBold, [self appSmallFont_Size]);
}

-(CGFloat)appLargeFont_Size
{
    return [[self getSystemFontSize] floatValue]*(5/4);
}

-(UIFont *)appLargeFont
{
    return kDEFAULT_FONT(FontName, [self appLargeFont_Size]);
}

-(UIFont *)appLargeFont_Bold
{
    return kDEFAULT_FONT(FontNameBold, [self appLargeFont_Size]);
}

-(CGFloat)appSuperLargeFont_Size
{
    return [[self getSystemFontSize] floatValue]*(1.5);
}

-(UIFont *)appSuperLargeFont
{
    return kDEFAULT_FONT(FontName, [self appSuperLargeFont_Size]);
}

-(UIFont *)appSuperLargeFont_Bold
{
    return kDEFAULT_FONT(FontNameBold, [self appSuperLargeFont_Size]);
}
@end
