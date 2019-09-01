//
//  CGTextViewShake.m
//  CloudGateCustom
//
//  Created by 邓杰豪 on 14/5/18.
//  Copyright © 2018年 邓杰豪. All rights reserved.
//

#import "CGTextViewShake.h"

#import "CGBaseGobalTools.h"

@implementation CGTextViewShake

+(void)aboutTextView:(id)textView alertString:(NSString *)str
{
    if ([textView isKindOfClass:[HoshiTextField class]]) {
        HoshiTextField *nowT = (HoshiTextField *)textView;
        [nowT resignFirstResponder];
        nowT.placeholderColor = [CGBaseGobalTools AppRed];
        [nowT shake:10 withDelta:5 completion:^{
            [CGBaseGobalTools gobalShowHUDWithMessgae:str];
        }];
    }
    else if ([textView isKindOfClass:[AkiraTextField class]])
    {
        AkiraTextField *nowT = (AkiraTextField *)textView;
        [nowT resignFirstResponder];
        nowT.placeholderColor = [CGBaseGobalTools AppRed];
        [nowT shake:10 withDelta:5 completion:^{
            [CGBaseGobalTools gobalShowHUDWithMessgae:str];
        }];
    }
    return;
}

@end
