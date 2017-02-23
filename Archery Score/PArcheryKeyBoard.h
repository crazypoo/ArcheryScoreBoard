//
//  PArcheryKeyBoard.h
//  Archery Score
//
//  Created by Staff on 2017/2/19.
//  Copyright © 2017年 邓杰豪. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PArcheryKeyBoard;

@protocol PArcheryKeyBoardDelegate <NSObject>
- (void)archeryberKeyboard:(PArcheryKeyBoard *)keyboard input:(NSString *)number;
- (void)archeryKeyboardBackspace:(PArcheryKeyBoard *)keyboard;
- (void)archeryKeyboadrDone:(PArcheryKeyBoard *)keyboard;
@end

@interface PArcheryKeyBoard : UIView
@property (nonatomic, assign)id<PArcheryKeyBoardDelegate> delegate;
+(instancetype)pooArcheryKeyBoard;
@end

