//
//  CGImageCheckViewController.h
//  CloudGateCustom
//
//  Created by 邓杰豪 on 2019/5/8.
//  Copyright © 2019 邓杰豪. All rights reserved.
//

#import "SL_BaseViewController.h"

typedef void (^ViewBlock)(BOOL success);

NS_ASSUME_NONNULL_BEGIN

@interface CGImageCheckViewController : SL_BaseViewController

-(instancetype)initWithDismissBlock:(ViewBlock)block;

@end

NS_ASSUME_NONNULL_END
