//
//  GPFeedBackTopicsTableViewController.h
//  Tongxunlu
//
//  Created by crazypoo on 14/8/5.
//  Copyright (c) 2014年 广州文思海辉亚信外派iOS开发小组. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GPFeedBackTopicsTableViewController : UITableViewController{
    NSInteger _selectedIndex;
}
@property (assign, nonatomic) id delegate;
@property (assign, nonatomic) NSInteger selectedIndex;

@end

@protocol GPFeedBackTopicsTableViewControllerDelegate<NSObject>
- (NSArray*)topics;
- (void)feedbackTopicsViewController:(GPFeedBackTopicsTableViewController *)feedbackTopicsViewController didSelectTopicAtIndex:(NSInteger)selectedIndex;

@end