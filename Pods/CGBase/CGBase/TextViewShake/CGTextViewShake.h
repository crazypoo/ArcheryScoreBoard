//
//  CGTextViewShake.h
//  CloudGateCustom
//
//  Created by 邓杰豪 on 14/5/18.
//  Copyright © 2018年 邓杰豪. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <TextFieldEffects/TextFieldEffects-Swift.h>
#import <UITextField_Shake/UITextField+Shake.h>

@interface CGTextViewShake : NSObject
/*! @brief 输入框抖动
 * @param textView 输入框
 * @param str 提醒字符串
 */
+(void)aboutTextView:(id)textView
         alertString:(NSString *)str;
@end
