//
//  GPFeedBackViewController.h
//  Tongxunlu
//
//  Created by crazypoo on 14/8/5.
//  Copyright (c) 2014年 广州文思海辉亚信外派iOS开发小组. All rights reserved.
//

#import "SL_BaseViewController.h"

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import <PooTools/PooTextView.h>
#import <PooTools/WMHub.h>

@interface GPFeedBackViewController :SL_BaseViewController <UITextViewDelegate, MFMailComposeViewControllerDelegate,UITableViewDataSource,UITableViewDelegate>
{
//    UITextView  *_descriptionTextView;
//    UITextField *_descriptionPlaceHolder;
    PooTextView *inputViewText;
    NSInteger _selectedTopicsIndex;
    BOOL _isFeedbackSent;
    float lastContentOffset;
//    LApiClient *client;
//    CGFloat sectionOneH;
}
@property (nonatomic, strong) UIView *navRightView;

@property (assign, nonatomic) BOOL sendWithMail;

@property (retain, nonatomic) NSString *descriptionText;
@property (retain, nonatomic) NSArray *topics;
@property (retain, nonatomic) NSArray *topicsToSend;
@property (retain, nonatomic) NSArray *toRecipients;
@property (retain, nonatomic) NSArray *ccRecipients;
@property (retain, nonatomic) NSArray *bccRecipients;
@property (strong, nonatomic) UITableView *tableView;

@property (nonatomic, assign) CGFloat viewW;
@property (nonatomic, strong) UIFont *uploadFont;
@property (nonatomic, assign) CGFloat backFontSize;
@property (nonatomic, strong) UIFont *largeTitleFont;
@property (nonatomic, assign) CGFloat smallTitleFontSize;
@property (nonatomic, strong)NSMutableDictionary *baseDic;

+ (BOOL)isAvailable;
- (id)initWithTopics:(NSArray*)theTopics;
-(instancetype)initWithApiBaseData:(NSMutableDictionary *)baseDic;
@end
