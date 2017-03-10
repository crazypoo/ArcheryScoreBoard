//
//  PCalculatorViewController.m
//  Archery Score
//
//  Created by Staff on 2017/2/16.
//  Copyright © 2017年 邓杰豪. All rights reserved.
//

#import "PCalculatorViewController.h"

#import "PArcheryKeyBoard.h"
#import <DHSmartScreenshot/UIView+DHSmartScreenshot.h>
#import <YCXMenu/YCXMenu.h>

static NSString * const collectionReuseIdentifier = @"Cell";
static NSString *leftCellIdentifier = @"LEFTCELLS";
static NSString *rightCellIdentifier = @"RIGHTCELLS";
static NSString *arrowsCellIdentifier = @"ARROWSCELLS";

@interface PCalculatorViewController ()<UITableViewDelegate,UITableViewDataSource,PArcheryKeyBoardDelegate,UITextFieldDelegate>
{
    UITableView *leftTable;
    NSString *bowStr;
    NSString *targetStr;
    NSString *distanceStr;
    NSString *groupStr;
    NSString *arrowsStr;
    NSMutableArray *targetInfoStrArr;

    NSString *str0;
    NSString *str1;
    NSString *str2;
    NSString *str3;
    NSString *str4;
    NSString *str5;
    NSString *str6;
    NSString *str7;
    NSString *str8;
    NSString *str9;
    NSString *str10;
    NSString *str11;

    NSMutableArray *rightTableGroupArr;
    NSMutableArray *rightTableAllArr;

    UITableView *rightTable;

    int arrowsCount;
    NSUInteger tenCount;
    NSUInteger xCount;
    NSUInteger nineCount;
    NSUInteger eightCount;
    NSUInteger sevenCount;
    NSUInteger sixCount;
    NSUInteger fiveCount;
    NSUInteger fourCount;
    NSUInteger threeCount;
    NSUInteger twoCount;
    NSUInteger oneCount;
    NSUInteger mCount;

    int groupCount;

    int plusCount;

    UITableView *arrowsTable;
    NSMutableArray *arrowsCountArr;
    NSMutableArray *percentArr;
}
@end

@implementation PCalculatorViewController

-(instancetype)initWithBows:(NSString *)Bow target:(NSString *)Targets distance:(NSString *)Distance group:(NSString *)Group arrows:(NSString *)Arrows
{
    self = [super init];
    if (self) {
        bowStr = Bow;
        targetStr = Targets;
        distanceStr = Distance;
        groupStr = Group;
        arrowsStr = Arrows;

        arrowsCount = 0;
        xCount = 0;
        tenCount = 0;
        nineCount = 0;
        eightCount = 0;
        sevenCount = 0;
        sixCount = 0;
        fiveCount = 0;
        fourCount = 0;
        threeCount = 0;
        twoCount = 0;
        oneCount = 0;
        mCount = 0;
        groupCount = 0;
        plusCount = 0;

        targetInfoStrArr = [[NSMutableArray alloc] init];
        rightTableGroupArr = [[NSMutableArray alloc] initWithCapacity:[arrowsStr integerValue]];
        for (int i = 0; i < [arrowsStr intValue]; i++) {
            [rightTableGroupArr addObject:@"0"];
        }
        rightTableAllArr = [[NSMutableArray alloc] init];

        NSArray *targetArr = @[bowStr,targetStr,distanceStr,@"0",@"0",@"0",@"0",@"0",[NSString stringWithFormat:@"%d/%@",groupCount,groupStr]];
        [targetInfoStrArr addObjectsFromArray:targetArr];

        arrowsCountArr = [[NSMutableArray alloc] init];
        percentArr = [[NSMutableArray alloc] init];
        for (int i = 0; i < 12; i++) {
            [arrowsCountArr addObject:@"0"];
            [percentArr addObject:@"0"];
        }
    }
    return self;
}

-(NSArray *)leftArr
{
    return @[@"弓种:",@"靶型:",@"距离:",@"总分:",@"平均分:",@"X数:",@"10数:",@"箭数:",@"组数:"];
}

-(NSArray *)arrowsTableArr
{
    return @[@"X:",@"10:",@"9:",@"8:",@"7:",@"6:",@"5:",@"4:",@"3:",@"2:",@"1:",@"M"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self targetInfo];
    [self arrowsInfo];
    [self inputViews];


    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 50, 44);
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setTitle:@"保存" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(rightBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:btn]];
}

-(void)targetInfo
{
    UIView *left = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth/2, screenHeight-100-HEIGHT_NAVBAR)];
    left.backgroundColor = RandomColor;
    [self.view addSubview:left];

    leftTable    = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, left.width, left.height) style:UITableViewStylePlain];
    leftTable.dataSource                     = self;
    leftTable.delegate                       = self;
    leftTable.showsHorizontalScrollIndicator = NO;
    leftTable.showsVerticalScrollIndicator   = NO;
    leftTable.separatorStyle                 = UITableViewCellSeparatorStyleNone;
    leftTable.scrollEnabled = NO;
    [left addSubview:leftTable];
}

-(void)arrowsInfo
{
    UIView *right = [[UIView alloc] initWithFrame:CGRectMake(screenWidth/2, 0, screenWidth/2, screenHeight-100-HEIGHT_NAVBAR)];
    [self.view addSubview:right];

    rightTable    = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, right.width, right.height/2) style:UITableViewStylePlain];
    rightTable.dataSource                     = self;
    rightTable.delegate                       = self;
    rightTable.showsHorizontalScrollIndicator = NO;
    rightTable.showsVerticalScrollIndicator   = NO;
    rightTable.separatorStyle                 = UITableViewCellSeparatorStyleNone;
    rightTable.scrollEnabled = NO;
    rightTable.backgroundColor = [UIColor redColor];
    [right addSubview:rightTable];

    arrowsTable    = [[UITableView alloc] initWithFrame:CGRectMake(0, right.height/2, right.width, right.height/2) style:UITableViewStylePlain];
    arrowsTable.dataSource                     = self;
    arrowsTable.delegate                       = self;
    arrowsTable.showsHorizontalScrollIndicator = NO;
    arrowsTable.showsVerticalScrollIndicator   = NO;
    arrowsTable.separatorStyle                 = UITableViewCellSeparatorStyleNone;
    arrowsTable.scrollEnabled = NO;
    [right addSubview:arrowsTable];

}

-(void)inputViews
{
    UIView *inputView = [[UIView alloc] initWithFrame:CGRectMake(0, screenHeight-100-HEIGHT_NAVBAR, screenWidth, 100)];
    inputView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:inputView];

    for (int i = 0; i < [arrowsStr intValue]; i++) {

        PArcheryKeyBoard *keyboardLevel = [PArcheryKeyBoard pooArcheryKeyBoard];
        keyboardLevel.delegate = self;
        keyboardLevel.tag = i;

        UITextField *pFiled = [[UITextField alloc] initWithFrame:CGRectMake(inputView.width/[arrowsStr intValue]*i, 0, inputView.width/[arrowsStr intValue], inputView.height)];
        pFiled.backgroundColor = [UIColor whiteColor];
        pFiled.tag = i+100;
        pFiled.textAlignment = NSTextAlignmentCenter;
        pFiled.inputView = keyboardLevel;
        pFiled.delegate = self;
        [inputView addSubview:pFiled];
    }
    
    for (int i = 0; i < [arrowsStr intValue]-1; i++) {
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(inputView.width/[arrowsStr intValue]+inputView.width/[arrowsStr intValue]*i, 0, 1, inputView.height)];
        line.backgroundColor = [UIColor lightGrayColor];
        [inputView addSubview:line];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark ---------------> UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == leftTable) {
        return self.leftArr.count;
    }
    else if (tableView == rightTable)
    {
        return rightTableAllArr.count;
    }
    else if (tableView == arrowsTable)
    {
        return self.arrowsTableArr.count;
    }
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == leftTable) {
        return (screenHeight-100-HEIGHT_NAVBAR)/self.leftArr.count;
    }
    else if (tableView == rightTable)
    {
        return ((screenHeight-100-HEIGHT_NAVBAR)/2-20)/[groupStr intValue];
    }
    else if (tableView == arrowsTable)
    {
        return ((screenHeight-100-HEIGHT_NAVBAR)/2-20)/self.arrowsTableArr.count;
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView == arrowsTable || tableView == rightTable) {
        return 20;
    }
    return 0.00001;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (tableView == arrowsTable) {
        UILabel *titleL = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, screenWidth/2, 20)];
        titleL.textAlignment = NSTextAlignmentCenter;
        titleL.backgroundColor = [UIColor yellowColor];
        titleL.text = @"环数百分比";

        return titleL;
    }
    else if (tableView == rightTable)
    {
        UILabel *titleL = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, screenWidth/2, 20)];
        titleL.textAlignment = NSTextAlignmentCenter;
        titleL.backgroundColor = [UIColor redColor];
        titleL.text = @"环数段";

        return titleL;

    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == leftTable) {
        UITableViewCell *cell = nil;
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:leftCellIdentifier];
        }
        else
        {
            while ([cell.contentView.subviews lastObject] != nil) {
                [(UIView *)[cell.contentView.subviews lastObject] removeFromSuperview];
            }
        }
        cell.selectionStyle = UITableViewCellEditingStyleNone;

        UILabel *titleName = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, screenWidth/2/2, (screenHeight-100-HEIGHT_NAVBAR)/self.leftArr.count)];
        titleName.textColor = [UIColor whiteColor];
        titleName.text = self.leftArr[indexPath.row];
        [cell.contentView addSubview:titleName];

        UILabel *targetInfo = [[UILabel alloc] initWithFrame:CGRectMake(screenWidth/2/2, 0, screenWidth/2/2, (screenHeight-100-HEIGHT_NAVBAR)/self.leftArr.count)];
        targetInfo.textAlignment = NSTextAlignmentCenter;
        targetInfo.textColor = [UIColor whiteColor];
        targetInfo.text = targetInfoStrArr[indexPath.row];
        [cell.contentView addSubview:targetInfo];

        cell.backgroundColor = PRGBAColor(0, 149, 227,1);

        return cell;

    }
    else if (tableView == rightTable) {
        UITableViewCell *cell = nil;
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:rightCellIdentifier];
        }
        else
        {
            while ([cell.contentView.subviews lastObject] != nil) {
                [(UIView *)[cell.contentView.subviews lastObject] removeFromSuperview];
            }
        }
        cell.selectionStyle = UITableViewCellEditingStyleNone;

        cell.backgroundColor = [UIColor redColor];

        cell.textLabel.font = DEFAULT_FONT(FontName,18);
        cell.textLabel.numberOfLines = 0;
        cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
        cell.textLabel.text = [NSString stringWithFormat:@"第%ld组:%@",indexPath.row+1,rightTableAllArr[indexPath.row]];
        cell.textLabel.textColor = [UIColor blackColor];


        return cell;
    }
    else if (tableView == arrowsTable) {
        UITableViewCell *cell = nil;
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:arrowsCellIdentifier];
        }
        else
        {
            while ([cell.contentView.subviews lastObject] != nil) {
                [(UIView *)[cell.contentView.subviews lastObject] removeFromSuperview];
            }
        }
        cell.selectionStyle = UITableViewCellEditingStyleNone;
        cell.backgroundColor = [UIColor yellowColor];

        for (int i = 0; i < 3; i++) {
            UILabel *infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(screenWidth/2/3*i, 0, screenWidth/2/3, ((screenHeight-100-HEIGHT_NAVBAR)/2-20)/self.arrowsTableArr.count)];
            infoLabel.font = DEFAULT_FONT(FontName,((screenHeight-100-HEIGHT_NAVBAR)/2-20)/self.arrowsTableArr.count);
            infoLabel.numberOfLines = 0;
            infoLabel.lineBreakMode = NSLineBreakByWordWrapping;
            infoLabel.tag = i;
            [cell.contentView addSubview:infoLabel];
            switch (infoLabel.tag) {
                case 0:
                {
                    infoLabel.textAlignment = NSTextAlignmentLeft;
                    infoLabel.text = self.arrowsTableArr[indexPath.row];
                }
                    break;
                case 1:
                {
                    infoLabel.textAlignment = NSTextAlignmentCenter;
                    infoLabel.text = arrowsCountArr[indexPath.row];
                }
                    break;
                case 2:
                {
                    infoLabel.textAlignment = NSTextAlignmentRight;
                    infoLabel.text = [NSString stringWithFormat:@"%@%%",percentArr[indexPath.row]];
                }
                    break;
                default:
                    break;
            }
        }
        return cell;
    }
    return nil;
}

#pragma mark ---------------> UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

#pragma mark ---------------> 按钮
-(void)menuAction:(YCXMenuItem *)sender
{
    switch (sender.tag) {
        case 1000:
        {
            if (groupCount != [groupStr intValue])
            {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"该数据还没录入完毕,确定保存到历史记录?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                alertView.tag = 999;
                [alertView show];
            }
            else
            {
                NSString *plistPath = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/History/%@.png",[self createCurrentTime]]];

                UIImage *imgeee = [self.view screenshot];
                NSData *myData = UIImagePNGRepresentation(imgeee);

                [myData writeToFile:plistPath atomically:YES];
                [self.navigationController popToRootViewControllerAnimated:YES];
                [Utils alertShowWithMessage:@"保存成功"];
            }
        }
            break;
        case 1001:
        {
            if (groupCount != [groupStr intValue])
            {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"该数据还没录入完毕,确定清空?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                alertView.tag = 998;
                [alertView show];
            }
            else
            {
                [self resetData];
            }
        }
            break;
        default:
            break;
    }
}

-(void)rightBtnAction:(UIButton *)sender
{
    YCXMenuItem *saveBtn = [YCXMenuItem menuItem:@"保存" image:nil target:self action:@selector(menuAction:)];
    saveBtn.foreColor = [UIColor whiteColor];
    saveBtn.alignment = NSTextAlignmentCenter;
    saveBtn.tag = 1000;

    YCXMenuItem *clearBtn = [YCXMenuItem menuItem:@"清空当前数据" image:nil target:self action:@selector(menuAction:)];
    clearBtn.foreColor = [UIColor whiteColor];
    clearBtn.alignment = NSTextAlignmentCenter;
    clearBtn.tag = 1001;

    NSArray *items = @[
                       saveBtn,
                       clearBtn
                       ];

    [YCXMenu showMenuInView:self.navigationController.view fromRect:sender.frame menuItems:items selected:^(NSInteger index, YCXMenuItem *item) {
    }];
}

#pragma mark ---------------> PooNumberKeyBoardDelegate
-(void)archeryberKeyboard:(PArcheryKeyBoard *)keyboard input:(NSString *)number
{
    switch (keyboard.tag) {
        case 0:
        {
            UITextField *text = (UITextField *)[self.view viewWithTag:keyboard.tag+100];
            text.text = [text.text stringByAppendingString:number];
            str0 = text.text;
            if ([rightTableGroupArr[0] isEqualToString:@"0"]) {
                [rightTableGroupArr replaceObjectAtIndex:0 withObject:str0];
            }
        }
            break;
        case 1:
        {
            UITextField *text = (UITextField *)[self.view viewWithTag:keyboard.tag+100];
            text.text = [text.text stringByAppendingString:number];
            str1 = text.text;
            if ([rightTableGroupArr[1] isEqualToString:@"0"]) {
                [rightTableGroupArr replaceObjectAtIndex:1 withObject:str1];
            }
        }
            break;
        case 2:
        {
            UITextField *text = (UITextField *)[self.view viewWithTag:keyboard.tag+100];
            text.text = [text.text stringByAppendingString:number];
            str2 = text.text;
            if ([rightTableGroupArr[2] isEqualToString:@"0"]) {
                [rightTableGroupArr replaceObjectAtIndex:2 withObject:str2];
            }
        }
            break;
        case 3:
        {
            UITextField *text = (UITextField *)[self.view viewWithTag:keyboard.tag+100];
            text.text = [text.text stringByAppendingString:number];
            str3 = text.text;
            if ([rightTableGroupArr[3] isEqualToString:@"0"]) {
                [rightTableGroupArr replaceObjectAtIndex:3 withObject:str3];
            }
        }
            break;
        case 4:
        {
            UITextField *text = (UITextField *)[self.view viewWithTag:keyboard.tag+100];
            text.text = [text.text stringByAppendingString:number];
            str4 = text.text;
            if ([rightTableGroupArr[4] isEqualToString:@"0"]) {
                [rightTableGroupArr replaceObjectAtIndex:4 withObject:str4];
            }
        }
            break;
        case 5:
        {
            UITextField *text = (UITextField *)[self.view viewWithTag:keyboard.tag+100];
            text.text = [text.text stringByAppendingString:number];
            str5 = text.text;
            if ([rightTableGroupArr[5] isEqualToString:@"0"]) {
                [rightTableGroupArr replaceObjectAtIndex:5 withObject:str5];
            }
        }
            break;
        case 6:
        {
            UITextField *text = (UITextField *)[self.view viewWithTag:keyboard.tag+100];
            text.text = [text.text stringByAppendingString:number];
            str6 = text.text;
            if ([rightTableGroupArr[6] isEqualToString:@"0"]) {
                [rightTableGroupArr replaceObjectAtIndex:6 withObject:str6];
            }
        }
            break;
        case 7:
        {
            UITextField *text = (UITextField *)[self.view viewWithTag:keyboard.tag+100];
            text.text = [text.text stringByAppendingString:number];
            str7 = text.text;
            if ([rightTableGroupArr[7] isEqualToString:@"0"]) {
                [rightTableGroupArr replaceObjectAtIndex:7 withObject:str7];
            }
        }
            break;
        case 8:
        {
            UITextField *text = (UITextField *)[self.view viewWithTag:keyboard.tag+100];
            text.text = [text.text stringByAppendingString:number];
            str8 = text.text;
            if ([rightTableGroupArr[8] isEqualToString:@"0"]) {
                [rightTableGroupArr replaceObjectAtIndex:8 withObject:str8];
            }
        }
            break;
        case 9:
        {
            UITextField *text = (UITextField *)[self.view viewWithTag:keyboard.tag+100];
            text.text = [text.text stringByAppendingString:number];
            str9 = text.text;
            if ([rightTableGroupArr[9] isEqualToString:@"0"]) {
                [rightTableGroupArr replaceObjectAtIndex:9 withObject:str9];
            }
        }
            break;
        case 10:
        {
            UITextField *text = (UITextField *)[self.view viewWithTag:keyboard.tag+100];
            text.text = [text.text stringByAppendingString:number];
            str10 = text.text;
            if ([rightTableGroupArr[10] isEqualToString:@"0"]) {
                [rightTableGroupArr replaceObjectAtIndex:10 withObject:str10];
            }
        }
            break;
        case 11:
        {
            UITextField *text = (UITextField *)[self.view viewWithTag:keyboard.tag+100];
            text.text = [text.text stringByAppendingString:number];
            str11 = text.text;
            if ([rightTableGroupArr[11] isEqualToString:@"0"]) {
                [rightTableGroupArr replaceObjectAtIndex:11 withObject:str11];
            }
        }
            break;
        default:
            break;
    }
}

-(void)archeryKeyboardBackspace:(PArcheryKeyBoard *)keyboard
{
    UITextField *text = (UITextField *)[self.view viewWithTag:keyboard.tag+100];
    if (text.text.length != 0)
    {
        text.text = [text.text substringToIndex:text.text.length -1];
        if ([text.text isEqualToString:@""]) {
            [rightTableGroupArr replaceObjectAtIndex:keyboard.tag withObject:@"0"];
        }
        else
        {
            [rightTableGroupArr replaceObjectAtIndex:keyboard.tag withObject:text.text];
        }
    }
}

-(void)archeryKeyboadrDone:(PArcheryKeyBoard *)keyboard
{
    NSArray *arr = [[NSArray alloc] initWithArray:rightTableGroupArr];
    NSString *rightTableRowStr = [arr componentsJoinedByString:@","];

    for (int i = 0; i < [arrowsStr integerValue]; i++) {
        UITextField *text = (UITextField *)[self.view viewWithTag:i+100];
        text.text = @"";
        [text resignFirstResponder];
    }

    NSMutableArray *tenData = [[NSMutableArray alloc] init];
    NSMutableArray *xData = [[NSMutableArray alloc] init];
    NSMutableArray *nineData = [[NSMutableArray alloc] init];
    NSMutableArray *eightData = [[NSMutableArray alloc] init];
    NSMutableArray *sevenData = [[NSMutableArray alloc] init];
    NSMutableArray *sixData = [[NSMutableArray alloc] init];
    NSMutableArray *fiveData = [[NSMutableArray alloc] init];
    NSMutableArray *fourData = [[NSMutableArray alloc] init];
    NSMutableArray *threeData = [[NSMutableArray alloc] init];
    NSMutableArray *twoData = [[NSMutableArray alloc] init];
    NSMutableArray *oneData = [[NSMutableArray alloc] init];
    NSMutableArray *zeroData = [[NSMutableArray alloc] init];

    for (NSString *string in rightTableGroupArr) {
        if ([string isEqualToString:@"X"]) {
            [xData addObject:string];
        }
        else if ([string isEqualToString:@"10"]) {
            [tenData addObject:string];
        }
        else if ([string isEqualToString:@"9"])
        {
            [nineData addObject:string];
        }
        else if ([string isEqualToString:@"8"])
        {
            [eightData addObject:string];
        }
        else if ([string isEqualToString:@"7"])
        {
            [sevenData addObject:string];
        }
        else if ([string isEqualToString:@"6"])
        {
            [sixData addObject:string];
        }
        else if ([string isEqualToString:@"5"])
        {
            [fiveData addObject:string];
        }
        else if ([string isEqualToString:@"4"])
        {
            [fourData addObject:string];
        }
        else if ([string isEqualToString:@"3"])
        {
            [threeData addObject:string];
        }
        else if ([string isEqualToString:@"2"])
        {
            [twoData addObject:string];
        }
        else if ([string isEqualToString:@"1"])
        {
            [oneData addObject:string];
        }
        else if ([string isEqualToString:@"M"])
        {
            [zeroData addObject:string];
        }
        else
        {
            [Utils alertShowWithMessage:@"请输入正确的分数"];
            return;
        }
    }

    arrowsCount = arrowsCount + [arrowsStr intValue];
    xCount = xCount + xData.count;
    tenCount = tenCount + tenData.count;
    nineCount = nineCount + nineData.count;
    eightCount = eightCount + eightData.count;
    sevenCount = sevenCount + sevenData.count;
    sixCount = sixCount + sixData.count;
    fiveCount = fiveCount + fiveData.count;
    fourCount = fourCount + fourData.count;
    threeCount = threeCount + threeData.count;
    twoCount = twoCount + twoData.count;
    oneCount = oneCount + oneData.count;
    mCount = mCount + zeroData.count;
    groupCount ++;

    [arrowsCountArr replaceObjectAtIndex:0 withObject:[NSString stringWithFormat:@"%lu",(unsigned long)xCount]];
    [arrowsCountArr replaceObjectAtIndex:1 withObject:[NSString stringWithFormat:@"%lu",(unsigned long)tenCount]];
    [arrowsCountArr replaceObjectAtIndex:2 withObject:[NSString stringWithFormat:@"%lu",(unsigned long)nineCount]];
    [arrowsCountArr replaceObjectAtIndex:3 withObject:[NSString stringWithFormat:@"%lu",(unsigned long)eightCount]];
    [arrowsCountArr replaceObjectAtIndex:4 withObject:[NSString stringWithFormat:@"%lu",(unsigned long)sevenCount]];
    [arrowsCountArr replaceObjectAtIndex:5 withObject:[NSString stringWithFormat:@"%lu",(unsigned long)sixCount]];
    [arrowsCountArr replaceObjectAtIndex:6 withObject:[NSString stringWithFormat:@"%lu",(unsigned long)fiveCount]];
    [arrowsCountArr replaceObjectAtIndex:7 withObject:[NSString stringWithFormat:@"%lu",(unsigned long)fourCount]];
    [arrowsCountArr replaceObjectAtIndex:8 withObject:[NSString stringWithFormat:@"%lu",(unsigned long)threeCount]];
    [arrowsCountArr replaceObjectAtIndex:9 withObject:[NSString stringWithFormat:@"%lu",(unsigned long)twoCount]];
    [arrowsCountArr replaceObjectAtIndex:10 withObject:[NSString stringWithFormat:@"%lu",(unsigned long)oneCount]];
    [arrowsCountArr replaceObjectAtIndex:11 withObject:[NSString stringWithFormat:@"%lu",(unsigned long)mCount]];

    [percentArr replaceObjectAtIndex:0 withObject:[NSString stringWithFormat:@"%.2f",[[NSString stringWithFormat:@"%lu",(unsigned long)xCount] floatValue]/[[NSString stringWithFormat:@"%d",arrowsCount] floatValue]*100]];
    [percentArr replaceObjectAtIndex:1 withObject:[NSString stringWithFormat:@"%.2f",[[NSString stringWithFormat:@"%lu",(unsigned long)tenCount] floatValue]/[[NSString stringWithFormat:@"%d",arrowsCount] floatValue]*100]];
    [percentArr replaceObjectAtIndex:2 withObject:[NSString stringWithFormat:@"%.2f",[[NSString stringWithFormat:@"%lu",(unsigned long)nineCount] floatValue]/[[NSString stringWithFormat:@"%d",arrowsCount] floatValue]*100]];
    [percentArr replaceObjectAtIndex:3 withObject:[NSString stringWithFormat:@"%.2f",[[NSString stringWithFormat:@"%lu",(unsigned long)eightCount] floatValue]/[[NSString stringWithFormat:@"%d",arrowsCount] floatValue]*100]];
    [percentArr replaceObjectAtIndex:4 withObject:[NSString stringWithFormat:@"%.2f",[[NSString stringWithFormat:@"%lu",(unsigned long)sevenCount] floatValue]/[[NSString stringWithFormat:@"%d",arrowsCount] floatValue]*100]];
    [percentArr replaceObjectAtIndex:5 withObject:[NSString stringWithFormat:@"%.2f",[[NSString stringWithFormat:@"%lu",(unsigned long)sixCount] floatValue]/[[NSString stringWithFormat:@"%d",arrowsCount] floatValue]*100]];
    [percentArr replaceObjectAtIndex:6 withObject:[NSString stringWithFormat:@"%.2f",[[NSString stringWithFormat:@"%lu",(unsigned long)fiveCount] floatValue]/[[NSString stringWithFormat:@"%d",arrowsCount] floatValue]*100]];
    [percentArr replaceObjectAtIndex:7 withObject:[NSString stringWithFormat:@"%.2f",[[NSString stringWithFormat:@"%lu",(unsigned long)fourCount] floatValue]/[[NSString stringWithFormat:@"%d",arrowsCount] floatValue]*100]];
    [percentArr replaceObjectAtIndex:8 withObject:[NSString stringWithFormat:@"%.2f",[[NSString stringWithFormat:@"%lu",(unsigned long)threeCount] floatValue]/[[NSString stringWithFormat:@"%d",arrowsCount] floatValue]*100]];
    [percentArr replaceObjectAtIndex:9 withObject:[NSString stringWithFormat:@"%.2f",[[NSString stringWithFormat:@"%lu",(unsigned long)twoCount] floatValue]/[[NSString stringWithFormat:@"%d",arrowsCount] floatValue]*100]];
    [percentArr replaceObjectAtIndex:10 withObject:[NSString stringWithFormat:@"%.2f",[[NSString stringWithFormat:@"%lu",(unsigned long)oneCount] floatValue]/[[NSString stringWithFormat:@"%d",arrowsCount] floatValue]*100]];
    [percentArr replaceObjectAtIndex:11 withObject:[NSString stringWithFormat:@"%.2f",[[NSString stringWithFormat:@"%lu",(unsigned long)mCount] floatValue]/[[NSString stringWithFormat:@"%d",arrowsCount] floatValue]*100]];

    for (int i = 0; i < rightTableGroupArr.count; i++) {
        NSString *string = rightTableGroupArr[i];
        if ([string isEqualToString:@"X"]) {
            [rightTableGroupArr replaceObjectAtIndex:i withObject:@"10"];
        }
        else if ([string isEqualToString:@"M"]) {
            [rightTableGroupArr replaceObjectAtIndex:i withObject:@"0"];
        }
    }

    for (NSString *string in rightTableGroupArr) {
        plusCount = plusCount +[string intValue];
    }

    [targetInfoStrArr replaceObjectAtIndex:3 withObject:[NSString stringWithFormat:@"%d",plusCount]];
    [targetInfoStrArr replaceObjectAtIndex:4 withObject:[NSString stringWithFormat:@"%.3f",[[NSString stringWithFormat:@"%d",plusCount] floatValue]/[[NSString stringWithFormat:@"%d",arrowsCount] floatValue]]];
    [targetInfoStrArr replaceObjectAtIndex:5 withObject:[NSString stringWithFormat:@"%lu",(unsigned long)xCount]];
    [targetInfoStrArr replaceObjectAtIndex:6 withObject:[NSString stringWithFormat:@"%lu",(unsigned long)tenCount]];
    [targetInfoStrArr replaceObjectAtIndex:7 withObject:[NSString stringWithFormat:@"%d",arrowsCount]];
    [targetInfoStrArr replaceObjectAtIndex:8 withObject:[NSString stringWithFormat:@"%d/%@",groupCount,groupStr]];
    [leftTable reloadData];
    [arrowsTable reloadData];

    [rightTableAllArr addObject:rightTableRowStr];
    [rightTableGroupArr removeAllObjects];
    for (int i = 0; i < [arrowsStr intValue]; i++) {
        [rightTableGroupArr addObject:@"0"];
    }
    [rightTable reloadData];
}

#pragma mark ---------------> UITextFieldDelegate

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (groupCount == [groupStr intValue])
    {
        [Utils alertShowWithMessage:@"这次记录录入完毕"];
        return NO;
    }
    return YES;
}

//- (void)textFieldDidChange:(UITextField *)textField
//{
//    if ([textField.text isEqualToString:@"10"]) {
//        if (textField.text.length > 1)
//        {
//            textField.text = [textField.text substringToIndex:2];
//        }
//    }
//    else
//    {
//        if (textField.text.length > 0)
//        {
//            textField.text = [textField.text substringToIndex:1];
//        }
//    }
//}

//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;
//{
//    switch (textField.tag) {
//        case 0:
//        {
//            NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
//            if ([textField.text isEqualToString:@"10"]) {
//                if ([toBeString length] > 1)
//                {
//                    textField.text = [toBeString substringToIndex:2];
//                    return NO;
//                }
//            }
//            else
//            {
//                if ([toBeString length] > 0)
//                {
//                    textField.text = [toBeString substringToIndex:1];
//                    return NO;
//                }
//                
//            }
//        }
//            break;
//            
//        default:
//            break;
//    }
//    return YES;
//}

#pragma mark ---------------> UIAlertView
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (alertView.tag) {
        case 998:
        {
            switch (buttonIndex) {
                case 0:
                {
                }
                    break;
                case 1:
                {
                    [self resetData];
                }
                    break;
                default:
                    break;
            }
        }
            break;
        case 999:
        {
            switch (buttonIndex) {
                    case 0:
                {
                }
                    break;
                    case 1:
                {
                    NSString *plistPath = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/History/%@.png",[self createCurrentTime]]];
                    
                    UIImage *imgeee = [self.view screenshot];
                    NSData *myData = UIImagePNGRepresentation(imgeee);
                    
                    if ([myData writeToFile:plistPath atomically:YES]) {
                        [Utils alertShowWithMessage:@"保存成功"];
                        [self.navigationController popToRootViewControllerAnimated:YES];
                    }
                    else
                    {
                        [Utils alertShowWithMessage:@"保存失败"];
                    }
                    
                    
                }
                    break;
                default:
                    break;
            }
            
        }
            break;
        default:
            break;
    }
}

#pragma mark ---------------> RESETDATA
-(void)resetData
{
    arrowsCount = 0;
    tenCount = 0;
    xCount = 0;
    groupCount = 0;
    plusCount = 0;

    [targetInfoStrArr removeAllObjects];
    NSArray *targetArr = @[bowStr,targetStr,distanceStr,@"0",@"0",@"0",@"0",@"0",[NSString stringWithFormat:@"%d/%@",groupCount,groupStr]];
    [targetInfoStrArr addObjectsFromArray:targetArr];

    [rightTableGroupArr removeAllObjects];
    [rightTableAllArr removeAllObjects];

    [rightTable reloadData];
    [leftTable reloadData];
}

#pragma mark ---------------> 获取当前时间
-(NSString *)createCurrentTime
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:[NSString stringWithFormat:@"%@", @"yyyy-MM-dd HH:MM:ss"]];
    NSString *currentDate = [dateFormatter stringFromDate:[NSDate date]];
    return currentDate;
}
@end
