//
//  CGGobalTools.h
//  CGBase_Example
//
//  Created by crazypoo on 2019/6/16.
//  Copyright © 2019 crazypoo. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <PooTools/YXCustomAlertView.h>
#import <PooTools/PTNormalPicker.h>
#import <PooTools/ALActionSheetView.h>
#import <PooTools/YMShowImageView.h>
#import "CGBaseLoadingHub.h"
#import <PooTools/IGHTTPClient.h>
#import <PooTools/IGBatchTaskManager.h>
#import <PooTools/PooPhoneBlock.h>
#import <XSpotLight/XSpotLight.h>
#import <AudioToolbox/AudioToolbox.h>

typedef void (^APIBlock)(BOOL success,NSMutableDictionary *infoDict);

typedef NS_ENUM(NSInteger,CGMainChartHalfYearType){
    CGMainChartHalfYearTypeFull = 0,
    CGMainChartHalfYearTypeFront,//1-6
    CGMainChartHalfYearTypeBack,//7-12
    CGMainChartHalfYearTypeEX,//当前月份+前五个月(半年)
    CGMainChartHalfYearTypeSeasonEX//当前月份+前2个月(季度)
};

typedef NS_ENUM(NSInteger,CGMainChartQuarterType){
    CGMainChartQuarterTypeQuarterFull = 0,
    CGMainChartQuarterTypeQuarter1,//1-3
    CGMainChartQuarterTypeQuarter2,//4-6
    CGMainChartQuarterTypeQuarter3,//7-9
    CGMainChartQuarterTypeQuarter4//10-12
};

typedef NS_ENUM(NSInteger,CGGetTimeType){
    CGGetTimeTypeYear = 0,
    CGGetTimeTypeSeason,
    CGGetTimeTypeHalfEX,
    CGGetTimeTypeSeasonEX
};

@class CGChartModel;
@class CGChartAndMonthsModel;

@interface ZAlertPlaySound : NSObject
{
    SystemSoundID sound;//系统声音的id 取值范围为：1000-2000
}

- (id)initSystemShake;//系统 震动
- (id)initSystemSoundWithName:(NSString *)soundName SoundType:(NSString *)soundType;//初始化系统声音
- (void)play;//播放
@end


@interface CGBaseGobalTools : NSObject

#pragma mark ---------------> AlertView
+(void)gobalCustomAlertWithCustomHeigh:(CGFloat)customH
                                showIn:(UIView *)showIn
                           withButtons:(NSArray *)btns
                               withTag:(NSInteger)tags
                             withTitle:(NSString *)title
                               setView:(YXCustomAlertViewSetCustomViewBlock)setViewBlock
                                 click:(YXCustomAlertViewClickBlock)clickBlock
                               dismiss:(YXCustomAlertViewDidDismissBlock)dismissBlock;

+(void)gobalFreakSystemAlertWithTitle:(NSString *)title
                          withMessage:(NSString *)message
                      withCancelTitle:(NSString *)cancelT
                          withOkTitle:(NSString *)okT
                             okHandle:(void (^)(void))okBlock
                         cencelHandle:(void (^)(void))cencelBlock;

+(void)gobalShowAlertTitle:(NSString *)title
                   message:(NSString *)message;

+(void)gobalShowHUDWithMessgae:(NSString *)message;

#pragma mark ---------------> PickerView
+(void)gobalNormalPickerTitle:(NSString *)title
                   pickerData:(NSArray <PTNormalPickerModel *>*)dataArr currentTitle:(NSString *)currentTitle
                tapBarBGColor:(UIColor *)tbColor
                   pickerFont:(UIFont *)font
                       handle:(PickerReturnBlock)pickerBlock;

#pragma mark ---------------> ActionSheet
+(void)gobalActionSheetTitles:(NSArray *)titles
                        title:(NSString *)title
                 titleMessage:(NSString *)message
                       handle:(ALActionSheetViewDidSelectButtonBlock)block;

#pragma mark ---------------> 图片浏览
+(void)gobalPhotoBrowserImages:(NSArray <PooShowImageModel*>*)appendArray
                     canDelete:(BOOL)deletes canSave:(BOOL)save
                      showMore:(BOOL)more
                    handleSave:(void (^)(BOOL saveStatus))saveBlock
                   handleOther:(YMShowImageViewShowOtherAction)otherBlock
                  handleDelete:(YMShowImageViewDidDeleted)deleteBlock
              handleShowFinish:(didRemoveImage)finishBlock imageIndex:(NSInteger)index;

#pragma mark ---------------> API
+(void)apiServeApiURL:(NSString *)apiURL
          withParmars:(NSMutableDictionary *)parmars
              hideHub:(BOOL)hide
               handle:(APIBlock)block;

+(void)customServerAddress:(NSURL*)serverAddress
              customApiURL:(NSString *)apiURL
               withParmars:(NSMutableDictionary *)parmars
                   hideHub:(BOOL)hide
                    handle:(APIBlock)block;

#pragma mark ------>图表相关
/*! @brief 设置图表的Yz轴最大值
 * @param maxString 最大值
 */
+(NSMutableArray *)createChartYLabelsArr:(NSString *)maxString;
/*! @brief 根据计算出来的type来返回半年的数据
 * @param type 半年的type
 */
+(NSMutableArray *)createChartXLabelDataHalfYearType:(CGMainChartHalfYearType)type;
/*! @brief 根据计算出来的type来返回季度的数据
 * @param type 季度的type
 */
+(NSMutableArray *)createChartXLabelDataQuarterType:(CGMainChartQuarterType)type;
/*! @brief 获取表图的单一种数据的model
 * @param dataArr 传入单一数据的数组
 */
+(CGChartModel *)dataModel:(NSArray *)dataArr;

#pragma mark ------>打电话
+(void)makeAPhoneCall:(NSString *)alertTitle
            withPhone:(NSString *)phone
          alertShowIn:(UIViewController *)vc;

#pragma mark ------>新手教程
+(void)viewControllerGuideViewWithTitles:(NSArray <NSString *>*)titles
                               withRects:(NSArray <NSValue *>*)rects
                                  showIn:(UIViewController *)vc;

#pragma mark ------>App完整连接
+(NSURL *)getImageFullUrlwithServerPartUrl:(NSString *)url;

#pragma mark ---------------> AssetsData
+(NSBundle *)cgBaseBundle;
+(UIColor *)color:(NSString *)name compatibleWithTraitCollection:(UITraitCollection *)traitCollection NS_AVAILABLE_IOS(11_0);
+(UIImage *)image:(NSString *)name compatibleWithTraitCollection:(UITraitCollection *)traitCollection;

+(NSString *)AppWhiteString;
+(UIColor *)AppWhite;

+(NSString *)AppBlackString;
+(UIColor *)AppBlack;

+(NSString *)AppBlueString;
+(UIColor *)AppBlue;

+(NSString *)AppOrangeString;
+(UIColor *)AppOrange;

+(NSString *)AppRedString;
+(UIColor *)AppRed;

+(NSString *)AppGrayString;
+(UIColor *)AppGray;

+(NSString *)AppSuperLightGrayString;
+(UIColor *)AppSuperLightGray;

+(NSString *)AppChartWater_String;
+(UIColor *)AppChartWater;

+(NSString *)AppChartPower_String;
+(UIColor *)AppChartPower;

+(NSString *)AppChartHouse_String;
+(UIColor *)AppChartHouse;

+(NSString *)AppChartNet_String;
+(UIColor *)AppChartNet;

+(NSString *)AppChartMan_String;
+(UIColor *)AppChartMan;

+(NSString *)AppChartCrosshairColor_String;

+(NSString *)AppTextBlack_String;
+(UIColor *)AppTextBlack;

+(NSString *)AppTextWhite_String;
+(UIColor *)AppTextWhite;

+(NSString *)AppCellBGColor_String;
+(UIColor *)AppCellBGColor;

+(NSString *)AppAlertButtonColor_String;
+(UIColor *)AppAlertButtonColor;

+(NSString *)AppTableBGColor_String;
+(UIColor *)AppTableBGColor;

+(UIColor *)AppColor;

+(NSString*)getBundleID;

+(UITableViewStyle)gobalTableStyle;

#pragma mark 提示音
+ (void)showVoice;

+(NSString *)httpsString;

+(NSString *)downLoadFileEX;

+(void)getEmbeddedInfo:(void (^)(BOOL isDevelopement,NSDictionary *embeddedInfo))block;

+(UIViewController *)getCurrentVC;
@end

@interface CGChartModel : NSObject
@property (nonatomic,strong) NSString *lastMonthStr;
@property (nonatomic,strong) NSString *currentMonthStr;
@property (nonatomic,strong) NSString *dataTotalStr;
@property (nonatomic,strong) NSString *fullYearChartMaxStr;

@property (nonatomic,strong) NSArray *dataHalf;
@property (nonatomic,strong) NSString *dataHalfTotalStr;
@property (nonatomic,strong) NSString *halfYearChartMaxStr;

@property (nonatomic,strong) NSArray *dataHalfEX;
@property (nonatomic,strong) NSString *dataHalfTotalStrEX;
@property (nonatomic,strong) NSString *halfYearChartMaxStrEX;

@property (nonatomic,strong) NSArray *dataSeason;
@property (nonatomic,strong) NSString *dataSeasonTotalStr;
@property (nonatomic,strong) NSString *SeasonChartMaxStr;

@property (nonatomic,strong) NSArray *dataSeasonEX;
@property (nonatomic,strong) NSString *dataSeasonTotalStrEX;
@property (nonatomic,strong) NSString *SeasonChartMaxStrEX;

@property (nonatomic,assign) NSInteger halfYearType;
@property (nonatomic,assign) NSInteger seasonType;
@end

@interface CGChartAndMonthsModel : NSObject
@property (nonatomic, strong) NSMutableArray *monthArr;
@property (nonatomic, strong) NSMutableArray *vauleArr;
@property (nonatomic, assign) NSInteger halfOrSeasonType;
@end


