//
//  Utils.h
//  login
//
//  Created by crazypoo on 14/7/10.
//  Copyright (c) 2014年 crazypoo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Utils : NSObject

+(UIImageView *)imageViewWithFrame:(CGRect)frame withImage:(UIImage *)image;
+(UILabel *)labelWithFrame:(CGRect)frame withTitle:(NSString *)title titleFontSize:(UIFont *)font textColor:(UIColor *)color backgroundColor:(UIColor *)bgColor alignment:(NSTextAlignment)textAlignment;
+(UIButton *)createBtnWithType:(UIButtonType)btnType frame:(CGRect)btnFrame backgroundColor:(UIColor*)bgColor;

+(CGSize)sizeForString:(NSString *)string fontToSize:(float)fontToSize andHeigh:(float)heigh andWidth:(float)width;

+(NSString *)chineseTransform:(NSString *)chinese;

+(UIAlertView *)alertTitle:(NSString *)title message:(NSString *)msg delegate:(id)aDeleagte cancelBtn:(NSString *)cancelName otherBtnName:(NSString *)otherbuttonName;
+(UIAlertView *)alertShowWithMessage:(NSString *)messgae;

+(void)timmerRunWithTime:(int)time button:(UIButton *)btn;
+(NSString *)formateTime:(NSDate*)date;
@end
