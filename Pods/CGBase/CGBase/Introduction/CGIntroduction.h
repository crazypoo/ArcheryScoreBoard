//
//  CGIntroduction.h
//  CGBase_Example
//
//  Created by crazypoo on 2019/7/16.
//  Copyright © 2019 crazypoo. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^IntroductionDismissBlock)(void);

NS_ASSUME_NONNULL_BEGIN

@interface CGIntroduction : NSObject
+ (instancetype)sharedInstance;
-(void)createIntroduction:(IntroductionDismissBlock)block;
@end

NS_ASSUME_NONNULL_END
