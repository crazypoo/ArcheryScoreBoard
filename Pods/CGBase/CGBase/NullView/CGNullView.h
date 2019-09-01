//
//  CGNullView.h
//  CloudGateCustom
//
//  Created by 邓杰豪 on 2019/3/25.
//  Copyright © 2019年 邓杰豪. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^NullViewTapBlock)(void);

@interface CGNullView : UIView
-(instancetype)initWithEmptyTitle:(NSString *)title withEmptyInfo:(NSString *)info handle:(NullViewTapBlock)block;
@end
