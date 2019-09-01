//
//  CGIntroduction.m
//  CGBase_Example
//
//  Created by crazypoo on 2019/7/16.
//  Copyright © 2019 crazypoo. All rights reserved.
//

#import "CGIntroduction.h"
#import <MYBlurIntroductionView/MYBlurIntroductionView.h>
#import <PooTools/PMacros.h>
#import <PooTools/UIView+ModifyFrame.h>
#import "CGBaseGobalTools.h"
#import "CGBaseMarcos.h"

@interface CGIntroduction ()<MYIntroductionDelegate>
@property (nonatomic, copy) IntroductionDismissBlock dismissBlock;
@end

@implementation CGIntroduction

+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    static CGIntroduction *cls;
    dispatch_once(&onceToken, ^{
        cls = [[[self class] alloc] init];
    });
    return cls;
}

-(void)createIntroduction:(IntroductionDismissBlock)block
{
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    NSString *pathDocuments = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *firstUsePath = [NSString stringWithFormat:@"%@/FirstUsePath/", pathDocuments];
    NSArray *tempFileList = [[NSArray alloc] initWithArray:[fileManager contentsOfDirectoryAtPath:firstUsePath error:nil]];
    for (NSString *imageString in tempFileList)
    {
        NSString *imageStr = [NSString stringWithFormat:@"/%@",imageString];
        NSData *data = [NSData dataWithContentsOfFile:[firstUsePath stringByAppendingString:imageStr]];
        
        UIImageView *iconV = [UIImageView new];
        iconV.size = CGSizeMake(kAppDelegateWindow.width, kAppDelegateWindow.height);
        iconV.contentMode = UIViewContentModeScaleAspectFit;
        iconV.image = [UIImage imageWithData:data];
        
        MYIntroductionPanel *panel = [[MYIntroductionPanel alloc] initWithFrame:CGRectMake(0, 0, kAppDelegateWindow.width, kAppDelegateWindow.height) title:nil description:nil header:iconV];
        [arr addObject:panel];
    }
    
    MYBlurIntroductionView *introductionView = [[MYBlurIntroductionView alloc] initWithFrame:CGRectMake(0, 0, kAppDelegateWindow.width, kAppDelegateWindow.height)];
    introductionView.delegate        = self;
    introductionView.RightSkipButton.titleLabel.font = AppFontNormal;
    [introductionView.RightSkipButton setTitle:@"跳过" forState:UIControlStateNormal];
    introductionView.backgroundColor = [CGBaseGobalTools AppWhite];
    [introductionView buildIntroductionWithPanels:arr];
    [kAppDelegateWindow.rootViewController.view addSubview:introductionView];
    
    self.dismissBlock = block;
}

-(void)introduction:(MYBlurIntroductionView *)introductionView didFinishWithType:(MYFinishType)finishType
{
    [introductionView removeFromSuperview];
    self.dismissBlock();
}

@end
