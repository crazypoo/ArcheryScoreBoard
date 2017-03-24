//
//  PConfigurationTheme.h
//  adasdasdadadasdasdadadadad
//
//  Created by MYX on 2017/3/21.
//  Copyright © 2017年 邓杰豪. All rights reserved.
//

#define ThemeChangeNotification @"ThemeChangeNotification"  //更改主题的通知
#define ThemeName @"ThemeName"                              //主题名称

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface PConfigurationTheme : NSObject{
@private
    //主题配置信息
    NSDictionary *_themesConfig;
}

@property (copy, nonatomic) NSString *themeName;            //当前使用的主题名称
@property (strong, nonatomic) NSDictionary *themesConfig;   //主题配置信息
@property (strong, nonatomic) NSDictionary *fontConfig; //字体的配置信息

//创建单例,确保该对象唯一
+ (PConfigurationTheme *)shareInstance;

//获取当前主题下的图片名称
-(UIImage *)getThemeImageName:(NSString *)imageName;
//获取当前主题下的颜色
- (UIColor *)getThemeColorWithName:(NSString *)colorName;

@end
