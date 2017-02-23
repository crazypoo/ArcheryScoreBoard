//
//  ViewController.m
//  Archery Score
//
//  Created by Staff on 2017/2/14.
//  Copyright © 2017年 邓杰豪. All rights reserved.
//

#import "ViewController.h"
#import "PTargetOptionViewController.h"
#import "CBHistoryCollectionViewController.h"
#import "PAboutMeViewController.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource,IMBannerDelegate,IMInterstitialDelegate>
{
    UITableView *tbView;
}
@property (nonatomic, strong) IMBanner *banner;
@property (nonatomic, strong) IMInterstitial *inter;
@end

@implementation ViewController

-(NSArray *)titleArray
{
    return @[@"新开始",@"历史",@"关于我"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.title = @"主界面";
    self.leftNavBtn.hidden = YES;

    tbView    = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight) style:UITableViewStylePlain];
    tbView.dataSource                     = self;
    tbView.delegate                       = self;
    tbView.showsHorizontalScrollIndicator = NO;
    tbView.showsVerticalScrollIndicator   = NO;
    tbView.separatorStyle                 = UITableViewCellSeparatorStyleSingleLine;
    [self.view addSubview:tbView];


    CGRect adBanner;
    if (IS_IPAD) {
        adBanner = CGRectMake(0, screenHeight-100-HEIGHT_NAVBAR, screenWidth, 100);
    }
    else if (IS_IPHONE)
    {
        adBanner = CGRectMake(0, screenHeight-50-HEIGHT_NAVBAR, screenWidth, 50);
    }

    self.banner = [[IMBanner alloc] initWithFrame:adBanner placementId:1486106990840];

    //Optional: set a delegate to be notified if the banner is loaded/failed etc.
    self.banner.delegate = self;

    [self.banner load];

    [self.view addSubview:self.banner];

    self.inter = [[IMInterstitial alloc] initWithPlacementId:1486614043177 delegate:self];
    [self.inter load];
    [self.inter showFromViewController:self];
}

#pragma mark ---------------> UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.titleArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

static NSString *cellIdentifier = @"CELLS";

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    else
    {
        while ([cell.contentView.subviews lastObject] != nil) {
            [(UIView *)[cell.contentView.subviews lastObject] removeFromSuperview];
        }
    }
    cell.selectionStyle = UITableViewCellEditingStyleNone;
    cell.textLabel.text = self.titleArray[indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    return cell;
}

#pragma mark ---------------> UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.000001;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *fView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 0)];

    return fView;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *hView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 0)];
    return hView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
        {
            PTargetOptionViewController *vc = [[PTargetOptionViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
            vc.title = @"靶纸选项";
        }
            break;
        case 1:
        {
            UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
            layout.itemSize                    = CGSizeMake((screenWidth-20)/2, (screenHeight-30-HEIGHT_NAVBAR)/2);

            CGFloat paddingY                   = 10;
            CGFloat paddingX                   = 5;
            layout.sectionInset                = UIEdgeInsetsMake(paddingY, paddingX, paddingY, paddingX);
            layout.minimumLineSpacing          = paddingY;

            CBHistoryCollectionViewController *hV = [[CBHistoryCollectionViewController alloc] initWithCollectionViewLayout:layout];
            [self.navigationController pushViewController:hV animated:YES];

        }
            break;
        case 2:
        {
            PAboutMeViewController *about = [[PAboutMeViewController alloc] init];
            [self.navigationController pushViewController:about animated:YES];
        }
            break;
        default:
            break;
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark ---------------> INMOBI
/**
 * Notifies the delegate that the banner has finished loading
 */
-(void)bannerDidFinishLoading:(IMBanner*)banner {
    NSLog(@"InMobi Banner finished loading");
}
/**
 * Notifies the delegate that the banner has failed to load with some error.
 */
-(void)banner:(IMBanner*)banner didFailToLoadWithError:(IMRequestStatus*)error {
    NSLog(@"InMobi Banner failed to load with error %@", error);
}
/**
 * Notifies the delegate that the banner was interacted with.
 */
-(void)banner:(IMBanner*)banner didInteractWithParams:(NSDictionary*)params {
    NSLog(@"InMobi Banner did interact with params : %@", params);
}
/**
 * Notifies the delegate that the user would be taken out of the application context.
 */
-(void)userWillLeaveApplicationFromBanner:(IMBanner*)banner {
    NSLog(@"User will leave application from InMobi Banner");
}
/**
 * Notifies the delegate that the banner would be presenting a full screen content.
 */
-(void)bannerWillPresentScreen:(IMBanner*)banner {
    NSLog(@"InMobi Banner will present a screen");
}
/**
 * Notifies the delegate that the banner has finished presenting screen.
 */
-(void)bannerDidPresentScreen:(IMBanner*)banner {
    NSLog(@"InMobi Banner finished presenting a screen");
}
/**
 * Notifies the delegate that the banner will start dismissing the presented screen.
 */
-(void)bannerWillDismissScreen:(IMBanner*)banner {
    NSLog(@"InMobi Banner will dismiss a presented screen");
}
/**
 * Notifies the delegate that the banner has dismissed the presented screen.
 */
-(void)bannerDidDismissScreen:(IMBanner*)banner {
    NSLog(@"InMobi Banner dismissed a presented screen");
}
/**
 * Notifies the delegate that the user has completed the action to be incentivised with.
 */
-(void)banner:(IMBanner*)banner rewardActionCompletedWithRewards:(NSDictionary*)rewards {
    NSLog(@"InMobi Banner rewarded action completed. Rewards : %@", rewards);
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}
@end
