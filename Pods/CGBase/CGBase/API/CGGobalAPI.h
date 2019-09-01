//
//  CGGobalAPI.h
//  CGBase_Example
//
//  Created by crazypoo on 2019/6/17.
//  Copyright © 2019 crazypoo. All rights reserved.
//

#import "CGBaseMarcos.h"

#ifndef CGGobalAPI_h
#define CGGobalAPI_h
#if DEBUG
#define REQUEST_BASE_URL kUserDefaultObjectForKey(kIP)
#else
#define REQUEST_BASE_URL @"www.cloudgategz.com"
#endif

//协议
#define PrivacyURL @"/chl/reult/rule2.html"
#define Agreement @"/chl/reult/rule3.html"
#define PrivacyURLLandLoard @"/chl/reult/ruleLan.html"

//一键反馈
#define Feedback @"/chl/propelling/feedbackProblem"

//上传日志
#define UploadAppHistory @"/api/wx/small/upIosFileTxt"
//Ad
#define StarAD @"/chl/enteringAdver/findFirstPic"

#define kHttps @"kHttps"

#endif /* CGGobalAPI_h */
