//
//  CGBaseMarcos.h
//  CGBase
//
//  Created by crazypoo on 2019/6/16.
//  Copyright © 2019 crazypoo. All rights reserved.
//

#import <PooTools/PMacros.h>

#ifndef CGBaseMarcos_h
#define CGBaseMarcos_h

#define kFontNormalKey @"FontNormal"
#define kFontNormalBoldKey @"FontNormalBold"

#define FontNameString @"HelveticaNeue-Light"
#define FontNameBoldString @"HelveticaNeue-Medium"

#define FontName kUserDefaultObjectForKey(kFontNormalKey)
#define FontNameBold kUserDefaultObjectForKey(kFontNormalBoldKey)

//
#pragma mark ---------------> Font
#define APPFONT(R) kDEFAULT_FONT(FontName,kAdaptedWidth(R))
#define APPFONTBOLD(R) kDEFAULT_FONT(FontNameBold,kAdaptedWidth(R))

//ps的字号转换
#define PSFont(x) kPSFontToiOSFont(x/2)

//App最小的字体
#define AppNavCoupleButton_SIZE (IS_IPAD ? kAdaptedWidth(PSFont(13.2)) : kAdaptedWidth(PSFont(33)))
#define AppNavCoupleButton APPFONT(AppNavCoupleButton_SIZE)
#define AppNavCoupleButton_BOLD APPFONTBOLD(AppNavCoupleButton_SIZE)

//App普通字体
#define AppFontNormal_SIZE (IS_IPAD ? kAdaptedWidth(PSFont(16)) : kAdaptedWidth(PSFont(40)))
#define AppFontNormal APPFONT(AppFontNormal_SIZE)
#define AppFontNormal_BOLD APPFONTBOLD(AppFontNormal_SIZE)

//大标题title字体
#define AppLargeTitleFont_SIZE (IS_IPAD ? kAdaptedWidth(PSFont(20.8)) : kAdaptedWidth(PSFont(52)))
#define AppLargeTitleFont APPFONT(AppLargeTitleFont_SIZE)
#define AppLargeTitleFont_BOLD APPFONTBOLD(AppLargeTitleFont_SIZE)

//特大字号,用在我的界面的用户名字
#define AppSuperLargeTitleFont_SIZE (IS_IPAD ? kAdaptedWidth(PSFont(32)) : kAdaptedWidth(PSFont(80)))
#define AppSuperLargeTitleFont APPFONT(AppSuperLargeTitleFont_SIZE)
#define AppSuperLargeTitleFont_BOLD APPFONTBOLD(AppSuperLargeTitleFont_SIZE)

#pragma mark ---------------> String
#define AppNullDataTapString @"点击屏幕尝试刷新"
#define AppNullDataImage [CGBaseGobalTools image:@"image_nulldata" compatibleWithTraitCollection:kAppDelegateWindow.rootViewController.traitCollection]
#define AppNullDataString @"本页无数据"

/*! @brief AlertView
 */
#define AlertNormalTitle @"提示"
#define AlertNormalOnlyCancel @"好的"
#define AlertNormalCancel @"取消"
#define AlertNormalConfirm @"确定"
#define AlertNormalDone @"完成"
#define AlertNormalUpload @"提交"
#define AlertNormalDelete @"删除"

//ActionSheet
#define ActionSheetMoreTitle @"更多操作"

//网络
#define AppNetWorkWIFI @"当前是wifi连接"
#define AppNetWorkMobile @"当前是移动数据连接"
#define AppNetWorkNo @"当前没有网络"

//AboutLogout
#define LOGOUTCODE @"1003"
#define LOGOUTMESSAGE @"您还没有登录或登录已超时请,重新登录"
#define LOGOUTOK @"去登录!"
#define LOGOUTCANCEL @"继续浏览"
#define LOGINTITLE @"登录"

//AboutSMS/Login
#define AppInputAccountPlaceholder @"请输入手机号"
#define AppGetSMSTitle @"获取验证码"

#define AppNetWorkError @"服务器正在维护中，敬请耐心等候"
#define AppDataError @"网络似乎出了点问题，请刷新再试"

#pragma mark ---------------> view's need float
#define LineHeigh 0.5
#define NavButonH 44
#define BackImageW 44
//按钮内图片与字体的间隙
#define BackBtnSpace 5
#define CustomAlertNormalSpace 10
//App按钮角的弧度
#define AppRadius 5
#define NullImageSize 150.f
#define NullLabelH 60.f
#define ButtonH 44.f
#define TextViewH 44.f
#define GobalViewAndViewSpace 10.f
#define GetMessageBtnW 100.f
//导航栏的高度(不带Status高度)
#define NavigationBarAddHeight 54
//导航栏的高度(用于我的界面)
#define MyViewControllerNavHeight NavigationBarAddHeight
//App所用的导航栏高度
#define NavigationBarNormalHeight (NavigationBarAddHeight+HEIGHT_STATUS)
//Cell头部高度
#define CellHeaderHeigh CellHeight/2
//Cell头部间隙
#define CellHeaderHeighSpace 2.5
//箭头大小
#define RightArrowWH 11

//6SPPoint
#define iPhone6SPViewPointW 414
#define iPhone6SPViewPointH 736

#define ViewScale (kSCREEN_WIDTH/iPhone6SPViewPointW)
//App的间隙
#define ViewSpace PSViewPointToiOSViewPoint(77)*ViewScale
//ps的像素转换
#define PSViewPointToiOSViewPoint(x) (x/3)

//Appcell的通用高度
#define CellHeight PSViewPointToiOSViewPoint(230)*ViewScale

#pragma mark ---------------> key
#define kIP @"ip_address"
//UserSetLocation
#define kUserSetLocation @"kUserSetLocation"
//AppStartAdModel
#define kAppStartAdModel @"AppStartAdModel"

#pragma mark ---------------> Data
#define ERRORMESSAGE infoDict[@"message"]
#define GETDATAFALSE [infoDict[@"result"] isEqualToString:@"false"]
#define GETDATATRUE [infoDict[@"result"] isEqualToString:@"true"]
#define GETDATAJSONARR infoDict[@"viewData"]

#pragma mark ---------------> Time
//数据流超时时间
#define UploadSteamTimeOut 15
//自定义动画时间
#define CustomAnimationTime 0.6f

//短信获取cd
#define kGetSMSTime 60

//客服电话
#define CustomerServiceTelephone @"18924025601"
#define CustomerServiceMail @"cloudgategz@163.com"

#endif /* CGBaseMarcos_h */
