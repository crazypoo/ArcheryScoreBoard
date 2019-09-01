//
//  PSignInWithApple.h
//  CloudGateCustom
//
//  Created by crazypoo on 2019/7/19.
//  Copyright © 2019 邓杰豪. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AuthenticationServices/AuthenticationServices.h>

NS_ASSUME_NONNULL_BEGIN

@interface AppleIDInfo : NSObject
/**
 苹果用户唯一标识符，该值在同一个开发者账号下的所有 App 下是一样的，开发者可以用该唯一标识符与自己后台系统的账号体系绑定起来
 */
@property (nonatomic, copy) NSString *userIdentifier;

/**
 苹果返回的该用户的状态
 */
@property (nonatomic, assign) ASUserDetectionStatus realUserStatus;

/**
 用户邮箱，注意这里用户可以选择隐藏自己的邮箱地址的，因此这个值不一定是真正的邮箱地址
 */
@property (nonatomic, copy) NSString *email;

/**
 token 给后台向苹果服务器验证使用
 */
@property (nonatomic, copy) NSString *token;

/**
 authorizationCodeString 给后台向苹果服务器验证使用 这个有时效性 五分钟之内有效
 */
@property (nonatomic, copy) NSString *authorizationCode;

/**
 givenName
 */
@property (nonatomic, copy) NSString *givenName;

/**
 familyName
 */
@property (nonatomic, copy) NSString *familyName;

/**
 是否是合法的用户
 */
- (BOOL)isVaildAppleUser;

@end

typedef void (^AppleIDChangeBlock)(NSString *msg);
typedef void (^AppleIDSignInDone)(AppleIDInfo *appleModel);
typedef void (^AppleIDSignInFailed)(void);
typedef void (^AppleIDModelBlock)(AppleIDInfo *appleModel);
typedef void (^ASPasswordCredentialBlock)(NSString *user,NSString *password);

@interface PSignInWithApple : NSObject
+ (instancetype)sharedInstance;

-(void)signInWithAppleID;

- (void)checkAppleSignFunc;

@property (nonatomic, strong) AppleIDInfo *appleUser;
@property (nonatomic,copy) AppleIDChangeBlock changeBlock;
@property (nonatomic,copy) AppleIDSignInDone signInBlock;
@property (nonatomic,copy) AppleIDSignInFailed failedBlock;
@property (nonatomic,copy) AppleIDModelBlock idModel;
@property (nonatomic,copy) ASPasswordCredentialBlock passwordCredentialBlock;
@end

NS_ASSUME_NONNULL_END
