//
//  CGAppDataDownLoadView.h
//  LandloardTool
//
//  Created by crazypoo on 2019/8/1.
//  Copyright © 2019 邓杰豪. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class CGAppDataDownLoadView;

typedef void (^ViewDoneBlock)(CGAppDataDownLoadView *v,BOOL Success);

@interface CGAppDataDownLoadView : UIView
+(NSString *)videoPath;
-(instancetype)initWithAppIsFirsUse:(BOOL)isFirst withApiBaseDic:(NSMutableDictionary *)apiBaseDic handle:(ViewDoneBlock)block;
@end

NS_ASSUME_NONNULL_END
