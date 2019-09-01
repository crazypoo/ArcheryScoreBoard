//
//  CGUserAgreementViewController.m
//  CloudGateCustom
//
//  Created by 邓杰豪 on 2/5/2018.
//  Copyright © 2018 邓杰豪. All rights reserved.
//

#import "CGUserAgreementViewController.h"
#import <WebKit/WebKit.h>
#import "CGBaseMarcos.h"
#import <Masonry/Masonry.h>
#import <PooTools/UIView+ModifyFrame.h>
#import "CGBaseGobalTools.h"
#import "CGGobalAPI.h"

@interface CGUserAgreementViewController ()<WKNavigationDelegate>
@property (nonatomic,assign)NSInteger viewType;
@property (nonatomic, strong) UIView *navLeftView;
@property (nonatomic, strong) UILabel *viewTitle;
@end

@implementation CGUserAgreementViewController

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
//    [(SLBackGroundView*)self.view bgScroll].scrollEnabled = NO;
}

-(instancetype)initWithType:(NSInteger)type
{
    self = [super init];
    if (self)
    {
        self.viewType = type;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [CGBaseGobalTools AppWhite];
    
    self.navigationBar.scrollType = SL_NavigationBarScrollType_BigViewToSmallView;
    self.navigationBar.lineView.hidden = NO;
    self.navigationBar.backgroundColor = [CGBaseGobalTools AppCellBGColor];
    
    [self.navigationBar.btnBack setImage:kImageNamed(@"image_Back") forState:UIControlStateNormal];
    self.navigationBar.btnBack.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.navigationBar.btnBack.width = 44;
    [self.navigationBar.btnBack addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    
    WKWebView *webView = [WKWebView new];
    webView.navigationDelegate = self;
    [self.view addSubview:webView];
    [webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navigationBar.mas_bottom);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];

    NSURL *str;
    switch (self.viewType) {
        case 0:
        {
            if ([[CGBaseGobalTools getBundleID] isEqualToString:@"com.crazykidhao.LandloardTool"]) {
                str = [CGBaseGobalTools getImageFullUrlwithServerPartUrl:PrivacyURLLandLoard];
            }
            else if ([[CGBaseGobalTools getBundleID] isEqualToString:@"com.crazykidhao.CloudGateCustom"]) {
                str = [CGBaseGobalTools getImageFullUrlwithServerPartUrl:PrivacyURL];
            }
            else
            {
                str = [CGBaseGobalTools getImageFullUrlwithServerPartUrl:@""];
            }
        }
            break;
        case 1:
        {
            str = [CGBaseGobalTools getImageFullUrlwithServerPartUrl:Agreement];
        }
            break;
        default:
        {
            str = [CGBaseGobalTools getImageFullUrlwithServerPartUrl:@""];
        }
            break;
    }
    NSURLRequest *request = [NSURLRequest requestWithURL:str];
    [webView loadRequest:request];
    
    self.navLeftView = [UIView new];
    [self setTitleCustom:self.navLeftView];
    
    self.viewTitle = [UILabel new];
    self.viewTitle.textColor = [CGBaseGobalTools AppTextBlack];
    self.viewTitle.font = AppLargeTitleFont_BOLD;
    [self.navLeftView addSubview:self.viewTitle];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark ------> 按钮
-(void)backAction:(UIButton *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark ---------------> WKNavigationDelegate
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    NSString *titleHtmlInfo = [webView title];
    CGFloat titleW = kAdaptedWidth(AppLargeTitleFont_SIZE)*titleHtmlInfo.length;
    self.viewTitle.text = titleHtmlInfo;
    [self.viewTitle mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(titleW));
        make.top.bottom.equalTo(self.navLeftView);
        make.centerX.equalTo(self.view);
    }];
}

@end
