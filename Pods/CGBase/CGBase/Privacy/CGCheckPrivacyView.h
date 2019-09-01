//
//  CGCheckPrivacyView.h
//  CloudGateCustom
//
//  Created by 邓杰豪 on 2019/5/10.
//  Copyright © 2019 邓杰豪. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <PrivacyPermission/PrivacyPermission.h>

typedef void (^PrivacyCheckDismiss)(void);

NS_ASSUME_NONNULL_BEGIN

@interface CGCheckPrivacyView : UIView
-(void)check:(void (^)(BOOL status))block;
@property (nonatomic,copy) PrivacyCheckDismiss dismissBlock;
@end

NS_ASSUME_NONNULL_END
