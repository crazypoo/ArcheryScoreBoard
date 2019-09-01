//
//  CGAboutMeViewController.m
//  CloudGateCustom
//
//  Created by 邓杰豪 on 6/5/18.
//  Copyright © 2018年 邓杰豪. All rights reserved.
//

#import "CGAboutMeViewController.h"
#import "CGUserAgreementViewController.h"

#import <PooTools/WPAttributedStyleAction.h>
#import <PooTools/WPHotspotLabel.h>
#import <CoreText/CoreText.h>
#import <Masonry/Masonry.h>
#import "CGBaseMarcos.h"
#import <PooTools/PMacros.h>
#import "SLBaseVC+EX.h"
#import <PooTools/NSString+WPAttributedMarkup.h>
#import "BaseNavigationController.h"
#import <PooTools/UIButton+Block.h>

@interface CGAboutMeViewController ()

@property (nonatomic, assign) CGFloat navBackW;
@property (nonatomic, assign) CGFloat normalLabelH;
@property (nonatomic, assign) CGFloat otherLabelH;
@end

@implementation CGAboutMeViewController

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
//    [(SLBackGroundView*)self.view bgScroll].scrollEnabled = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [CGBaseGobalTools AppWhite];
    
    self.navBackW = IS_IPAD ? 240 : 120;
    self.normalLabelH = IS_IPAD ? 50 : 25;
    self.otherLabelH = IS_IPAD ? 100 : 50;

    self.navigationBar.scrollType = SL_NavigationBarScrollType_BigViewToSmallView;
    self.navigationBar.lineView.hidden = NO;
    if ([[CGBaseGobalTools getBundleID] isEqualToString:@"com.crazykidhao.CloudGateWorker"]) {
        self.navigationBar.backgroundColor = [CGBaseGobalTools AppBlue];
    }
    else
    {
        self.navigationBar.backgroundColor = [CGBaseGobalTools AppCellBGColor];
    }

    [self setNavBack:@"关于我们"];

    UIImageView *appIcon = [UIImageView new];
    appIcon.image = kImageNamed(@"image_about");
    [self.view addSubview:appIcon];
    [appIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.width.height.offset(self.navBackW);
        make.centerY.equalTo(self.view.mas_centerY).offset(-50);
    }];
    kViewBorderRadius(appIcon, AppRadius, 0, kClearColor);
    
    UILabel *appNameLabel = [UILabel new];
    appNameLabel.font = AppFontNormal;
    appNameLabel.textAlignment = NSTextAlignmentCenter;
    appNameLabel.numberOfLines = 0;
    appNameLabel.lineBreakMode = NSLineBreakByCharWrapping;
    appNameLabel.text = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"];
    [self.view addSubview:appNameLabel];
    [appNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.height.offset(self.normalLabelH);
        make.top.equalTo(appIcon.mas_bottom);
    }];
    
    UILabel *versionLabel = [UILabel new];
    versionLabel.font = AppFontNormal;
    versionLabel.textAlignment = NSTextAlignmentCenter;
    versionLabel.numberOfLines = 0;
    versionLabel.lineBreakMode = NSLineBreakByCharWrapping;
    versionLabel.text = [NSString stringWithFormat:@"version:%@",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
    [self.view addSubview:versionLabel];
    [versionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.height.offset(self.normalLabelH);
        make.top.equalTo(appNameLabel.mas_bottom);
    }];
    
    UILabel *buildLabel = [UILabel new];
    buildLabel.font = AppFontNormal;
    buildLabel.textAlignment = NSTextAlignmentCenter;
    buildLabel.textColor = [CGBaseGobalTools AppTextBlack];
    buildLabel.text = [NSString stringWithFormat:@"build:%@",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]];
    [self.view addSubview:buildLabel];
    [buildLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.height.offset(25);
        make.top.equalTo(versionLabel.mas_bottom);
    }];
    
#if DEBUG
    [self createUpdate:buildLabel];
#else
    if ([[CGBaseGobalTools getBundleID] isEqualToString:@"com.crazykidhao.CloudGateWorker"]) {
        [self createUpdate:buildLabel];
    }
    else
    {
        [CGBaseGobalTools getEmbeddedInfo:^(BOOL isDevelopement, NSDictionary *embeddedInfo) {
            if (isDevelopement) {
                [self createUpdate:buildLabel];
            }
        }];
    }
#endif
            
    UILabel *ltdLabel = [UILabel new];
    ltdLabel.font = AppNavCoupleButton;
    ltdLabel.textAlignment = NSTextAlignmentCenter;
    ltdLabel.numberOfLines = 0;
    ltdLabel.lineBreakMode = NSLineBreakByCharWrapping;
    ltdLabel.text = @"Copyright(c)2019-2020\n云门科技(广州)有限责任公司版权所有";
    [self.view addSubview:ltdLabel];
    [ltdLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.height.offset(40);
        make.bottom.equalTo(self.view).offset(-60);
    }];
    
    NSDictionary *style = @{
                            @"body":@[
                                    AppNavCoupleButton,
                                    [CGBaseGobalTools AppTextBlack]
                                    ],
                            @"help":@[
                                    @{NSUnderlineStyleAttributeName : @(kCTUnderlineStyleSingle|kCTUnderlinePatternSolid)},
                                    [WPAttributedStyleAction styledActionWithAction:^{
                                        [self gotoHtmlWebPage:0];
                                    }]
                                    ],
                            @"privacy":@[
                                    @{NSUnderlineStyleAttributeName : @(kCTUnderlineStyleSingle|kCTUnderlinePatternSolid)},
                                    [WPAttributedStyleAction styledActionWithAction:^{
                                        [self gotoHtmlWebPage:1];
                                    }]
                                    ],
                            @"link":@[
                                    AppNavCoupleButton,
                                    [CGBaseGobalTools AppTextBlack]
                                    ]
                            };
    
    WPHotspotLabel *agreementLabel = [WPHotspotLabel new];
    agreementLabel.textAlignment = NSTextAlignmentCenter;
    agreementLabel.attributedText  = [@"《<help>隐私保护指引</help>》和《<privacy>用户协议</privacy>》" attributedStringWithStyleBook:style];
    [self.view addSubview:agreementLabel];
    [agreementLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.height.offset(20);
        make.top.equalTo(ltdLabel.mas_bottom).offset(20);
    }];
}

-(void)createUpdate:(UILabel *)label
{
    UIButton *updateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    updateBtn.titleLabel.font = AppFontNormal;
    [updateBtn setTitleColor:[CGBaseGobalTools AppTextBlack] forState:UIControlStateNormal];
    [updateBtn setTitle:@"检测更新" forState:UIControlStateNormal];
    [updateBtn addActionHandler:^(UIButton *sender) {
        [CGAboutMeViewController getPGYUpdateInfo];
    }];
    [self.view addSubview:updateBtn];
    [updateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.height.offset(25);
        make.top.equalTo(label.mas_bottom);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark ------> 按钮
-(void)backAction:(UIButton *)sender
{
    kReturnsToTheUpperLayer
}

-(void)gotoHtmlWebPage:(NSInteger)type
{
    CGUserAgreementViewController *view = [[CGUserAgreementViewController alloc] initWithType:type];
    BaseNavigationController *navHtml = [[BaseNavigationController alloc] initWithRootViewController:view];
    [self presentViewController:navHtml animated:YES completion:^{
    }];
}

+(void)getPGYUpdateInfo
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    
    NSString *apiKey;
    NSString *appKey;
    if ([[CGBaseGobalTools getBundleID] isEqualToString:@"com.crazykidhao.LandloardTool"]) {
        apiKey = @"39d26a652eab38db062ee638b5e9392a";
        appKey = @"f2336c0f4c1006c417475bf20571e904";
    }
    else if ([[CGBaseGobalTools getBundleID] isEqualToString:@"com.crazykidhao.CloudGateCustom"]) {
        apiKey = @"39d26a652eab38db062ee638b5e9392a";
        appKey = @"7d3ebb819b42aff642fbf5d3853ee912";
    }
    else
    {
        apiKey = @"39d26a652eab38db062ee638b5e9392a";
        appKey = @"b813a316f4bd6670dd4430a5de67c79f";
    }

    [dic setObject:apiKey forKey:@"_api_key"];
    [dic setObject:appKey forKey:@"appKey"];

    [CGBaseGobalTools customServerAddress:[NSURL URLWithString:@"https://www.pgyer.com"] customApiURL:@"/apiv2/app/check" withParmars:dic hideHub:YES handle:^(BOOL success, NSMutableDictionary *infoDict) {
        if (success)
        {
            NSString *appVersion = infoDict[@"data"][@"buildVersion"];
            NSString *appBuild = infoDict[@"data"][@"buildVersionNo"];
            NSString *appUpdateInfo = infoDict[@"data"][@"buildUpdateDescription"];
            NSString *appUpdateURL = infoDict[@"data"][@"downloadURL"];

            if (![appVersion isEqualToString:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]]) {
                [CGAboutMeViewController updateAppAlert:appUpdateInfo updateURL:appUpdateURL];
            }
            else
            {
                if ([appBuild integerValue] > [[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"] integerValue])
                {
                    [CGAboutMeViewController updateAppAlert:appUpdateInfo updateURL:appUpdateURL];
                }
            }
        }
    }];
}

+(void)updateAppAlert:(NSString *)updateInfo updateURL:(NSString *)url
{
    [CGBaseGobalTools gobalFreakSystemAlertWithTitle:@"新版本提示" withMessage:[NSString stringWithFormat:@"检测到新版本\n%@",updateInfo] withCancelTitle:@"下次更新" withOkTitle:@"更新" okHandle:^{
        if (@available(iOS 10.0, *)) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url] options:@{} completionHandler:nil];
        }
    } cencelHandle:^{
        
    }];
}

@end
