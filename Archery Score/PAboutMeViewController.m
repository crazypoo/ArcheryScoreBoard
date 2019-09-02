//
//  PAboutMeViewController.m
//  Archery Score
//
//  Created by 邓杰豪 on 2017/2/21.
//  Copyright © 2017年 邓杰豪. All rights reserved.
//

#import "PAboutMeViewController.h"
#import <CGBase/GPFeedBackViewController.h>

#import <iCarousel/iCarousel.h>
#import <PooTools/YXCustomAlertView.h>

@interface PAboutMeViewController ()<UITableViewDataSource,UITableViewDelegate,iCarouselDataSource, iCarouselDelegate>
{
    UITableView *tbView;
}
@end

@implementation PAboutMeViewController

-(NSArray *)AboutImage
{
    return @[@"Me",@"Alipay",@"WeChat"];
}

-(NSArray *)AboutMeTitle
{
    return @[@"这是我",@"支付宝",@"微信"];
}

-(NSArray *)titleArr
{
    return @[@"去评分",@"帮助与反馈"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = [NSString stringWithFormat:@"关于%@",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"]];
    self.view.backgroundColor = [UIColor whiteColor];

    tbView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    tbView.dataSource = self;
    tbView.delegate = self;
    tbView.showsHorizontalScrollIndicator = NO;
    tbView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:tbView];
    [tbView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self.view);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -----列表代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.titleArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 230;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return kSCREEN_HEIGHT - 334;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *searchIdentifier = @"search Identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:searchIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:searchIdentifier];
    }
    else
    {
        while ([cell.contentView.subviews lastObject] != nil) {
            [(UIView *)[cell.contentView.subviews lastObject] removeFromSuperview];
        }
    }
    cell.textLabel.font = kDEFAULT_FONT(FontName,18);
    cell.textLabel.text = self.titleArr[indexPath.row];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] init];
    UILabel *version = [[UILabel alloc] init];

    headerView.frame = CGRectMake(0, 0, kSCREEN_WIDTH, 230);

    iCarousel *carousel = [[iCarousel alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 200)];
    carousel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    carousel.type = iCarouselTypeCoverFlow;
    carousel.delegate = self;
    carousel.dataSource = self;
    [headerView addSubview:carousel];

    version.frame = CGRectMake(0, carousel.y+carousel.height, kSCREEN_WIDTH, 30);

    version.textAlignment = NSTextAlignmentCenter;
    version.font = kDEFAULT_FONT(FontName,24);
    version.textColor = [UIColor lightGrayColor];
    version.text = [NSString stringWithFormat:@"%@ %@",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"],[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]];
    [headerView addSubview:version];

    return headerView;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footView = [[UIView alloc] init];
    UILabel *info = [[UILabel alloc] init];
    
    footView.frame = CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT - 334);
    info.frame = CGRectMake(0, footView.height-20, kSCREEN_WIDTH, 20);
    
    info.textAlignment = NSTextAlignmentCenter;
    info.textColor = [UIColor lightGrayColor];
    info.font = kDEFAULT_FONT(FontName,12);
    info.text = @"Copyright (c) 2017年 邓杰豪. All rights reserved.";
    [footView addSubview:info];
    
    return footView;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/us/app/archeryboard/id1207773724?l=zh&ls=1&mt=8"] options:@{} completionHandler:^(BOOL success) {
            
        }];
    }
    else if (indexPath.row == 1)
    {
        GPFeedBackViewController *feedBack = [[GPFeedBackViewController alloc]init];
        feedBack.sendWithMail             = YES;
        feedBack.hidesBottomBarWhenPushed = YES;
        feedBack.toRecipients             = [NSArray arrayWithObject:@"273277355@qq.com"];
        feedBack.ccRecipients             = nil;
        feedBack.bccRecipients            = nil;
        feedBack.topics = [NSArray arrayWithObjects:@"界面建议",@"App出现的Bug",@"App整体建议",@"与开发人员聊天",nil];
        [self.navigationController pushViewController:feedBack animated:YES];
    }
}

#pragma mark ---------------> iCarousel methods
- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    return self.AboutImage.count;
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    //create new view if no view is available for recycling
    if (view == nil)
    {
        view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
        ((UIImageView *)view).image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",self.AboutImage[index]]];
        view.contentMode = UIViewContentModeScaleAspectFit;
    }

    return view;
}

- (CATransform3D)carousel:(iCarousel *)carousel itemTransformForOffset:(CGFloat)offset baseTransform:(CATransform3D)transform
{
    //implement 'flip3D' style carousel
    transform = CATransform3DRotate(transform, M_PI / 8.0f, 0.0f, 1.0f, 0.0f);
    return CATransform3DTranslate(transform, 0.0f, 0.0f, offset * carousel.itemWidth);
}

- (CGFloat)carousel:(iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value
{
    //customize carousel display
    switch (option)
    {
            case iCarouselOptionWrap:
        {
            //normally you would hard-code this to YES or NO
            return YES;
        }
            case iCarouselOptionSpacing:
        {
            //add a bit of spacing between the item views
            return value * 1.05f;
        }
            case iCarouselOptionFadeMax:
        {
            if (carousel.type == iCarouselTypeCustom)
            {
                //set opacity based on distance from camera
                return 0.0f;
            }
            return value;
        }
        default:
        {
            return value;
        }
    }
}

-(void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index
{
    YXCustomAlertView *alertV = [[YXCustomAlertView alloc] initAlertViewWithSuperView:kAppDelegateWindow alertTitle:self.AboutMeTitle[index] withButtonAndTitleFont:kDEFAULT_FONT(FontName, 18) titleColor:kRandomColor bottomButtonTitleColor:@[kRandomColor] verLineColor:kRandomColor alertViewBackgroundColor:kRandomColor heightlightedColor:kRandomColor moreButtonTitleArray:@[@"确定",@"取消"] viewTag:0 viewAnimation:AlertAnimationTypeTop touchBackGround:YES setCustomView:^(YXCustomAlertView * _Nonnull alertView) {
        
    } clickAction:^(YXCustomAlertView * _Nonnull alertView, NSInteger buttonIndex) {
        if (buttonIndex==0)
        {
            [alertView dissMiss];
            alertView = nil;
        }
        else
        {
            [alertView dissMiss];
            alertView = nil;
        }

    } didDismissBlock:^(YXCustomAlertView * _Nonnull alertView) {
        
    }];
    [alertV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(kSCREEN_WIDTH);
        make.width.offset(kSCREEN_WIDTH-40);
        make.centerX.centerY.equalTo(kAppDelegateWindow);
    }];
}

@end
