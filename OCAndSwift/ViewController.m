//
//  ViewController.m
//  OCAndSwift
//
//  Created by MYX on 2017/3/24.
//  Copyright © 2017年 邓杰豪. All rights reserved.
//

#import "ViewController.h"
#import "CBHistoryCollectionViewController.h"
#import "PAboutMeViewController.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *tbView;
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
    
}

-(NSArray *)titleArray
{
    return @[@"新开始",@"历史",@"关于我"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.title = @"主界面";
    
    tbView    = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    tbView.dataSource                     = self;
    tbView.delegate                       = self;
    tbView.showsHorizontalScrollIndicator = NO;
    tbView.showsVerticalScrollIndicator   = NO;
    tbView.separatorStyle                 = UITableViewCellSeparatorStyleSingleLine;
    [self.view addSubview:tbView];
    [tbView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self.view);
    }];
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
            
            CGFloat paddingY                   = 10;
            CGFloat paddingX                   = 5;
            
            CBHistoryCollectionViewController *hV = [[CBHistoryCollectionViewController alloc] initWithCollectionViewLayout:[CGLayout createLayoutItemW:(kSCREEN_WIDTH-20)/2 itemH:kSCREEN_WIDTH-20 sectionInset:UIEdgeInsetsMake(paddingY, paddingX, paddingY, paddingX) minimumLineSpacing:paddingX minimumInteritemSpacing:paddingX scrollDirection:UICollectionViewScrollDirectionVertical]];
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

@end
