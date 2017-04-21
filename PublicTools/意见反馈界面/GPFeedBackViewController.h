//
//  GPFeedBackViewController.h
//  Tongxunlu
//
//  Created by crazypoo on 14/8/5.
//  Copyright (c) 2014年 广州文思海辉亚信外派iOS开发小组. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import <PTools/PooTextView.h>

@interface GPFeedBackViewController :UITableViewController <UITextViewDelegate, MFMailComposeViewControllerDelegate>
{
//    UITextView  *_descriptionTextView;
//    UITextField *_descriptionPlaceHolder;
    PooTextView *inputViewText;
    NSInteger _selectedTopicsIndex;
    BOOL _isFeedbackSent;
    float lastContentOffset;
//    LApiClient *client;
}

@property (assign, nonatomic) BOOL sendWithMail;

@property (retain, nonatomic) NSString *descriptionText;
@property (retain, nonatomic) NSArray *topics;
@property (retain, nonatomic) NSArray *topicsToSend;
@property (retain, nonatomic) NSArray *toRecipients;
@property (retain, nonatomic) NSArray *ccRecipients;
@property (retain, nonatomic) NSArray *bccRecipients;

+ (BOOL)isAvailable;
- (id)initWithTopics:(NSArray*)theTopics;

@end
