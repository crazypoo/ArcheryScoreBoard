//
//  GPFeedBackViewController.m
//  Tongxunlu
//
//  Created by crazypoo on 14/8/5.
//  Copyright (c) 2014年 广州文思海辉亚信外派iOS开发小组. All rights reserved.
//

#import "GPFeedBackViewController.h"
#import "GPFeedBackTopicsTableViewController.h"
#include <sys/types.h>
#include <sys/sysctl.h>


@interface GPFeedBackViewController (private)

- (NSString *) _platform;
- (NSString *) _platformString;
- (NSString*)_feedbackSubject;
- (NSString*)_feedbackBody;
- (NSString*)_appName;
- (NSString*)_appVersion;
- (NSString*)_selectedTopic;
- (NSString*)_selectedTopicToSend;
- (void)_updatePlaceholder;
@end

@implementation GPFeedBackViewController

@synthesize descriptionText;
@synthesize topics;
@synthesize topicsToSend;
@synthesize toRecipients;
@synthesize ccRecipients;
@synthesize bccRecipients;

@synthesize sendWithMail;

+ (BOOL)isAvailable
{
    return [MFMailComposeViewController canSendMail];
}

-(id)init
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if(self){
        self.topics = [[NSArray alloc]initWithObjects:
                        @"界面建议",@"App出现的Bug",@"App整体建议",@"与开发人员聊天",nil];
        
        self.topicsToSend = [[NSArray alloc]initWithObjects:
                              @"界面建议",@"App出现的Bug",@"App整体建议",@"与开发人员聊天", nil];
        self.sendWithMail = YES;
    }
    return self;
}

- (id)initWithTopics:(NSArray*)theIssues
{
    self = [self init];
    if(self){
        self.topics = theIssues;
        self.topicsToSend = theIssues;
    }
    return self;
}

- (void)dealloc {
    self.descriptionText = nil;
    self.topics = nil;
    self.topicsToSend = nil;
    self.toRecipients = nil;
    self.ccRecipients = nil;
    self.bccRecipients = nil;
}

#pragma mark - View lifecycle

- (void)loadView
{
    [super loadView];
    self.title = @"意见反馈";
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 40, 30);
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setTitle:@"发送" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(nextDidPress:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self buildNav];
}

-(void)backToUpLoadView:(NSNotification *)NSNotification
{
    ReturnsToTheUpperLayer;
}

-(void)buildNav{
//    CreatReturnButton(@"image_back", backAct:)
}

-(void)backAct:(id)sender{
    ReturnsToTheUpperLayer
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    inputViewText = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if(_isFeedbackSent){
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section==0){
        return 1;
    }
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section==0 && indexPath.row==0){
            return MAX(88, inputViewText.contentSize.height);

    }
    return 44;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.0000001;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    NSArray *tA = @[@"需要反馈的内容",@"本机信息"];
    NSString *HeaderString = tA[section];
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    titleView.backgroundColor = [UIColor clearColor];
    
    UILabel *HeaderLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 180, 40)];
    HeaderLabel.font = DEFAULT_FONT(FontName,14);
    HeaderLabel.textColor = [UIColor blueberryColor];
    HeaderLabel.text = HeaderString;
    
    [titleView addSubview:HeaderLabel];
    return titleView;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        if(indexPath.section==1)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        }
        else
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault      reuseIdentifier:CellIdentifier];

            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            inputViewText = [[PooTextView alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH-20, 88)];
            inputViewText.placeholder = @"请输入你想说的内容";
            inputViewText.delegate = self;
            inputViewText.returnKeyType = UIReturnKeyDone;
            inputViewText.font = DEFAULT_FONT(FontName,16);
            [cell.contentView addSubview:inputViewText];
        }
    }

    switch (indexPath.section) {
        case 0:
            switch (indexPath.row) {
                case 0:
                break;
                case 1:
                default:
                    break;
            }
            break;
        case 1:
            switch (indexPath.row) {
                case 0:
                    cell.textLabel.font = DEFAULT_FONT(FontName,18);
                    cell.detailTextLabel.font = DEFAULT_FONT(FontName,16);
                    cell.textLabel.text = @"手机型号";
                    cell.detailTextLabel.text = [self _platformString];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    break;
                case 1:
                    cell.textLabel.font = DEFAULT_FONT(FontName,18);
                    cell.detailTextLabel.font = DEFAULT_FONT(FontName,16);
                    cell.textLabel.text = @"系统版本";
                    cell.detailTextLabel.text = [UIDevice currentDevice].systemVersion;
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    break;
                case 2:
                    cell.textLabel.font = DEFAULT_FONT(FontName,18);
                    cell.detailTextLabel.font = DEFAULT_FONT(FontName,16);
                    cell.textLabel.text = @"APP名字";
                    cell.detailTextLabel.text = [self _appName];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    break;
                case 3:
                    cell.textLabel.font = DEFAULT_FONT(FontName,18);
                    cell.detailTextLabel.font = DEFAULT_FONT(FontName,16);
                    cell.textLabel.text = @"APP版本号";
                    cell.detailTextLabel.text = [self _appVersion];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    break;
                default:
                    break;
            }
            break;
        default:
            break;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section==0 && indexPath.row==0){
    }
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    if (lastContentOffset < scrollView.contentOffset.y) {
        [inputViewText resignFirstResponder];
    }
    else
    {
        [inputViewText resignFirstResponder];
    }
}

- (void)cancelDidPress:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)nextDidPress:(id)sender
{
    [inputViewText resignFirstResponder];
    if (!self.sendWithMail) {
    }else{
        if ([inputViewText.text length]>0) {
            [self sendByMail];
        }
        else
        {
            [Utils alertShowWithMessage:@"请输入反馈内容"];
        }
    }
}

-(void)sendByMail{
    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
    
    if (!picker) return;
    
    picker.mailComposeDelegate = self;
    [picker setToRecipients:self.toRecipients];
    [picker setCcRecipients:self.ccRecipients];
    [picker setBccRecipients:self.bccRecipients];
    
    [picker setSubject:[self _feedbackSubject]];
    [picker setMessageBody:[self _feedbackBody] isHTML:NO];
    [self presentViewController:picker animated:YES completion:^{
    }];
}

- (void)textViewDidChange:(UITextView *)textView
{
}


-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    if(result==MFMailComposeResultCancelled){
    }else if(result==MFMailComposeResultSent){
        [[NSNotificationCenter defaultCenter] postNotificationName:@"back" object:nil];
        _isFeedbackSent = YES;
    }else if(result==MFMailComposeResultFailed){
        [Utils alertShowWithMessage:@"出错啦"];
    }
    [controller dismissViewControllerAnimated:YES completion:nil];
    
}


- (void)feedbackTopicsViewController:(GPFeedBackTopicsTableViewController *)feedbackTopicsViewController didSelectTopicAtIndex:(NSInteger)selectedIndex {
    _selectedTopicsIndex = selectedIndex;
}

#pragma mark - Internal Info

- (NSString*)_feedbackSubject
{
    return [NSString stringWithFormat:@"%@: %@", [self _appName],[self _selectedTopicToSend], nil];
}

- (NSString*)_feedbackBody
{
    NSString *body = [NSString stringWithFormat:@"%@\n\n\n手机型号:\n%@\n\n系统版本:\n%@\n\nAPP名字:\n%@ %@",
                      inputViewText.text,
                      [self _platformString],
                      [UIDevice currentDevice].systemVersion,
                      [self _appName],
                      [self _appVersion], nil];
    
    return body;
}

- (NSString*)_selectedTopic
{
    return [topics objectAtIndex:_selectedTopicsIndex];
}

- (NSString*)_selectedTopicToSend
{
    return [topicsToSend objectAtIndex:_selectedTopicsIndex];
}

- (NSString*)_appName
{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:
            @"CFBundleDisplayName"];
}

- (NSString*)_appVersion
{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
}

- (NSString *) _platform
{
    int mib[2];
    size_t len;
    char *machine;
    
    mib[0] = CTL_HW;
    mib[1] = HW_MACHINE;
    sysctl(mib, 2, NULL, &len, NULL, 0);
    machine = malloc(len);
    sysctl(mib, 2, machine, &len, NULL, 0);
    
    NSString *platform = [NSString stringWithCString:machine encoding:NSASCIIStringEncoding];
    free(machine);
    return platform;
}

- (NSString *) _platformString
{
    NSString *platform = [self _platform];
    if ([platform isEqualToString:@"iPhone1,1"]) return @"iPhone 1G";
    if ([platform isEqualToString:@"iPhone1,2"]) return @"iPhone 3G";
    if ([platform isEqualToString:@"iPhone2,1"]) return @"iPhone 3GS";
    if ([platform isEqualToString:@"iPhone3,1"]) return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone3,3"]) return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone4,1"]) return @"iPhone 4S";
    if ([platform isEqualToString:@"iPhone5,1"]) return @"iPhone 5";
    if ([platform isEqualToString:@"iPhone5,2"]) return @"iPhone 5";
    if ([platform isEqualToString:@"iPhone5,3"]) return @"iPhone 5";
    if ([platform isEqualToString:@"iPod1,1"])   return @"iPod Touch 1G";
    if ([platform isEqualToString:@"iPod2,1"])   return @"iPod Touch 2G";
    if ([platform isEqualToString:@"iPod3,1"])   return @"iPod Touch 3G";
    if ([platform isEqualToString:@"iPod4,1"])   return @"iPod Touch 4G";
    if ([platform isEqualToString:@"iPod5,1"])   return @"iPod Touch 5G";
    if ([platform isEqualToString:@"iPad1,1"])   return @"iPad";
    if ([platform isEqualToString:@"iPad2,1"])   return @"iPad 2 (WiFi)";
    if ([platform isEqualToString:@"iPad2,2"])   return @"iPad 2 (GSM)";
    if ([platform isEqualToString:@"iPad2,3"])   return @"iPad 2 (CDMA)";
    if ([platform isEqualToString:@"iPad2,5"])   return @"iPad Mini (WiFi)";
    if ([platform isEqualToString:@"iPad2,6"])   return @"iPad Mini (GSM)";
    if ([platform isEqualToString:@"iPad2,7"])   return @"iPad Mini (GSM+CDMA)";
    if ([platform isEqualToString:@"iPad3,1"])   return @"iPad 3 (WiFi)";
    if ([platform isEqualToString:@"iPad3,2"])   return @"iPad 3 (GSM)";
    if ([platform isEqualToString:@"iPad3,3"])   return @"iPad 3 (CDMA)";
    if ([platform isEqualToString:@"iPad4,1"])   return @"iPad 4 (WiFi)";
    if ([platform isEqualToString:@"iPad4,2"])   return @"iPad 4 (GSM)";
    if ([platform isEqualToString:@"iPad4,3"])   return @"iPad 4 (CDMA)";
    if ([platform isEqualToString:@"i386"])      return @"iPhone Simulator";
    if ([platform isEqualToString:@"x86_64"])    return @"iPhone Simulator";
    return platform;
}
@end
