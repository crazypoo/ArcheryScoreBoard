//
//  ViewController.m
//  OCAndSwift
//
//  Created by MYX on 2017/3/24.
//  Copyright © 2017年 邓杰豪. All rights reserved.
//

#import "ViewController.h"
#import "HealthKitManager.h"
#import "CBHistoryCollectionViewController.h"
#import "PAboutMeViewController.h"
#import <WatchConnectivity/WatchConnectivity.h>
#import <PTools/PHealthKit.h>

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource,WCSessionDelegate,PHealthKitDelegate>
{
    UITableView *tbView;
    PHealthKit *healthStore;
    UILabel *healthLabel;
    UIActivityIndicatorView *flower;
}
@end

@implementation ViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if([WCSession isSupported]){
        WCSession *session = [WCSession defaultSession];
        session.delegate = self;
        [session activateSession];
    }
    
    flower = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    flower.frame = [AppDelegate appDelegate].avatar.bounds;
    [[AppDelegate appDelegate].avatar addSubview:flower];
    
    healthLabel = [[UILabel alloc] initWithFrame:[AppDelegate appDelegate].avatar.bounds];
    healthLabel.backgroundColor = [UIColor clearColor];
    healthLabel.textColor = [UIColor lightGrayColor];
    healthLabel.textAlignment = NSTextAlignmentCenter;
    [[AppDelegate appDelegate].avatar addSubview:healthLabel];
    healthLabel.hidden = YES;
    
    healthStore = [PHealthKit shareInstance];
    healthStore.delegate = self;
//    if ([HKHealthStore isHealthDataAvailable]) {
//        NSSet *readDataTypes = [self dataTypesToRead];
//        
//        if (!healthStore.healthStore) {
//            healthStore.healthStore = [HKHealthStore new];
//        }
//        
//        [healthStore.healthStore requestAuthorizationToShareTypes:nil readTypes:readDataTypes completion:^(BOOL success, NSError *error) {
//            if (!success) {
//                NSLog(@"You didn't allow HealthKit to access these read data types. In your app, try to handle this error gracefully when a user decides not to provide access. The error was: %@. If you're using a simulator, try it on a device.", error);
//                return;
//            }
//            
//            dispatch_async(dispatch_get_main_queue(), ^{
//                NSLog(@"The user allow the app to read information about StepCount");
//            });
//        }];
//    }
//    
//    [self stepAllCount];

}

-(NSArray *)titleArray
{
    return @[@"新开始",@"历史",@"关于我"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.title = @"主界面";
    
    tbView    = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    tbView.dataSource                     = self;
    tbView.delegate                       = self;
    tbView.showsHorizontalScrollIndicator = NO;
    tbView.showsVerticalScrollIndicator   = NO;
    tbView.separatorStyle                 = UITableViewCellSeparatorStyleSingleLine;
    [self.view addSubview:tbView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stepAllCounts) name:UIApplicationWillResignActiveNotification object:nil];
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
    UIView *fView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    
    return fView;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *hView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    return hView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
        {
            HomePageViewController *vc = [[HomePageViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
            vc.title = @"靶纸选项";
        }
            break;
        case 1:
        {
            UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
            layout.itemSize                    = CGSizeMake((SCREEN_WIDTH-20)/2, SCREEN_WIDTH-20);
            
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

#pragma mark ---------------> PHealthKit
-(void)kitDataIsload:(BOOL)isload stepStr:(NSString *)stepStr
{
    healthLabel.hidden = NO;
    healthLabel.text = [NSString stringWithFormat:@"你当前走了%@步",stepStr];
    [flower stopAnimating];
    [flower setHidesWhenStopped:YES];
    
    WCSession *session = [WCSession defaultSession];
    
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] objectForKey:@"group.com.omcn.Archery"],@"group.com.omcn.Archery", nil];
    
    NSUserDefaults* userDefault = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.omcn.Archery"];
    [userDefault setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"group.com.omcn.Archery"] forKey:@"group.com.omcn.Archery"];
    
    
    [session sendMessage:dic replyHandler:^(NSDictionary<NSString *,id> * _Nonnull replyMessage) {
        NSLog(@"replay: %@", replyMessage);
        
    } errorHandler:^(NSError * _Nonnull error) {
        NSLog(@"Error: %@", error);
    }];

}

-(void)stepAllCounts
{
    [healthStore stepAllCount];
}
@end
