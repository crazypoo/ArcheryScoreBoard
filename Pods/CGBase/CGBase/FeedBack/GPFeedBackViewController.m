//
//  GPFeedBackViewController.m
//  Tongxunlu
//
//  Created by crazypoo on 14/8/5.
//  Copyright (c) 2014年 广州文思海辉亚信外派iOS开发小组. All rights reserved.
//

#import "GPFeedBackViewController.h"

#include <sys/types.h>
#include <sys/sysctl.h>

#import <PooTools/SensitiveWordTools.h>
#import <PooTools/PMacros.h>
#import "CGBaseMarcos.h"
#import <Masonry/Masonry.h>
#import <PooTools/UIView+ModifyFrame.h>
#import <PooTools/NSString+WPAttributedMarkup.h>
#import "SLBaseVC+EX.h"
#import "CGBaseGobalTools.h"
#import "CGGobalAPI.h"

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

-(instancetype)initWithApiBaseData:(NSMutableDictionary *)baseDic
{
    self = [super init];
    if (self)
    {
        self.baseDic = [[NSMutableDictionary alloc] initWithDictionary:baseDic];
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
//    self.navigationController.navigationBar.hidden = NO;
//    [self setNav:AppWhite hideLine:YES tintColor:AppBlack];
    [self setStatusBar:UIStatusBarStyleDefault];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"kN_CreateFeedback" object:nil];
//    self.navigationController.navigationBar.hidden = YES;
}

+ (BOOL)isAvailable
{
    return [MFMailComposeViewController canSendMail];
}

-(id)init
{
    self = [super init];
    if(self)
    {
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
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.viewW = IS_IPAD ? kSCREEN_WIDTH/2 : kSCREEN_WIDTH;
    self.navigationBar.size = IS_IPAD ? CGSizeZero : CGSizeMake(self.viewW, NavigationBarNormalHeight);

    self.navigationBar.scrollType = SL_NavigationBarScrollType_BigViewToSmallView;
    self.navigationBar.lineView.hidden = NO;
    self.navigationBar.backgroundColor = [CGBaseGobalTools AppCellBGColor];

    [self buildNav];

    self.backFontSize = IS_IPAD ? 10 : 20;
    self.uploadFont = IS_IPAD ? APPFONTBOLD(6) : AppNavCoupleButton;
    self.largeTitleFont = AppLargeTitleFont_BOLD;
    self.smallTitleFontSize = IS_IPAD ? 9 : 18;

    self.tableView    = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.dataSource                     = self;
    self.tableView.delegate                       = self;
    self.tableView.showsHorizontalScrollIndicator = NO;
    self.tableView.showsVerticalScrollIndicator   = NO;
    self.tableView.separatorStyle                 = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.navigationBar.mas_bottom);
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(backToUpLoadView:) name:@"back" object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleFeedbackNotification:) name:kN_CreateFeedback object:nil];
}

-(void)backToUpLoadView:(NSNotification *)NSNotification
{
    kReturnsToTheUpperLayer;
}

-(void)buildNav
{
    [self setNavBack:@"意见反馈"];

    self.navRightView = [UIView new];
    self.navRightView.size = CGSizeMake(95, 0);
    [self setRightCustom:self.navRightView];
    
    NSString *doneBtnName;
    if ([[CGBaseGobalTools getBundleID] isEqualToString:@"com.crazykidhao.LandloardTool"]) {
        doneBtnName = @"image_success_cgl";
    }
    else if ([[CGBaseGobalTools getBundleID] isEqualToString:@"com.crazykidhao.CloudGateCustom"]) {
        doneBtnName = @"image_success_cgc";
    }
    else
    {
        doneBtnName = @"image_success_cgl";
    }
    UIButton *qrButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [qrButton setImage:[CGBaseGobalTools image:doneBtnName compatibleWithTraitCollection:self.traitCollection] forState:UIControlStateNormal];
    [qrButton addTarget:self action:@selector(nextDidPress:) forControlEvents:UIControlEventTouchUpInside];
    [self.navRightView addSubview:qrButton];
    [qrButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.offset(ButtonH);
        make.right.equalTo(self.navRightView).offset(-ViewSpace);
        make.centerY.equalTo(self.navRightView.mas_centerY);
    }];
}

-(void)backAct:(id)sender
{
    kReturnsToTheUpperLayer
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if(_isFeedbackSent){
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return CellHeight*3;
}
//
//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    if (section == 1) {
//        return 25;
//    }
//    return 100;
//}
//
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//
//    if (section == 1) {
//        UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 25)];
//        titleView.backgroundColor = kClearColor;
//
//        UILabel *HeaderLabel = [[UILabel alloc] init];
//        HeaderLabel.font = APPFONT(18);
//        HeaderLabel.textColor = AppWhite;
//        HeaderLabel.textAlignment = NSTextAlignmentCenter;
//        HeaderLabel.backgroundColor = AppColor;
//        HeaderLabel.text = @"本机信息";
//        [titleView addSubview:HeaderLabel];
//        [HeaderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(titleView).offset(ViewSpace);
//            make.right.equalTo(titleView).offset(-ViewSpace);
//            make.height.equalTo(titleView);
//        }];
//        return titleView;
//    }
//    else
//    {
//        UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 100)];
//        titleView.backgroundColor = AppWhite;
//
//        UIView *bigTitleBackground = [UIView new];
//        [titleView addSubview:bigTitleBackground];
//        [bigTitleBackground mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(titleView).offset(ViewSpace);
//            make.right.equalTo(titleView).offset(-ViewSpace);
//            make.height.offset(80);
//            make.top.offset(20);
//        }];
//
//        UILabel *bigLabel = [UILabel new];
//        bigLabel.textAlignment = NSTextAlignmentLeft;
//        bigLabel.font = APPFONTBOLD(30);
//        bigLabel.textColor = AppBlack;
//        bigLabel.text = @"我认为";
//        [bigTitleBackground addSubview:bigLabel];
//        [bigLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(bigTitleBackground);
//            make.height.offset(40);
//            make.bottom.equalTo(bigTitleBackground.mas_centerY);
//        }];
//
//        UILabel *smallLabel = [UILabel new];
//        smallLabel.textAlignment = NSTextAlignmentLeft;
//        smallLabel.font = APPFONT(18);
//        smallLabel.textColor = AppBlack;
//        smallLabel.text = @"提出您的意见,帮助我们提供更好的服务";
//        [bigTitleBackground addSubview:smallLabel];
//        [smallLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.right.equalTo(bigTitleBackground);
//            make.height.offset(20);
//            make.top.equalTo(bigTitleBackground.mas_centerY);
//        }];
//        return titleView;
//    }
//    return nil;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        if(indexPath.section == 1)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        }
        else
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];

            NSDictionary *dataHeaderStyle = @{
                                              @"body":@[AppLargeTitleFont,[CGBaseGobalTools AppTextBlack]],
                                              @"info":@[AppFontNormal,[UIColor lightGrayColor]],
                                              };
            UILabel *titleLabel = [UILabel new];
            titleLabel.numberOfLines = 0;
            titleLabel.lineBreakMode = NSLineBreakByCharWrapping;
            titleLabel.attributedText = [@"<body>我认为</body>\n<info>提出您的意见,帮助我们提供更好的服务</info>" attributedStringWithStyleBook:dataHeaderStyle];
            [cell.contentView addSubview:titleLabel];
            [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(cell.contentView).offset(ViewSpace);
                make.right.equalTo(cell.contentView).offset(-ViewSpace);
                make.top.equalTo(cell.contentView);
                make.height.offset(CellHeight);
            }];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            inputViewText = [PooTextView new];
            inputViewText.backgroundColor = [CGBaseGobalTools AppSuperLightGray];
            inputViewText.placeholder = @"请输入您须要反馈的意见";
            inputViewText.delegate = self;
            inputViewText.returnKeyType = UIReturnKeyDone;
            inputViewText.font = AppFontNormal;
            if ([[CGBaseGobalTools getBundleID] isEqualToString:@"com.crazykidhao.LandloardTool"]) {
                inputViewText.textColor = [CGBaseGobalTools AppAlertButtonColor];
            }
            else if ([[CGBaseGobalTools getBundleID] isEqualToString:@"com.crazykidhao.CloudGateCustom"]) {
                inputViewText.textColor = [CGBaseGobalTools AppOrange];
            }
            else
            {
                inputViewText.textColor = [CGBaseGobalTools AppBlue];
            }
            [cell.contentView addSubview:inputViewText];
            [inputViewText mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(cell.contentView).offset(ViewSpace);
                make.right.equalTo(cell.contentView).offset(-ViewSpace);
                make.top.equalTo(titleLabel.mas_bottom);
                make.bottom.equalTo(cell.contentView);
            }];
            kViewBorderRadius(inputViewText, AppRadius, 0, kClearColor);
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
        {
//            UIView *lineView = [UIView new];
//            lineView.backgroundColor = AppLineGray;
//            [cell.contentView addSubview:lineView];
//            [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.height.offset(0.5);
//                make.left.equalTo(cell.contentView).offset(ViewSpace);
//                make.right.equalTo(cell.contentView).offset(-ViewSpace);
//                make.top.offset(CellHeight-0.5);
//            }];
//            switch (indexPath.row) {
//                case 0:
//                    cell.textLabel.font = AppTableViewCellFont;
//                    cell.detailTextLabel.font = AppTableViewCellDetailFont;
//                    cell.textLabel.text = @"手机型号";
//                    cell.detailTextLabel.text = [self _platformString];
//                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//                    break;
//                case 1:
//                    cell.textLabel.font = AppTableViewCellFont;
//                    cell.detailTextLabel.font = AppTableViewCellDetailFont;
//                    cell.textLabel.text = @"系统版本";
//                    cell.detailTextLabel.text = [UIDevice currentDevice].systemVersion;
//                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//                    break;
//                case 2:
//                    cell.textLabel.font = AppTableViewCellFont;
//                    cell.detailTextLabel.font = AppTableViewCellDetailFont;
//                    cell.textLabel.text = @"APP名字";
//                    cell.detailTextLabel.text = [self _appName];
//                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//                    break;
//                case 3:
//                    cell.textLabel.font = AppTableViewCellFont;
//                    cell.detailTextLabel.font = AppTableViewCellDetailFont;
//                    cell.textLabel.text = @"APP版本号";
//                    cell.detailTextLabel.text = [self _appVersion];
//                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//                    break;
//                default:
//                    break;
//            }
        }
            break;
        default:
            break;
    }
    
    return cell;
}

#pragma mark - UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
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

#pragma mark ------> 按钮
- (void)cancelDidPress:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)nextDidPress:(id)sender
{
    [inputViewText resignFirstResponder];
    if (!self.sendWithMail) {
    }else{
        if ([inputViewText.text length]>6) {
            [self sendByApi];
        }
        else
        {
            [CGBaseGobalTools gobalShowAlertTitle:AlertNormalTitle message:@"反馈内容必须要6个字以上"];
        }
    }
}

-(void)sendByApi
{
    if (!kStringIsEmpty(inputViewText.text))
    {
        [self creatFeedBackContent:inputViewText.text];
    }
    else if ([[SensitiveWordTools sharedInstance] hasSensitiveWord:inputViewText.text])
    {
        [CGBaseGobalTools gobalShowAlertTitle:AlertNormalTitle message:@"用户评论存在非法字符!"];
    }
    else
    {
        [CGBaseGobalTools gobalShowAlertTitle:AlertNormalTitle message:@"内容不能为空"];
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

#pragma mark ------> UITextViewDelegate
//- (void)textViewDidChange:(UITextView *)textView
//{
//
//}
//
-(void)textViewDidEndEditing:(UITextView *)textView
{
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:0 animated:YES];
}

-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    if(result==MFMailComposeResultCancelled)
    {
    }
    else if(result==MFMailComposeResultSent)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"back" object:nil];
        _isFeedbackSent = YES;
    }
    else if
        (result==MFMailComposeResultFailed){
        [CGBaseGobalTools gobalShowAlertTitle:AlertNormalTitle message:@"出错啦"];
    }
    [controller dismissViewControllerAnimated:YES completion:nil];
    
}


//- (void)feedbackTopicsViewController:(GPFeedBackTopicsTableViewController *)feedbackTopicsViewController didSelectTopicAtIndex:(NSInteger)selectedIndex {
//    _selectedTopicsIndex = selectedIndex;
//}

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

#pragma mark --------afn3.0
-(void)creatFeedBackContent:(NSString *)content
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:self.baseDic];
    [dic setObject:content forKey:@"content"];
    [dic setObject:@"true" forKey:@"isLogin"];

    [CGBaseGobalTools apiServeApiURL:Feedback withParmars:dic hideHub:NO handle:^(BOOL success, NSMutableDictionary *infoDict) {
        if (success)
        {
            if (GETDATATRUE)
            {
                [CGBaseGobalTools gobalShowAlertTitle:AlertNormalTitle message:@"尊敬得用户,非常感谢您反馈的意见."];
                kReturnsToTheUpperLayer
            }
            else
            {
                [CGBaseGobalTools gobalShowAlertTitle:AlertNormalTitle message:ERRORMESSAGE];
            }
        }
        else
        {
            [CGBaseGobalTools gobalShowAlertTitle:AlertNormalTitle message:ERRORMESSAGE];
        }
    }];
}
@end
