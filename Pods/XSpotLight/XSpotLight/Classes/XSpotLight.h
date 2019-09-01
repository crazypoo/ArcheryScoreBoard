//
//  XSportLight.h
//  XSportLight
//
//  Created by xlx on 15/8/22.
//  Copyright (c) 2015年 xlx. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol XSpotLightDelegate <NSObject>

@optional

- (void)XSpotLightClicked:(NSInteger)index;

@end

@interface XSpotLight : UIViewController

@property (nonatomic, strong) NSArray *messageArray;
@property (nonatomic,       ) NSArray *rectArray;
@property (nonatomic, weak  ) id<XSpotLightDelegate> delegate;

@end
