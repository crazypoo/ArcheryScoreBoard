//
//  CGGobalTools.m
//  CGBase_Example
//
//  Created by crazypoo on 2019/6/16.
//  Copyright © 2019 crazypoo. All rights reserved.
//

#import "CGBaseGobalTools.h"

#import <PooTools/YXCustomAlertView.h>
#import <PooTools/PMacros.h>
#import <Masonry/Masonry.h>
#import <MBProgressHUD/MBProgressHUD.h>
#import <PooTools/PooSystemInfo.h>

#import "CGBaseMarcos.h"
#import "CGGobalAPI.h"
#import "CGBaseLoadingView.h"

@implementation ZAlertPlaySound
- (id)initSystemShake
{
    self = [super init];
    if (self) {
        sound = kSystemSoundID_Vibrate;//震动
    }
    return self;
}

- (id)initSystemSoundWithName:(NSString *)soundName SoundType:(NSString *)soundType
{
    self = [super init];
    if (self) {
        NSString *path = [NSString stringWithFormat:@"/System/Library/Audio/UISounds/%@.%@",soundName,soundType];
        //[[NSBundle bundleWithIdentifier:@"com.apple.UIKit" ]pathForResource:soundName ofType:soundType];//得到苹果框架资源UIKit.framework ，从中取出所要播放的系统声音的路径
        //[[NSBundle mainBundle] URLForResource: @"tap" withExtension: @"aif"];  获取自定义的声音
        if (path) {
            OSStatus error = AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path],&sound);
            
            if (error != kAudioServicesNoError) {//获取的声音的时候，出现错误
                sound = 0;
            }
        }
    }
    return self;
}

- (void)play
{
    AudioServicesPlaySystemSound(sound);
}

@end

@implementation CGBaseGobalTools

#pragma mark ---------------> Alert
+(void)gobalCustomAlertWithCustomHeigh:(CGFloat)customH
                                showIn:(UIView *)showIn
                           withButtons:(NSArray *)btns
                               withTag:(NSInteger)tags
                             withTitle:(NSString *)title
                               setView:(YXCustomAlertViewSetCustomViewBlock)setViewBlock
                                 click:(YXCustomAlertViewClickBlock)clickBlock
                               dismiss:(YXCustomAlertViewDidDismissBlock)dismissBlock
{
    CGFloat alertW = kSCREEN_WIDTH-CustomAlertNormalSpace*2;
    
    CGFloat dilH = [YXCustomAlertView titleAndBottomViewNormalHeighEXAlertW:alertW withTitle:title withTitleFont:AppLargeTitleFont withButtonArr:btns] + customH;
    
    YXCustomAlertView *alertV = [[YXCustomAlertView alloc] initAlertViewWithSuperView:showIn
                                                                           alertTitle:title
                                                               withButtonAndTitleFont:AppLargeTitleFont
                                                                           titleColor:[CGBaseGobalTools AppTextBlack]
                                                               bottomButtonTitleColor:@[[CGBaseGobalTools AppAlertButtonColor]]
                                                                         verLineColor:[CGBaseGobalTools AppGray]
                                                             alertViewBackgroundColor:[CGBaseGobalTools AppCellBGColor]
                                                                   heightlightedColor:nil
                                                                 moreButtonTitleArray:btns
                                                                              viewTag:tags
                                                                        viewAnimation:AlertAnimationTypeTop
                                                                      touchBackGround:NO
                                                                        setCustomView:^(YXCustomAlertView *alertView) {
        setViewBlock(alertView);
    } clickAction:^(YXCustomAlertView *alertView, NSInteger buttonIndex) {
        clickBlock(alertView,buttonIndex);
    } didDismissBlock:^(YXCustomAlertView *alertView) {
        dismissBlock(alertView);
    }];
    [alertV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(alertW);
        make.height.offset(dilH);
        make.centerX.centerY.equalTo(showIn);
    }];
}

+(void)gobalFreakSystemAlertWithTitle:(NSString *)title
                          withMessage:(NSString *)message
                      withCancelTitle:(NSString *)cancelT
                          withOkTitle:(NSString *)okT
                             okHandle:(void (^)(void))okBlock
                         cencelHandle:(void (^)(void))cencelBlock
{
    NSMutableArray *btnArr = [NSMutableArray array];
    if (!kStringIsEmpty(okT)) {
        [btnArr addObject:okT];
    }
    if (!kStringIsEmpty(cancelT))
    {
        [btnArr addObject:cancelT];
    }
    
    CGFloat alertW = kSCREEN_WIDTH-CustomAlertNormalSpace*4;
    
    CGFloat messageH = [Utils sizeForString:message font:AppLargeTitleFont andHeigh:CGFLOAT_MAX andWidth:alertW].height;
    CGFloat alertH = [YXCustomAlertView titleAndBottomViewNormalHeighEXAlertW:alertW withTitle:title withTitleFont:AppLargeTitleFont withButtonArr:btnArr] + messageH;
    
    CGFloat customViewH = 0.0f;
    if (alertH >= kSCREEN_HEIGHT) {
        customViewH = 400;
    }
    else
    {
        customViewH = messageH+CustomAlertNormalSpace*2;
    }
    
    [CGBaseGobalTools gobalCustomAlertWithCustomHeigh:customViewH showIn:kAppDelegateWindow withButtons:btnArr withTag:0 withTitle:title setView:^(YXCustomAlertView * _Nonnull alertView) {
        UIScrollView *scrollerView = [UIScrollView new];
        scrollerView.showsVerticalScrollIndicator = NO;
        [alertView.customView addSubview:scrollerView];
        [scrollerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.equalTo(alertView.customView);
        }];
        scrollerView.contentSize = CGSizeMake(alertW, messageH);
        
        UILabel *messageLabel = [UILabel new];
        messageLabel.font = AppLargeTitleFont_BOLD;
        messageLabel.textAlignment = ((messageH - AppLargeTitleFont_SIZE) > 5) ? NSTextAlignmentLeft : NSTextAlignmentCenter;
        messageLabel.textColor = [CGBaseGobalTools AppTextBlack];
        messageLabel.numberOfLines = 0;
        messageLabel.lineBreakMode = NSLineBreakByCharWrapping;
        messageLabel.text = message;
        [scrollerView addSubview:messageLabel];
        [messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(scrollerView);
            make.left.equalTo(scrollerView).offset(CustomAlertNormalSpace);
            make.width.offset(alertW);
            make.height.offset(messageH);
        }];
        PNSLog(@"%ld",(long)messageLabel.numberOfLines);
    } click:^(YXCustomAlertView * _Nonnull alertView, NSInteger buttonIndex) {
        switch (buttonIndex) {
            case 0:
            {
                okBlock();
            }
                break;
            default:
            {
                cencelBlock();
            }
                break;
        }
        [alertView dissMiss];
        alertView = nil;
    } dismiss:^(YXCustomAlertView * _Nonnull alertView) {
        
    }];
}

+(void)gobalShowHUDWithMessgae:(NSString *)message
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:kAppDelegateWindow animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.label.font = AppFontNormal_BOLD;
    hud.label.numberOfLines = 0;
    hud.label.lineBreakMode = NSLineBreakByCharWrapping;
    hud.label.text = message;
    [hud hideAnimated:YES afterDelay:3.0];
}

+(void)gobalShowAlertTitle:(NSString *)title
                   message:(NSString *)message
{
    [CGBaseGobalTools gobalFreakSystemAlertWithTitle:title
                                         withMessage:message
                                     withCancelTitle:AlertNormalOnlyCancel
                                         withOkTitle:nil okHandle:^{}
                                        cencelHandle:^{}
     ];
}

#pragma mark ---------------> Picker
+(void)gobalNormalPickerTitle:(NSString *)title
                   pickerData:(NSArray <PTNormalPickerModel *>*)dataArr
                 currentTitle:(NSString *)currentTitle
                tapBarBGColor:(UIColor *)tbColor
                   pickerFont:(UIFont *)font
                       handle:(PickerReturnBlock)pickerBlock
{
    PTNormalPicker *nP = [[PTNormalPicker alloc] initWithNormalPickerBackgroundColor:[CGBaseGobalTools AppCellBGColor]
                                                                   withTapBarBGColor:tbColor
                                                           withTitleAndBtnTitleColor:[UIColor whiteColor]
                                                                withPickerTitleColor:[CGBaseGobalTools AppTextBlack]
                                                                       withTitleFont:font
                                                                      withPickerData:dataArr
                                                                     withPickerTitle:title
                                                               checkPickerCurrentRow:currentTitle];
    nP.returnBlock = ^(PTNormalPicker *normalPicker, PTNormalPickerModel *pickerModel) {
        pickerBlock(normalPicker,pickerModel);
    };
    [nP pickerShow];
}

#pragma mark ---------------> ActionSheet
+(void)gobalActionSheetTitles:(NSArray *)titles
                        title:(NSString *)title
                 titleMessage:(NSString *)message
                       handle:(ALActionSheetViewDidSelectButtonBlock)block
{
    ALActionSheetView *actionSheet = [[ALActionSheetView alloc] initWithTitle:title
                                                                 titleMessage:message
                                                            cancelButtonTitle:AlertNormalCancel
                                                       destructiveButtonTitle:nil
                                                            otherButtonTitles:titles
                                                               buttonFontName:FontName
                                                    singleCellBackgroundColor:[CGBaseGobalTools AppCellBGColor]
                                                         normalCellTitleColor:[CGBaseGobalTools AppTextBlack]
                                                    destructiveCellTitleColor:nil
                                                          titleCellTitleColor:nil
                                                               separatorColor:nil
                                                             heightlightColor:nil
                                                                      handler:^(ALActionSheetView *actionSheetView, NSInteger buttonIndex) {
            block(actionSheetView,buttonIndex);
    }];
    [actionSheet show];
}

#pragma mark ---------------> 图片浏览
+(void)gobalPhotoBrowserImages:(NSArray <PooShowImageModel*>*)appendArray
                     canDelete:(BOOL)deletes
                       canSave:(BOOL)save
                      showMore:(BOOL)more
                    handleSave:(void (^)(BOOL saveStatus))saveBlock
                   handleOther:(YMShowImageViewShowOtherAction)otherBlock
                  handleDelete:(YMShowImageViewDidDeleted)deleteBlock
              handleShowFinish:(didRemoveImage)finishBlock
                    imageIndex:(NSInteger)index
{
    NSString *moreImageName = more ? @"image_myroom_open" : nil;
    
    YMShowImageView *ymImageV = [[YMShowImageView alloc] initWithByClick:YMShowImageViewClickTagAppend + index appendArray:appendArray titleColor:[UIColor whiteColor] fontName:FontName showImageBackgroundColor:[CGBaseGobalTools AppBlack] showWindow:kAppDelegateWindow loadingImageName:@"image_ad_loading" deleteAble:deletes saveAble:save moreActionImageName:moreImageName hideImageName:@"image_close_white"];
    [ymImageV showWithFinish:^{
        finishBlock();
    }];
    ymImageV.saveImageStatus = ^(BOOL saveStatus) {
        saveBlock(saveStatus);
    };
    ymImageV.otherBlock = ^(NSInteger index) {
        otherBlock(index);
    };
    ymImageV.didDeleted = ^(YMShowImageView *siv, NSInteger index) {
        deleteBlock(siv,index);
    };
    [ymImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(kAppDelegateWindow);
    }];
}

#pragma mark ---------------> API
+(void)apiServeApiURL:(NSString *)apiURL
            withParmars:(NSMutableDictionary *)parmars
                hideHub:(BOOL)hide
                 handle:(APIBlock)block
{
    [CGBaseGobalTools customServerAddress:[NSURL URLWithString:[NSString stringWithFormat:@"%@://%@",[CGBaseGobalTools httpsString], REQUEST_BASE_URL]] customApiURL:apiURL withParmars:parmars hideHub:hide handle:block];
}

+(void)customServerAddress:(NSURL*)serverAddress
              customApiURL:(NSString *)apiURL
               withParmars:(NSMutableDictionary *)parmars
                   hideHub:(BOOL)hide
                    handle:(APIBlock)block
{
    CGBaseLoadingView *loadingView = [CGBaseLoadingView new];
    if (!hide)
    {
        [loadingView loadingViewShow];
    }
    kShowNetworkActivityIndicator();
    RespDictionaryBlock dBlock = ^(NSMutableDictionary *infoDict, NSError *error) {
        [loadingView loadingViewDismiss];
        kHideNetworkActivityIndicator();
        if (!error)
        {
            if (infoDict && [infoDict isKindOfClass:[NSMutableDictionary class]])
            {
                block(YES,infoDict);
            }
        }
        else
        {
            block(NO,nil);
        }
    };
    
    IGHTTPClient *sssss = [[IGHTTPClient alloc] initWithBaseURL:serverAddress];
    [sssss POSTApi:apiURL
        parameters:parmars
         parserKey:pkIGTestParserApp
           success:[IGRespBlockGenerator taskSuccessBlockWithDictionaryBlock:dBlock]
           failure:[IGRespBlockGenerator taskFailureBlockWithDictionaryBlock:dBlock]];
    
}

#pragma mark ------>图表相关
+(NSArray *)monthArrZHCN
{
    return @[@"1月",@"2月",@"3月",@"4月",@"5月",@"6月",@"7月",@"8月",@"9月",@"10月",@"11月",@"12月"];
}

+(NSArray *)monthArr
{
    return @[@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09",@"10",@"11",@"12"];
}

+(NSMutableArray *)createChartYLabelsArr:(NSString *)maxString
{
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    for (int i = 5; i >= 0; i--) {
        [arr addObject:[NSString stringWithFormat:@"%d",[maxString intValue]-[maxString intValue]/5*(i)]];
    }
    return arr;
}

+(NSMutableArray *)createChartXLabelDataHalfYearType:(CGMainChartHalfYearType)type
{
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    
    switch (type) {
        case CGMainChartHalfYearTypeFull:
        {
            [arr addObjectsFromArray:[CGBaseGobalTools monthArrZHCN]];
        }
            break;
        case CGMainChartHalfYearTypeFront:
        {
            [arr addObjectsFromArray:@[@"1月",@"2月",@"3月",@"4月",@"5月",@"6月"]];
        }
            break;
        case CGMainChartHalfYearTypeBack:
        {
            [arr addObjectsFromArray:@[@"7月",@"8月",@"9月",@"10月",@"11月",@"12月"]];
        }
            break;
        case CGMainChartHalfYearTypeEX:
        {
            NSDate *date = [NSDate date];
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateStyle:NSDateFormatterMediumStyle];
            [formatter setTimeStyle:NSDateFormatterShortStyle];
            [formatter setDateFormat:@"MM"];
            NSString *dateTime = [formatter stringFromDate:date];
            NSInteger currentMonthIndex = [[CGBaseGobalTools monthArr] indexOfObject:dateTime];
            for (int i = ((int)currentMonthIndex-5) ; i < currentMonthIndex+1; i++)
            {
                [arr addObject:[CGBaseGobalTools monthArrZHCN][i]];
            }
        }
            break;
        case CGMainChartHalfYearTypeSeasonEX:
        {
            NSDate *date = [NSDate date];
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateStyle:NSDateFormatterMediumStyle];
            [formatter setTimeStyle:NSDateFormatterShortStyle];
            [formatter setDateFormat:@"MM"];
            NSString *dateTime = [formatter stringFromDate:date];
            NSInteger currentMonthIndex = [[CGBaseGobalTools monthArr] indexOfObject:dateTime];
            for (int i = ((int)currentMonthIndex-2) ; i < currentMonthIndex+1; i++)
            {
                [arr addObject:[CGBaseGobalTools monthArrZHCN][i]];
            }
        }
            break;
        default:
            break;
    }
    return arr;
}

+(NSMutableArray *)createChartXLabelDataQuarterType:(CGMainChartQuarterType)type
{
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    
    switch (type) {
        case CGMainChartQuarterTypeQuarterFull:
        {
            [arr addObjectsFromArray:[CGBaseGobalTools monthArrZHCN]];
        }
            break;
        case CGMainChartQuarterTypeQuarter1:
        {
            [arr addObjectsFromArray:@[@"1月",@"2月",@"3月"]];
        }
            break;
        case CGMainChartQuarterTypeQuarter2:
        {
            [arr addObjectsFromArray:@[@"4月",@"5月",@"6月"]];
        }
            break;
        case CGMainChartQuarterTypeQuarter3:
        {
            [arr addObjectsFromArray:@[@"7月",@"8月",@"9月"]];
        }
            break;
        case CGMainChartQuarterTypeQuarter4:
        {
            [arr addObjectsFromArray:@[@"10月",@"11月",@"12月"]];
        }
            break;
        default:
            break;
    }
    return arr;
}

+(NSString *)getLastMonthDataWithData:(NSArray *)data
{
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"MM"];
    NSString *dateTime = [formatter stringFromDate:date];
    
    NSInteger index;
    if ([[CGBaseGobalTools monthArr] indexOfObject:dateTime] == 0) {
        index = 0;
    }
    else
    {
        index = [[CGBaseGobalTools monthArr] indexOfObject:dateTime] - 1;
    }
    return [NSString stringWithFormat:@"%@",data[index]];
}

+(NSString *)getCurrentMonthDataWithData:(NSArray *)data
{
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"MM"];
    NSString *dateTime = [formatter stringFromDate:date];
    
    NSInteger index = [[CGBaseGobalTools monthArr] indexOfObject:dateTime];
    
    return [NSString stringWithFormat:@"%@",data[index]];
}

+(CGChartAndMonthsModel *)getHalfYearOrSeasonDataInFullYearData:(NSArray *)data
                                                       dataType:(CGGetTimeType)type
{
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"MM"];
    NSString *dateTime = [formatter stringFromDate:date];
    
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    NSMutableArray *vauleArr = [[NSMutableArray alloc] init];
    
    CGChartAndMonthsModel *model = [[CGChartAndMonthsModel alloc] init];
    
    switch (type)
    {
        case CGGetTimeTypeSeason:
        {
            if ([dateTime isEqualToString:@"01"] || [dateTime isEqualToString:@"02"] || [dateTime isEqualToString:@"03"])
            {
                [arr addObjectsFromArray:@[@"1月",@"2月",@"3月"]];
                for (int i = 0; i < 3; i++)
                {
                    [vauleArr addObject:data[i]];
                }
                model.halfOrSeasonType = 1;
            }
            else if ([dateTime isEqualToString:@"04"] || [dateTime isEqualToString:@"05"] || [dateTime isEqualToString:@"06"])
            {
                [arr addObjectsFromArray:@[@"4月",@"5月",@"6月"]];
                for (int i = 3; i < 6; i++)
                {
                    [vauleArr addObject:data[i]];
                }
                model.halfOrSeasonType = 2;
            }
            else if ([dateTime isEqualToString:@"07"] || [dateTime isEqualToString:@"08"] || [dateTime isEqualToString:@"09"])
            {
                [arr addObjectsFromArray:@[@"7月",@"8月",@"9月"]];
                for (int i = 6; i < 9; i++)
                {
                    [vauleArr addObject:data[i]];
                }
                model.halfOrSeasonType = 3;
            }
            else if ([dateTime isEqualToString:@"10"] || [dateTime isEqualToString:@"11"] || [dateTime isEqualToString:@"12"])
            {
                [arr addObjectsFromArray:@[@"10月",@"11月",@"12月"]];
                for (int i = 9; i < data.count; i++)
                {
                    [vauleArr addObject:data[i]];
                }
                model.halfOrSeasonType = 4;
            }
        }
            break;
        case CGGetTimeTypeYear:
        {
            if ([dateTime isEqualToString:@"01"] || [dateTime isEqualToString:@"02"] || [dateTime isEqualToString:@"03"] || [dateTime isEqualToString:@"04"] || [dateTime isEqualToString:@"05"] || [dateTime isEqualToString:@"06"])
            {
                [arr addObjectsFromArray:@[@"1月",@"2月",@"3月",@"4月",@"5月",@"6月"]];
                for (int i = 0; i < data.count/2; i++)
                {
                    [vauleArr addObject:data[i]];
                }
                model.halfOrSeasonType = 1;
            }
            else if ([dateTime isEqualToString:@"07"] || [dateTime isEqualToString:@"08"] || [dateTime isEqualToString:@"09"] || [dateTime isEqualToString:@"10"] || [dateTime isEqualToString:@"11"] || [dateTime isEqualToString:@"12"])
            {
                [arr addObjectsFromArray:@[@"7月",@"8月",@"9月",@"10月",@"11月",@"12月"]];
                
                NSInteger dataHalfCount = data.count/2;
                for (int i = (int)dataHalfCount ; i < data.count; i++)
                {
                    [vauleArr addObject:data[i]];
                }
                model.halfOrSeasonType = 2;
            }
        }
            break;
        case CGGetTimeTypeHalfEX:
        {
            NSInteger currentMonthIndex = [[CGBaseGobalTools monthArr] indexOfObject:dateTime];
            
            if (currentMonthIndex <= 5) {
                [arr addObjectsFromArray:@[@"1月",@"2月",@"3月",@"4月",@"5月",@"6月"]];
                for (int i = 0; i < data.count/2; i++)
                {
                    [vauleArr addObject:data[i]];
                }
                model.halfOrSeasonType = 5;
            }
            else if (currentMonthIndex == 11)
            {
                [arr addObjectsFromArray:@[@"7月",@"8月",@"9月",@"10月",@"11月",@"12月"]];
                
                NSInteger dataHalfCount = data.count/2;
                for (int i = (int)dataHalfCount ; i < data.count; i++)
                {
                    [vauleArr addObject:data[i]];
                }
                model.halfOrSeasonType = 2;
            }
            else
            {
                for (int i = ((int)currentMonthIndex-5) ; i < currentMonthIndex+1; i++)
                {
                    [arr addObject:[CGBaseGobalTools monthArrZHCN][i]];
                    [vauleArr addObject:data[i]];
                }
                model.halfOrSeasonType = 5;
            }
        }
            break;
        case CGGetTimeTypeSeasonEX:
        {
            NSInteger currentMonthIndex = [[CGBaseGobalTools monthArr] indexOfObject:dateTime];
            
            if (currentMonthIndex <= 2) {
                [arr addObjectsFromArray:@[@"1月",@"2月",@"3月"]];
                for (int i = 0; i < 3; i++)
                {
                    [vauleArr addObject:data[i]];
                }
                model.halfOrSeasonType = 1;
            }
            else if (currentMonthIndex == 11)
            {
                [arr addObjectsFromArray:@[@"10月",@"11月",@"12月"]];
                for (int i = 9; i < data.count; i++)
                {
                    [vauleArr addObject:data[i]];
                }
                model.halfOrSeasonType = 4;
            }
            else
            {
                for (int i = ((int)currentMonthIndex-2) ; i < currentMonthIndex+1; i++)
                {
                    [arr addObject:[CGBaseGobalTools monthArrZHCN][i]];
                    [vauleArr addObject:data[i]];
                }
                model.halfOrSeasonType = 5;
            }
        }
            break;
        default:
            break;
    }
    model.monthArr = arr;
    model.vauleArr = vauleArr;
    return model;
}

+(CGChartModel *)dataModel:(NSArray *)dataArr
{
    CGChartModel *model = [[CGChartModel alloc] init];
    model.lastMonthStr = [CGBaseGobalTools getLastMonthDataWithData:dataArr];
    model.currentMonthStr = [CGBaseGobalTools getCurrentMonthDataWithData:dataArr];
    model.dataTotalStr = [CGBaseGobalTools totalMoneyWithDataArray:dataArr];
    model.fullYearChartMaxStr = [CGBaseGobalTools maxVauleInDataArray:dataArr];
    
    model.dataHalf = [CGBaseGobalTools getHalfYearOrSeasonDataInFullYearData:dataArr dataType:CGGetTimeTypeYear].vauleArr;
    model.dataHalfTotalStr = [CGBaseGobalTools totalMoneyWithDataArray:model.dataHalf];
    model.halfYearChartMaxStr = [CGBaseGobalTools maxVauleInDataArray:model.dataHalf];
    
    model.dataHalfEX = [CGBaseGobalTools getHalfYearOrSeasonDataInFullYearData:dataArr dataType:CGGetTimeTypeHalfEX].vauleArr;
    model.dataHalfTotalStrEX = [CGBaseGobalTools totalMoneyWithDataArray:model.dataHalfEX];
    model.halfYearChartMaxStrEX = [CGBaseGobalTools maxVauleInDataArray:model.dataHalfEX];

    model.dataSeason = [CGBaseGobalTools getHalfYearOrSeasonDataInFullYearData:dataArr dataType:CGGetTimeTypeSeason].vauleArr;
    model.dataSeasonTotalStr = [CGBaseGobalTools totalMoneyWithDataArray:model.dataSeason];
    model.SeasonChartMaxStr = [CGBaseGobalTools maxVauleInDataArray:model.dataSeason];
    
    model.dataSeasonEX = [CGBaseGobalTools getHalfYearOrSeasonDataInFullYearData:dataArr dataType:CGGetTimeTypeSeasonEX].vauleArr;
    model.dataSeasonTotalStrEX = [CGBaseGobalTools totalMoneyWithDataArray:model.dataSeasonEX];
    model.SeasonChartMaxStrEX = [CGBaseGobalTools maxVauleInDataArray:model.dataSeasonEX];
    
    model.halfYearType = [CGBaseGobalTools getHalfYearOrSeasonDataInFullYearData:dataArr dataType:CGGetTimeTypeYear].halfOrSeasonType;
    model.seasonType = [CGBaseGobalTools getHalfYearOrSeasonDataInFullYearData:dataArr dataType:CGGetTimeTypeSeason].halfOrSeasonType;
    return model;
}

#pragma mark ------>数组相关
+(NSString *)totalMoneyWithDataArray:(NSArray *)data
{
    NSNumber *sum = [data valueForKeyPath:@"@sum.floatValue"];
    return [NSString stringWithFormat:@"%@",sum];
}

+(NSString *)maxVauleInDataArray:(NSArray *)data
{
    NSNumber *sum = [data valueForKeyPath:@"@max.floatValue"];
    return [NSString stringWithFormat:@"%@",sum];
}

#pragma mark ------>打电话
+(void)makeAPhoneCall:(NSString *)alertTitle
            withPhone:(NSString *)phone
          alertShowIn:(UIViewController *)vc
{
    [CGBaseGobalTools gobalFreakSystemAlertWithTitle:AlertNormalTitle withMessage:alertTitle withCancelTitle:AlertNormalCancel withOkTitle:@"拨打" okHandle:^{
        GCDAfter(0.35, ^{
            [PooPhoneBlock callPhoneNumber:phone call:^(NSTimeInterval duration) {
            } cancel:^{
            }];
        });
    } cencelHandle:^{
    }];
}

#pragma mark ------>新手教程
+(void)viewControllerGuideViewWithTitles:(NSArray <NSString *>*)titles
                               withRects:(NSArray <NSValue *>*)rects
                                  showIn:(UIViewController *)vc
{
    XSpotLight *sportLight = [[XSpotLight alloc] init];
    sportLight.messageArray = titles;
    sportLight.rectArray = rects;
    [vc presentViewController:sportLight animated:NO completion:^{
        
    }];
}

#pragma mark ------>App完整连接
+(NSURL *)getImageFullUrlwithServerPartUrl:(NSString *)url
{
    NSString *imageURL = [NSString stringWithFormat:@"%@://%@%@",[CGBaseGobalTools httpsString],REQUEST_BASE_URL,url];
    return [NSURL URLWithString:imageURL];
}

#pragma mark ---------------> AssetsData
+(NSBundle *)cgBaseBundle
{
    NSBundle *resource_bundle = [NSBundle bundleForClass:[self class]];
    return resource_bundle;
}

+(UIColor *)color:(NSString *)name compatibleWithTraitCollection:(UITraitCollection *)traitCollection NS_AVAILABLE_IOS(11_0)
{
    return [UIColor colorNamed:name inBundle:[CGBaseGobalTools cgBaseBundle] compatibleWithTraitCollection:traitCollection];
}

+(UIImage *)image:(NSString *)name compatibleWithTraitCollection:(UITraitCollection *)traitCollection
{
    return [UIImage imageNamed:name inBundle:[CGBaseGobalTools cgBaseBundle] compatibleWithTraitCollection:traitCollection];
}

#pragma mark ---------------> UICOLOR
+(NSString *)AppWhiteString
{
    return @"#FFFFFF";
}

+(UIColor *)AppWhite
{
    if (@available(iOS 11.0, *))
    {
        return [CGBaseGobalTools color:@"AppWhite" compatibleWithTraitCollection:kAppDelegateWindow.rootViewController.traitCollection];
    }
    else
    {
        return kColorFromHex(0xFFFFFF);
    }
}

+(NSString *)AppBlackString
{
    return @"#000000";
}

+(UIColor *)AppBlack
{
    if (@available(iOS 11.0, *))
    {
        return [CGBaseGobalTools color:@"AppBlack" compatibleWithTraitCollection:kAppDelegateWindow.rootViewController.traitCollection];
    }
    else
    {
        return kColorFromHex(0x000000);
    }
}

+(NSString *)AppBlueString
{
    return @"#0D6BAE";
}

+(UIColor *)AppBlue
{
    if (@available(iOS 11.0, *))
    {
        return [CGBaseGobalTools color:@"AppBlue" compatibleWithTraitCollection:kAppDelegateWindow.rootViewController.traitCollection];
    }
    else
    {
        return kColorFromHex(0x0D6BAE);
    }
}

+(NSString *)AppOrangeString
{
    return @"#ff7112";
}

+(UIColor *)AppOrange
{
    if (@available(iOS 11.0, *))
    {
        return [CGBaseGobalTools color:@"AppOrange" compatibleWithTraitCollection:kAppDelegateWindow.rootViewController.traitCollection];
    }
    else
    {
        return kColorFromHex(0xff7112);
    }
}

+(NSString *)AppRedString
{
    return @"#CF2326";
}

+(UIColor *)AppRed
{
    if (@available(iOS 11.0, *))
    {
        return [CGBaseGobalTools color:@"AppRed" compatibleWithTraitCollection:kAppDelegateWindow.rootViewController.traitCollection];
    }
    else
    {
        return kColorFromHex(0xCF2326);
    }
}

+(NSString *)AppGrayString
{
    return @"#afafaf";
}

+(UIColor *)AppGray
{
    if (@available(iOS 11.0, *))
    {
        return [CGBaseGobalTools color:@"AppGray" compatibleWithTraitCollection:kAppDelegateWindow.rootViewController.traitCollection];
    }
    else
    {
        return kColorFromHex(0xafafaf);
    }
}

+(NSString *)AppSuperLightGrayString
{
    return @"#f2f2f2";
}

+(UIColor *)AppSuperLightGray
{
    if (@available(iOS 11.0, *))
    {
        return [CGBaseGobalTools color:@"AppSuperLightGray" compatibleWithTraitCollection:kAppDelegateWindow.rootViewController.traitCollection];
    }
    else
    {
        return kColorFromHex(0xf2f2f2);
    }
}

+(NSString *)AppChartWater_String
{
    return @"#4dcfff";
}

+(UIColor *)AppChartWater
{
    if (@available(iOS 11.0, *))
    {
        return [CGBaseGobalTools color:@"AppChartWater" compatibleWithTraitCollection:kAppDelegateWindow.rootViewController.traitCollection];
    }
    else
    {
        return kColorFromHex(0x4dcfff);
    }
}

+(NSString *)AppChartPower_String
{
    return @"#8dd06b";
}

+(UIColor *)AppChartPower
{
    if (@available(iOS 11.0, *))
    {
        return [CGBaseGobalTools color:@"AppChartPower" compatibleWithTraitCollection:kAppDelegateWindow.rootViewController.traitCollection];
    }
    else
    {
        return kColorFromHex(0x8dd06b);
    }
}

+(NSString *)AppChartHouse_String
{
    return @"#ffb75f";
}

+(UIColor *)AppChartHouse
{
    if (@available(iOS 11.0, *))
    {
        return [CGBaseGobalTools color:@"AppChartHouse" compatibleWithTraitCollection:kAppDelegateWindow.rootViewController.traitCollection];
    }
    else
    {
        return kColorFromHex(0xffb75f);
    }
}

+(NSString *)AppChartNet_String
{
    return @"#fc7255";
}

+(UIColor *)AppChartNet
{
    if (@available(iOS 11.0, *))
    {
        return [CGBaseGobalTools color:@"AppChartNet" compatibleWithTraitCollection:kAppDelegateWindow.rootViewController.traitCollection];
    }
    else
    {
        return kColorFromHex(0xfc7255);
    }
}

+(NSString *)AppChartMan_String
{
    return @"#7378cd";
}

+(UIColor *)AppChartMan
{
    if (@available(iOS 11.0, *))
    {
        return [CGBaseGobalTools color:@"AppChartMan" compatibleWithTraitCollection:kAppDelegateWindow.rootViewController.traitCollection];
    }
    else
    {
        return kColorFromHex(0x7378cd);
    }
}

+(NSString *)AppChartCrosshairColor_String
{
    return @"#778899";
}

+(NSString *)AppCellBGColor_String
{
    return [CGBaseGobalTools AppWhiteString];
}

+(UIColor *)AppCellBGColor
{
    if (@available(iOS 11.0, *))
    {
        return [CGBaseGobalTools color:@"AppCellBGColor" compatibleWithTraitCollection:kAppDelegateWindow.rootViewController.traitCollection];
    }
    else
    {
        return [CGBaseGobalTools AppWhite];
    }
}

+(NSString *)AppTextBlack_String
{
    return [CGBaseGobalTools AppBlackString];
}

+(UIColor *)AppTextBlack
{
    if (@available(iOS 11.0, *))
    {
        return [CGBaseGobalTools color:@"AppTextBlack" compatibleWithTraitCollection:kAppDelegateWindow.rootViewController.traitCollection];
    }
    else
    {
        return [CGBaseGobalTools AppBlack];
    }
}

+(NSString *)AppTextWhite_String
{
    return [CGBaseGobalTools AppWhiteString];
}

+(UIColor *)AppTextWhite
{
    if (@available(iOS 11.0, *))
    {
        return [CGBaseGobalTools color:@"AppTextWhite" compatibleWithTraitCollection:kAppDelegateWindow.rootViewController.traitCollection];
    }
    else
    {
        return [CGBaseGobalTools AppWhite];
    }
}

+(NSString *)AppAlertButtonColor_String
{
    return [CGBaseGobalTools AppBlueString];
}

+(UIColor *)AppAlertButtonColor
{
    if (@available(iOS 11.0, *))
    {
        return [CGBaseGobalTools color:@"AppAlertButtonColor" compatibleWithTraitCollection:kAppDelegateWindow.rootViewController.traitCollection];
    }
    else
    {
        return [CGBaseGobalTools AppBlue];
    }
}

+(NSString *)AppTableBGColor_String
{
    return @"#FFFFFF";
}

+(UIColor *)AppTableBGColor
{
    if (@available(iOS 11.0, *))
    {
//        if (@available(iOS 13.0, *)) {
            return [CGBaseGobalTools color:@"AppTableBGColor_iOS13" compatibleWithTraitCollection:kAppDelegateWindow.rootViewController.traitCollection];
//        }
//        else
//        {
//            return [CGBaseGobalTools color:@"AppTableBGColor" compatibleWithTraitCollection:kAppDelegateWindow.rootViewController.traitCollection];
//        }
    }
    else
    {
        return kColorFromHex(0xF2F2F2);
    }
}

+(UIColor *)AppColor
{
    if ([[CGBaseGobalTools getBundleID] isEqualToString:@"com.crazykidhao.LandloardTool"]) {
        return [CGBaseGobalTools AppAlertButtonColor];
    }
    else if ([[CGBaseGobalTools getBundleID] isEqualToString:@"com.crazykidhao.CloudGateCustom"]) {
        return [CGBaseGobalTools AppOrange];
    }
    else
    {
        return [CGBaseGobalTools AppAlertButtonColor];
    }
    return kClearColor;
}

+(NSString*)getBundleID
{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];
}

+(UITableViewStyle)gobalTableStyle
{
    UITableViewStyle tableStyle;
    if (@available(iOS 13.0, *)) {
        tableStyle = UITableViewStyleInsetGrouped;
    }
    else
    {
        tableStyle = UITableViewStylePlain;
    }
    return tableStyle;
}

#pragma mark 提示音
+ (void)showVoice
{
    ZAlertPlaySound *msgPlaySound = nil;
    //通知声音
    if (msgPlaySound != nil)
    {
        msgPlaySound = nil;
    }
    msgPlaySound = [[ZAlertPlaySound alloc] initSystemSoundWithName:@"Tock" SoundType:@"caf"];
    [msgPlaySound play];
}

+(NSString *)httpsString
{
    return [USER_DEFAULT boolForKey:kHttps] ? @"https" : @"http";
}

#pragma mark ---------------> 下载扩展
+(NSString *)downLoadFileEX
{
    NSString *fileEX;
    if ([[PooSystemInfo platformString] containsString:@"iPhone X"])
    {
        fileEX = @"X";
    }
    else if ([[PooSystemInfo platformString] containsString:@"Plus"])
    {
        fileEX = @"SP";
    }
    else if ([[PooSystemInfo platformString] containsString:@"iPhone 5"] || [[PooSystemInfo platformString] containsString:@"iPad"] || [[PooSystemInfo platformString] containsString:@"iPod"])
    {
        fileEX = @"5";
    }
    else if ([[PooSystemInfo platformString] isEqualToString:@"iPhone 8"] || [[PooSystemInfo platformString] isEqualToString:@"iPhone 7"] || [[PooSystemInfo platformString] isEqualToString:@"iPhone 6s"] || [[PooSystemInfo platformString] isEqualToString:@"iPhone 6"])
    {
        fileEX = @"S";
    }
    else if ([[PooSystemInfo platformString] containsString:@"iPhone 4"])
    {
        fileEX = @"4";
    }
    else
    {
        fileEX = @"5";
    }
    return fileEX;
}

+(void)getEmbeddedInfo:(void (^)(BOOL isDevelopement,NSDictionary *embeddedInfo))block
{
    NSString *mobileProvisionPath = [[NSBundle mainBundle] pathForResource:@"embedded" ofType:@"mobileprovision"];
    NSData *rawData = [NSData dataWithContentsOfFile:mobileProvisionPath];
    NSString *rawDataString = [[NSString alloc] initWithData:rawData encoding:NSASCIIStringEncoding];
    NSRange plistStartRange = [rawDataString rangeOfString:@"<plist"];
    NSRange plistEndRange = [rawDataString rangeOfString:@"</plist>"];
    if (plistStartRange.location != NSNotFound && plistEndRange.location != NSNotFound) {
        NSString *tempPlistString = [rawDataString substringWithRange:NSMakeRange(plistStartRange.location, NSMaxRange(plistEndRange))];
        NSData *tempPlistData = [tempPlistString dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *plistDic =  [NSPropertyListSerialization propertyListWithData:tempPlistData options:NSPropertyListImmutable format:nil error:nil];
        NSArray *deviceArr = plistDic[@"ProvisionedDevices"];
        
        BOOL isDevelopement;
        if (deviceArr && [deviceArr isKindOfClass:[NSArray class]]) {
            if (!kArrayIsEmpty(deviceArr))
            {
                isDevelopement = YES;
            }
            else
            {
                isDevelopement = NO;
            }
        }
        else
        {
            isDevelopement = YES;
        }
        block(isDevelopement,plistDic);
    }
}

+(UIViewController *)getCurrentVCFrom:(UIViewController *)rootVC
{
    UIViewController *currentVC;
    if ([rootVC presentedViewController])
    {
        // 视图是被presented出来的
        rootVC = [rootVC presentedViewController];
    }

    if ([rootVC isKindOfClass:[UITabBarController class]])
    {
        // 根视图为UITabBarController
        currentVC = [CGBaseGobalTools getCurrentVCFrom:[(UITabBarController *)rootVC selectedViewController]];
    }
    else if ([rootVC isKindOfClass:[UINavigationController class]])
    {
        // 根视图为UINavigationController
        currentVC = [CGBaseGobalTools getCurrentVCFrom:[(UINavigationController *)rootVC visibleViewController]];
    }
    else
    {
        // 根视图为非导航类
        currentVC = rootVC;
    }
    return currentVC;
}

+(UIViewController *)getCurrentVC
{
    UIViewController *currentVC = [CGBaseGobalTools getCurrentVCFrom:kAppDelegateWindow.rootViewController];
    return currentVC;
}

@end

@implementation CGChartModel

@end

@implementation CGChartAndMonthsModel
@end
