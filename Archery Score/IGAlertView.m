//
//  IGAlertView.m
//  T-TextKif
//
//  Created by 何桂强 on 14-8-25.
//  Copyright (c) 2014年 Pactera. All rights reserved.
//

#import "IGAlertView.h"

@interface IGAlertView ()<UIAlertViewDelegate>

@property (copy, nonatomic) void (^clickedBlock)(IGAlertView *alertView, BOOL isCancel, NSInteger buttonIndex);

@end

@implementation IGAlertView

- (id)initWithTitle:(NSString *)title
            message:(NSString *)message
              block:(void (^)(IGAlertView *alertView, BOOL isCancel, NSInteger buttonIndex))clickedBlock
  cancelButtonTitle:(NSString *)cancelButtonTitle
  otherButtonTitles:(NSString *)otherButtonTitles, ...
{
    
    self = [self initWithTitle:title message:message delegate:self cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitles,nil];
    
    if (self) {
        _clickedBlock = clickedBlock;
    }
    return self;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (_clickedBlock) {
         _clickedBlock(self, buttonIndex==self.cancelButtonIndex, buttonIndex);   
    }
}

@end


@implementation IGAlertView (simple)

+(void)showAlertWithMessage:(NSString*)msg{
    [IGAlertView showAlertWithTitle:@"提示" message:msg cancelButtonTitle:@"确定"];
}
+(void)showAlertWithTitle:(NSString*)title message:(NSString*)msg{
    [IGAlertView showAlertWithTitle:title message:msg cancelButtonTitle:@"确定"];
}

+(void)showAlertWithTitle:(NSString*)title message:(NSString*)msg cancelButtonTitle:(NSString*)cancelTitle{
    IGAlertView *alert = [[IGAlertView alloc] initWithTitle:title message:msg block:nil cancelButtonTitle:cancelTitle otherButtonTitles:nil];
    [alert show];
}

@end
