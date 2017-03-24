//
//  IGAlertView.h
//  T-TextKif
//
//  Created by 何桂强 on 14-8-25.
//  Copyright (c) 2014年 Pactera. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IGAlertView : UIAlertView
- (id)initWithTitle:(NSString *)title
            message:(NSString *)message
              block:(void (^)(IGAlertView *alertView, BOOL isCancel, NSInteger buttonIndex))clickedBlock
  cancelButtonTitle:(NSString *)cancelButtonTitle
  otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;
@end

@interface IGAlertView (simple)
+(void)showAlertWithMessage:(NSString*)msg;
+(void)showAlertWithTitle:(NSString*)title message:(NSString*)msg;
+(void)showAlertWithTitle:(NSString*)title message:(NSString*)msg cancelButtonTitle:(NSString*)cancelTitle;
@end