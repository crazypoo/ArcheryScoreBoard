//
//  PConfigurationTheme.m
//  adasdasdadadasdasdadadadad
//
//  Created by MYX on 2017/3/21.
//  Copyright © 2017年 邓杰豪. All rights reserved.
//

#import "PConfigurationTheme.h"

@implementation PConfigurationTheme
//创建单例,确保该对象唯一
+ (PConfigurationTheme *)shareInstance{
    
    static PConfigurationTheme *configuration = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        configuration = [PConfigurationTheme new];
    });
    return configuration;
}

//重写init方法
-(id)init{
    
    self = [super init];
    if (self != nil) {
        
        //读取主题配置文件
        NSString *filePlist = [[NSBundle mainBundle] pathForResource:@"theme" ofType:@"plist"];
        _themesConfig = [NSDictionary dictionaryWithContentsOfFile:filePlist];
        
        //读取字体配置文件
        NSString *fontConfigPlist = [[NSBundle mainBundle] pathForResource:@"fontColor" ofType:@"plist"];
        
        _fontConfig = [NSDictionary dictionaryWithContentsOfFile:fontConfigPlist];
        
        self.themeName = @"默认";
    }
    
    return  self;
}

//得到当前主题名称
- (void)setThemeName:(NSString *)themeName{
    if (_themeName != themeName) {
        _themeName = [themeName copy];
    }
    
    //获取主题配置的根目录
    NSString *themePath = [self getThemePath];
    NSString *filePath = [themePath stringByAppendingPathComponent:@"fontColor.plist"];
    _fontConfig = [NSDictionary dictionaryWithContentsOfFile:filePath];
    
}

//获取当前主题配置的目录
- (NSString *)getThemePath{
    
    //项目的根路径
    NSString *resourcePath = [[NSBundle mainBundle] resourcePath];
    
    if ([_themeName isEqualToString:@"默认"]) {
        return resourcePath;
    }
    
    //获取当前主题的配置路径
    NSString *configurationPath = [_themesConfig objectForKey:_themeName];
    
    //主题的完整路径
    NSString *themePath = [resourcePath stringByAppendingPathComponent:configurationPath];
    
    return themePath;
}

//获取当前主题下的图片
-(UIImage *)getThemeImageName:(NSString *)imageName{
    if (imageName.length == 0) {
        return nil;
    }
    //获取当前主题配置的目录
    NSString *configurationPath = [self getThemePath];
    //图片名称在当前主题的文件路径
    NSString *imagePath = [configurationPath stringByAppendingPathComponent:imageName];
    UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
    
    return image;
}

//获取当前主题下的颜色
- (UIColor *)getThemeColorWithName:(NSString *)colorName{
    if (colorName.length == 0){
        return nil;
    }
    
    NSString *rgb = [self.fontConfig objectForKey:colorName];
    NSArray *rgbs = [rgb componentsSeparatedByString:@","];
    
    if (rgbs.count == 3)
    {
        float r = [rgbs[0] floatValue];
        float g = [rgbs[1] floatValue];
        float b = [rgbs[2] floatValue];
        UIColor *color = [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1];
        return color;
    }
    
    return nil;
}

+ (id)copyWithZone:(NSZone *)zone
{
    return self;
}

@end
