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

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *tbView;
    HealthKitManager *healthStore;
    double stepCount;
    UILabel *healthLabel;
    UIActivityIndicatorView *flower;
}
@end

@implementation ViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    flower = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    flower.frame = [AppDelegate appDelegate].avatar.bounds;
    [[AppDelegate appDelegate].avatar addSubview:flower];
    
    healthLabel = [[UILabel alloc] initWithFrame:[AppDelegate appDelegate].avatar.bounds];
    healthLabel.backgroundColor = [UIColor clearColor];
    healthLabel.textColor = [UIColor lightGrayColor];
    healthLabel.textAlignment = NSTextAlignmentCenter;
    [[AppDelegate appDelegate].avatar addSubview:healthLabel];
    healthLabel.hidden = YES;
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
    
    healthStore = [HealthKitManager shareInstance];
    if ([HKHealthStore isHealthDataAvailable]) {
        NSSet *readDataTypes = [self dataTypesToRead];
        
        if (!healthStore.healthStore) {
            healthStore.healthStore = [HKHealthStore new];
        }
        
        [healthStore.healthStore requestAuthorizationToShareTypes:nil readTypes:readDataTypes completion:^(BOOL success, NSError *error) {
            if (!success) {
                NSLog(@"You didn't allow HealthKit to access these read data types. In your app, try to handle this error gracefully when a user decides not to provide access. The error was: %@. If you're using a simulator, try it on a device.", error);
                return;
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"The user allow the app to read information about StepCount");
            });
        }];
    }

    [self stepAllCount];
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

- (NSSet *)dataTypesToRead {
    HKQuantityType *stepType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount];
    return [NSSet setWithObjects:stepType, nil];
}

-(void)stepAllCount
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *interval = [[NSDateComponents alloc] init];
    interval.day = 1;
    
    stepCount = 0;
    NSDateComponents *anchorComponents = [calendar components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear
                                                     fromDate:[NSDate date]];
    anchorComponents.hour = 0;
    NSDate *anchorDate = [calendar dateFromComponents:anchorComponents];
    HKQuantityType *quantityType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount];
    
    HKStatisticsCollectionQuery *query =
    [[HKStatisticsCollectionQuery alloc] initWithQuantityType:quantityType
                                      quantitySamplePredicate:nil
                                                      options:HKStatisticsOptionCumulativeSum
                                                   anchorDate:anchorDate
                                           intervalComponents:interval];
    
    query.initialResultsHandler = ^(HKStatisticsCollectionQuery *query, HKStatisticsCollection *results, NSError *error) {
        if (error) {
            NSLog(@"*** An error occurred while calculating the statistics: %@ ***",error.localizedDescription);
        }
        
        NSCalendar *cal = [NSCalendar currentCalendar];
        NSDateComponents *components = [cal components:( NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond ) fromDate:[[NSDate alloc] init]];
        
        [components setHour:-[components hour]];
        [components setMinute:-[components minute]];
        [components setSecond:-[components second]];
        NSDate *today = [cal dateByAddingComponents:components toDate:[[NSDate alloc] init] options:NSCalendarMatchLast];
        
        NSDateComponents *component = [cal components:( NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond ) fromDate:[[NSDate alloc] init]];
        
        [component setHour:23];
        [component setMinute:59];
        [component setSecond:59];
        NSDate *todayEnd = [cal dateByAddingComponents:component toDate: today options:0];
        
        [results enumerateStatisticsFromDate:today toDate:todayEnd withBlock:^(HKStatistics *result, BOOL *stop) {
            HKQuantity *quantity = result.sumQuantity;
            
            if (quantity) {
                double value = [quantity doubleValueForUnit:[HKUnit countUnit]];
                stepCount = stepCount + value;
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                healthLabel.hidden = NO;
                healthLabel.text = [NSString stringWithFormat:@"你当前走了%@步",[NSNumberFormatter localizedStringFromNumber:@(stepCount) numberStyle:NSNumberFormatterNoStyle]];
                [flower stopAnimating];
                [flower setHidesWhenStopped:YES];
            });
        }];
    };
    [healthStore.healthStore executeQuery:query];
}

@end
