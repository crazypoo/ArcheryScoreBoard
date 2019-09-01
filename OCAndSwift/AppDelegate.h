//
//  AppDelegate.h
//  OCAndSwift
//
//  Created by MYX on 2017/3/24.
//  Copyright © 2017年 邓杰豪. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <PooTools/RCDraggableButton.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) RCDraggableButton *avatar;
+ (AppDelegate *)appDelegate;

@end

