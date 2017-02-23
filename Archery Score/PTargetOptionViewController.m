//
//  PTargetOptionViewController.m
//  Archery Score
//
//  Created by Staff on 2017/2/14.
//  Copyright © 2017年 邓杰豪. All rights reserved.
//

#pragma mark VC Import
#import "PTargetOptionViewController.h"
#import "PCalculatorViewController.h"

#pragma mark Tools Import
#import "PooSegView.h"

@interface PTargetOptionViewController ()<UITableViewDataSource,UITableViewDelegate,PooSegViewDelegate,UIPickerViewDelegate,UIPickerViewDataSource>
{
    UITableView *tbView;
    UITextField *nameText;

    UIView *distanceBackground;
    NSString *distanceStr;
    UIButton *distanceBtn;

    UIButton *sizeBtn;
    UIView *sizeBackground;
    NSString *sizeStr;

    UIButton *groupBtn;
    UIView *groupBackground;
    NSString *groupStr;

    UIButton *numberBtn;
    UIView *numberBackground;
    NSString *numberStr;

    NSString *bowStr;

    UIButton *next;
}
@end

@implementation PTargetOptionViewController

-(NSArray *)titleArr
{
    return @[@"名称",@"弓种",@"距离",@"靶纸类型",@"几多组",@"每组多少支"];
}

-(NSArray *)distanceArr
{
    return @[@"10米",@"18米",@"20米",@"30米",@"50米",@"70米",@"90米",@"110米"];
}

-(NSArray *)targetSizeArr
{
    return @[@"122全环靶",@"80全环靶",@"80半环靶",@"60全环靶",@"40全环靶",@"40半环靶"];
}

-(NSArray *)groupArr
{
    return @[@"3",@"5",@"6",@"10",@"12"];
}

-(NSArray *)numberOfGroupArr
{
    return @[@"3",@"6",@"12"];
}

-(NSArray *)bowsArr
{
    return @[@"反曲",@"复合",@"馆弓",@"美猎",@"光弓",@"传统"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    tbView    = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight-HEIGHT_NAVBAR) style:UITableViewStylePlain];
    tbView.dataSource                     = self;
    tbView.delegate                       = self;
    tbView.showsHorizontalScrollIndicator = NO;
    tbView.showsVerticalScrollIndicator   = NO;
    tbView.separatorStyle                 = UITableViewCellSeparatorStyleSingleLine;
    [self.view addSubview:tbView];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark ---------------> UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.titleArr.count;
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

    switch (indexPath.section) {
        case 0:
        {
            NSDate *currentDate = [NSDate date];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"YYYY/MM/dd hh:mm"];
            NSString *dateString = [dateFormatter stringFromDate:currentDate];

            nameText = [[UITextField alloc] initWithFrame:CGRectMake(5, 5, screenWidth-10, 50)];
            nameText.text = dateString;
            nameText.clearButtonMode = UITextFieldViewModeWhileEditing;
            [cell.contentView addSubview:nameText];
        }
            break;
            case 1:
        {
            PooSegView *seg = [[PooSegView alloc] initWithFrame:CGRectMake(5, 5, screenWidth-10, 40) titles:self.bowsArr titleNormalColor:[UIColor lightGrayColor] titleSelectedColor:PRGBAColor(0, 149, 227,1) titleFont:DEFAULT_FONT(FontName, 18) setLine:YES lineColor:nil lineWidth:1];
            seg.delegate = self;
            [cell.contentView addSubview:seg];
        }
            break;
            case 2:
        {
            distanceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            distanceBtn.frame = CGRectMake(5, 5, screenWidth-10, 40);
            distanceBtn.backgroundColor = PRGBAColor(0, 149, 227,1);
            [distanceBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [distanceBtn setTitle:@"选择" forState:UIControlStateNormal];
            [distanceBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:distanceBtn];
            distanceBtn.tag = indexPath.section;

        }
            break;
        case 3:
        {
            sizeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            sizeBtn.frame = CGRectMake(5, 5, screenWidth-10, 40);
            sizeBtn.backgroundColor = PRGBAColor(0, 149, 227,1);
            [sizeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [sizeBtn setTitle:@"选择" forState:UIControlStateNormal];
            [sizeBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:sizeBtn];
            sizeBtn.tag = indexPath.section;
        }
            break;
        case 4:
        {
            groupBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            groupBtn.frame = CGRectMake(5, 5, screenWidth-10, 40);
            groupBtn.backgroundColor = PRGBAColor(0, 149, 227,1);
            [groupBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [groupBtn setTitle:@"选择" forState:UIControlStateNormal];
            [groupBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:groupBtn];
            groupBtn.tag = indexPath.section;

        }
            break;
        case 5:
        {
            numberBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            numberBtn.frame = CGRectMake(5, 5, screenWidth-10, 40);
            numberBtn.backgroundColor = PRGBAColor(0, 149, 227,1);
            [numberBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [numberBtn setTitle:@"选择" forState:UIControlStateNormal];
            [numberBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:numberBtn];
            numberBtn.tag = indexPath.section;

        }
            break;
        default:
            break;
    }

    return cell;
}

#pragma mark ---------------> UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 5) {
        return 50;
    }
    return 0.000001;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    switch (section) {
        case 5:
        {
            UIView *fView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 50)];

            next = [UIButton buttonWithType:UIButtonTypeCustom];
            next.frame = CGRectMake(5, 5, screenWidth-10, 40);
            next.backgroundColor = [UIColor lightGrayColor];
            [next setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [next setTitle:@"确定" forState:UIControlStateNormal];
            next.userInteractionEnabled = NO;
            [next addTarget:self action:@selector(nextStep:) forControlEvents:UIControlEventTouchUpInside];
            [fView addSubview:next];

            return fView;

        }
            break;

        default:
            break;
    }
    return nil;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *hView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 50)];
    hView.backgroundColor = [UIColor purpleColor];

    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 50)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = self.titleArr[section];
    [hView addSubview:titleLabel];

    return hView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark ---------------> 按钮
-(void)nextStep:(UIButton *)sender
{
    PCalculatorViewController *vc = [[PCalculatorViewController alloc] initWithBows:bowStr target:sizeStr distance:distanceStr group:groupStr arrows:numberStr];
    vc.title = nameText.text;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)buttonAction:(UIButton *)sender
{
    switch (sender.tag) {
        case 0:
        {
        }
            break;
        case 1:
        {
        }
            break;
            case 2:
        {
            [nameText resignFirstResponder];

            UIView *tbar_picker                = [[UIView alloc] init];
            UIButton *doneBtn                  = [UIButton buttonWithType:UIButtonTypeCustom];

            distanceBackground                    = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
            UIPickerView *groupPicker          = [[UIPickerView alloc] initWithFrame:CGRectMake(0, screenHeight-216, screenWidth, 216)];
            tbar_picker.frame                  = CGRectMake(0, screenHeight-216-44, screenWidth, 44);
            doneBtn.frame                      = CGRectMake(screenWidth-60, 0, 50, 44);
            distanceBackground.backgroundColor    = [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.5];
            [[AppDelegate appDelegate].window addSubview:distanceBackground];

            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapView:)];
            tapGesture.numberOfTapsRequired    = 1;
            [distanceBackground addGestureRecognizer:tapGesture];

            groupPicker.dataSource             = self;
            groupPicker.delegate               = self;
            groupPicker.backgroundColor        = [UIColor whiteColor];
            groupPicker.tag                    = sender.tag;
            [distanceBackground addSubview:groupPicker];

            tbar_picker.backgroundColor        = PRGBAColor(0, 149, 227,1);
            [distanceBackground addSubview:tbar_picker];

            UIButton *cancelBtn                = [UIButton buttonWithType:UIButtonTypeCustom];
            cancelBtn.frame                    = CGRectMake(10, 0, 50, 44);
            cancelBtn.titleLabel.font = DEFAULT_FONT(FontName,18);
            [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
            [cancelBtn addTarget:self action:@selector(tapView:) forControlEvents:UIControlEventTouchUpInside];
            [tbar_picker addSubview:cancelBtn];

            doneBtn.titleLabel.font = DEFAULT_FONT(FontName,18);
            [doneBtn setTitle:@"完成" forState:UIControlStateNormal];
            [doneBtn addTarget:self action:@selector(pickerDone:) forControlEvents:UIControlEventTouchUpInside];
            [tbar_picker addSubview:doneBtn];
            doneBtn.tag = sender.tag;
        }
            break;
        case 3:
        {
            [nameText resignFirstResponder];

            UIView *tbar_picker                = [[UIView alloc] init];
            UIButton *doneBtn                  = [UIButton buttonWithType:UIButtonTypeCustom];

            sizeBackground                    = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
            UIPickerView *groupPicker          = [[UIPickerView alloc] initWithFrame:CGRectMake(0, screenHeight-216, screenWidth, 216)];
            tbar_picker.frame                  = CGRectMake(0, screenHeight-216-44, screenWidth, 44);
            doneBtn.frame                      = CGRectMake(screenWidth-60, 0, 50, 44);
            sizeBackground.backgroundColor    = [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.5];
            [[AppDelegate appDelegate].window addSubview:sizeBackground];

            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapView:)];
            tapGesture.numberOfTapsRequired    = 1;
            [sizeBackground addGestureRecognizer:tapGesture];

            groupPicker.dataSource             = self;
            groupPicker.delegate               = self;
            groupPicker.backgroundColor        = [UIColor whiteColor];
            groupPicker.tag                    = sender.tag;
            [sizeBackground addSubview:groupPicker];

            tbar_picker.backgroundColor        = PRGBAColor(0, 149, 227,1);
            [sizeBackground addSubview:tbar_picker];

            UIButton *cancelBtn                = [UIButton buttonWithType:UIButtonTypeCustom];
            cancelBtn.frame                    = CGRectMake(10, 0, 50, 44);
            cancelBtn.titleLabel.font = DEFAULT_FONT(FontName,18);
            [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
            [cancelBtn addTarget:self action:@selector(tapView:) forControlEvents:UIControlEventTouchUpInside];
            [tbar_picker addSubview:cancelBtn];

            doneBtn.titleLabel.font = DEFAULT_FONT(FontName,18);
            [doneBtn setTitle:@"完成" forState:UIControlStateNormal];
            [doneBtn addTarget:self action:@selector(pickerDone:) forControlEvents:UIControlEventTouchUpInside];
            [tbar_picker addSubview:doneBtn];
            doneBtn.tag = sender.tag;
        }
            break;
        case 4:
        {
            [nameText resignFirstResponder];

            UIView *tbar_picker                = [[UIView alloc] init];
            UIButton *doneBtn                  = [UIButton buttonWithType:UIButtonTypeCustom];

            groupBackground                    = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
            UIPickerView *groupPicker          = [[UIPickerView alloc] initWithFrame:CGRectMake(0, screenHeight-216, screenWidth, 216)];
            tbar_picker.frame                  = CGRectMake(0, screenHeight-216-44, screenWidth, 44);
            doneBtn.frame                      = CGRectMake(screenWidth-60, 0, 50, 44);
            groupBackground.backgroundColor    = [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.5];
            [[AppDelegate appDelegate].window addSubview:groupBackground];

            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapView:)];
            tapGesture.numberOfTapsRequired    = 1;
            [groupBackground addGestureRecognizer:tapGesture];

            groupPicker.dataSource             = self;
            groupPicker.delegate               = self;
            groupPicker.backgroundColor        = [UIColor whiteColor];
            groupPicker.tag                    = sender.tag;
            [groupBackground addSubview:groupPicker];

            tbar_picker.backgroundColor        = PRGBAColor(0, 149, 227,1);
            [groupBackground addSubview:tbar_picker];

            UIButton *cancelBtn                = [UIButton buttonWithType:UIButtonTypeCustom];
            cancelBtn.frame                    = CGRectMake(10, 0, 50, 44);
            cancelBtn.titleLabel.font = DEFAULT_FONT(FontName,18);
            [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
            [cancelBtn addTarget:self action:@selector(tapView:) forControlEvents:UIControlEventTouchUpInside];
            [tbar_picker addSubview:cancelBtn];

            doneBtn.titleLabel.font = DEFAULT_FONT(FontName,18);
            [doneBtn setTitle:@"完成" forState:UIControlStateNormal];
            [doneBtn addTarget:self action:@selector(pickerDone:) forControlEvents:UIControlEventTouchUpInside];
            [tbar_picker addSubview:doneBtn];
            doneBtn.tag = sender.tag;
        }
            break;
        case 5:
        {
            [nameText resignFirstResponder];

            UIView *tbar_picker                = [[UIView alloc] init];
            UIButton *doneBtn                  = [UIButton buttonWithType:UIButtonTypeCustom];

            numberBackground                    = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
            UIPickerView *groupPicker          = [[UIPickerView alloc] initWithFrame:CGRectMake(0, screenHeight-216, screenWidth, 216)];
            tbar_picker.frame                  = CGRectMake(0, screenHeight-216-44, screenWidth, 44);
            doneBtn.frame                      = CGRectMake(screenWidth-60, 0, 50, 44);
            numberBackground.backgroundColor    = [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.5];
            [[AppDelegate appDelegate].window addSubview:numberBackground];

            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapView:)];
            tapGesture.numberOfTapsRequired    = 1;
            [numberBackground addGestureRecognizer:tapGesture];

            groupPicker.dataSource             = self;
            groupPicker.delegate               = self;
            groupPicker.backgroundColor        = [UIColor whiteColor];
            groupPicker.tag                    = sender.tag;
            [numberBackground addSubview:groupPicker];

            tbar_picker.backgroundColor        = PRGBAColor(0, 149, 227,1);
            [numberBackground addSubview:tbar_picker];

            UIButton *cancelBtn                = [UIButton buttonWithType:UIButtonTypeCustom];
            cancelBtn.frame                    = CGRectMake(10, 0, 50, 44);
            cancelBtn.titleLabel.font = DEFAULT_FONT(FontName,18);
            [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
            [cancelBtn addTarget:self action:@selector(tapView:) forControlEvents:UIControlEventTouchUpInside];
            [tbar_picker addSubview:cancelBtn];

            doneBtn.titleLabel.font = DEFAULT_FONT(FontName,18);
            [doneBtn setTitle:@"完成" forState:UIControlStateNormal];
            [doneBtn addTarget:self action:@selector(pickerDone:) forControlEvents:UIControlEventTouchUpInside];
            [tbar_picker addSubview:doneBtn];
            doneBtn.tag = sender.tag;
        }
            break;
        default:
            break;
    }
}

#pragma mark ---------------> PooSegViewDelegate
-(void)didSelectedSegmentAtIndex:(NSInteger)index
{
    bowStr = self.bowsArr[index];
}

#pragma mark - UIPickerViewDatasource
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    switch (pickerView.tag) {
        case 2:
        {
            return self.distanceArr.count;
        }
            break;
        case 3:
        {
            return self.targetSizeArr.count;
        }
            break;
        case 4:
        {
            return self.groupArr.count;
        }
            break;
        case 5:
        {
            return self.numberOfGroupArr.count;
        }
            break;
        default:
            break;
    }
    return 0;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    switch (pickerView.tag) {
        case 2:
        {
            distanceStr = self.distanceArr[row];
        }
            break;
        case 3:
        {
            sizeStr = self.targetSizeArr[row];
        }
            break;
        case 4:
        {
            groupStr = self.groupArr[row];
        }
            break;
        case 5:
        {
            numberStr = self.numberOfGroupArr[row];
        }
            break;
        default:
            break;
    }
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *mycom1;
    mycom1 = view ? (UILabel *) view : [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, screenWidth/2, 30.0f)];
    NSString *imgstr1;

    switch (pickerView.tag) {
        case 2:
        {
            imgstr1 = self.distanceArr[row];
        }
            break;
        case 3:
        {
            imgstr1 = self.targetSizeArr[row];
        }
            break;
        case 4:
        {
            imgstr1 = self.groupArr[row];
        }
            break;
        case 5:
        {
            imgstr1 = self.numberOfGroupArr[row];
        }
            break;
        default:
            break;
    }
    mycom1.text = imgstr1;
    mycom1.textAlignment = NSTextAlignmentCenter;
    [mycom1 setFont:DEFAULT_FONT(FontName,24)];
    mycom1.backgroundColor = [UIColor clearColor];
    return mycom1;
}

#pragma mark ---------------> AboutPicker
- (void)tapView:(UITapGestureRecognizer *)gesture {
    [distanceBackground removeFromSuperview];
    [sizeBackground removeFromSuperview];
    [groupBackground removeFromSuperview];
    [numberBackground removeFromSuperview];
}

-(void)pickerDone:(UIButton *)sender
{
    switch (sender.tag) {
        case 2:
        {
            if (kStringIsEmpty(distanceStr)) {
                distanceStr = self.distanceArr[0];
            }
            [distanceBackground removeFromSuperview];
            [distanceBtn setTitle:distanceStr forState:UIControlStateNormal];

        }
            break;
        case 3:
        {
            if (kStringIsEmpty(sizeStr)) {
                sizeStr = self.targetSizeArr[0];
            }
            [sizeBackground removeFromSuperview];
            [sizeBtn setTitle:sizeStr forState:UIControlStateNormal];
        }
            break;
        case 4:
        {
            if (kStringIsEmpty(groupStr)) {
                groupStr = self.groupArr[0];
            }
            [groupBackground removeFromSuperview];
            [groupBtn setTitle:groupStr forState:UIControlStateNormal];
        }
            break;
        case 5:
        {
            if (kStringIsEmpty(numberStr)) {
                numberStr = self.numberOfGroupArr[0];
            }
            [numberBackground removeFromSuperview];
            [numberBtn setTitle:numberStr forState:UIControlStateNormal];
        }
            break;
        default:
            break;
    }

    if (kStringIsEmpty(distanceStr))
    {
        next.backgroundColor = [UIColor lightGrayColor];
    }
    else if (kStringIsEmpty(sizeStr))
    {
        next.backgroundColor = [UIColor lightGrayColor];
    }
    else if (kStringIsEmpty(groupStr))
    {
        next.backgroundColor = [UIColor lightGrayColor];
    }
    else if (kStringIsEmpty(numberStr))
    {
        next.backgroundColor = [UIColor lightGrayColor];
    }
    else if (kStringIsEmpty(bowStr))
    {
        bowStr = self.bowsArr[0];
        next.userInteractionEnabled = YES;
        next.backgroundColor = PRGBAColor(0, 149, 227,1);
    }
    else
    {
        next.userInteractionEnabled = YES;
        next.backgroundColor = PRGBAColor(0, 149, 227,1);
    }
}
@end
