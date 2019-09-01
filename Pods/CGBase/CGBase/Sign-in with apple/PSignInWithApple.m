//
//  PSignInWithApple.m
//  CloudGateCustom
//
//  Created by crazypoo on 2019/7/19.
//  Copyright © 2019 邓杰豪. All rights reserved.
//

#import "PSignInWithApple.h"
#import "CGBaseGobalTools.h"
#import "CGBaseMarcos.h"
#import <PooTools/PMacros.h>

@implementation AppleIDInfo

- (BOOL)isVaildAppleUser {
    if (_realUserStatus != ASUserDetectionStatusLikelyReal) {
        return NO;
    }
    
    if (!_token ||
        !_authorizationCode ||
        !_userIdentifier) {
        return NO;
    }
    
    return YES;
}

@end

@interface PSignInWithApple ()<ASAuthorizationControllerDelegate,ASAuthorizationControllerPresentationContextProviding>

@end

@implementation PSignInWithApple

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    __strong static id _sharedObject = nil;
    dispatch_once(&onceToken, ^{
        _sharedObject = [[self alloc] init];
    });
    return _sharedObject;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        if (@available(iOS 13.0, *))
        {
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleAppleIdHasChanged) name:ASAuthorizationAppleIDProviderCredentialRevokedNotification object:nil];
        }
        
        [self fetchLocalAppleUser];
    }
    
    return self;
}

#pragma mark - PrivateFunc

- (void)fetchLocalAppleUser
{
    //取出本地缓存的AppleID User Model
    if (self.idModel)
    {
        self.idModel(self.appleUser);
    }
}

#pragma mark - PublicFunc

- (void)checkAppleSignFunc
{
    if (@available(iOS 13.0, *)) {
        if (![_appleUser isVaildAppleUser]) {
            return;
        }
        
        ASAuthorizationAppleIDProvider *provider = [ASAuthorizationAppleIDProvider new];
        [provider getCredentialStateForUserID:_appleUser.userIdentifier completion:^(ASAuthorizationAppleIDProviderCredentialState credentialState, NSError * _Nullable error) {
            switch (credentialState) {
                case ASAuthorizationAppleIDProviderCredentialRevoked:
                    //用户重新登录了其他的apple id
                    [self handleAppleIdHasChanged];
                    break;
                case ASAuthorizationAppleIDProviderCredentialAuthorized:
                    //该userid apple id 登录状态良好
                    break;
                case ASAuthorizationAppleIDProviderCredentialNotFound:
                    [CGBaseGobalTools gobalShowAlertTitle:AlertNormalTitle message:@"Sign-in With Apple失败\n用户在设置-appleid header-密码与安全性-使用您 Apple ID的App 中将此应用禁止掉了"];
                    break;
                default:
                    
                    break;
            }
        }];
    }
}

- (void)handleAppleIdHasChanged
{
    self.changeBlock(@"因为你的apple id 发生了切换，需要重新登录");
}

- (void)configLocalAppleUserWith:(AppleIDInfo *)appleUser {
    _appleUser = appleUser;
}

- (void)saveLocalAppleUser {
    if (_appleUser) {
        //保存获取到的本地Apple ID User
        self.signInBlock(_appleUser);
    }
}


-(void)signInWithAppleID
{
    if (@available(iOS 13.0, *)) {
        ASAuthorizationAppleIDProvider *appleIDProvider = [ASAuthorizationAppleIDProvider new];
        ASAuthorizationAppleIDRequest *request = appleIDProvider.createRequest;
        [request setRequestedScopes:@[ASAuthorizationScopeFullName,ASAuthorizationScopeEmail]];
        
        //需要考虑已经登录过的用户，可以直接使用keychain密码来进行登录-这个很牛皮。。。
        ASAuthorizationPasswordProvider *appleIDPasswordProvider = [ASAuthorizationPasswordProvider new];
        ASAuthorizationPasswordRequest *passwordRequest = appleIDPasswordProvider.createRequest;
#if DEBUG
        PNSLog(@"passwordRequest:%@",passwordRequest);
#endif
        ASAuthorizationController *appleSignController = [[ASAuthorizationController alloc] initWithAuthorizationRequests:@[request]];
        appleSignController.delegate = self;
        appleSignController.presentationContextProvider = self;
        [appleSignController performRequests];
    }
}

#pragma mark ---------------> Sign-in With Apple Delegate
- (ASPresentationAnchor)presentationAnchorForAuthorizationController:(ASAuthorizationController *)controller  API_AVAILABLE(ios(13.0)){
    return kAppDelegateWindow.rootViewController.view.window;
}

- (void)authorizationController:(ASAuthorizationController *)controller didCompleteWithError:(NSError *)error  API_AVAILABLE(ios(13.0)){
    
    NSString *msg;
    switch (error.code) {
        case 1001:
            {
                msg = @"用户取消操作";
            }
            break;
        default:
        {
            msg = @"Sign-in With Apple失败";
        }
            break;
    }
    //Sign with Apple 失败
    [CGBaseGobalTools gobalShowAlertTitle:AlertNormalTitle message:msg];
    if (self.failedBlock)
    {
        self.failedBlock();
    }
}

- (void)authorizationController:(ASAuthorizationController *)controller didCompleteWithAuthorization:(ASAuthorization *)authorization API_AVAILABLE(ios(13.0))
{
    //Sign with Apple 成功
    if ([authorization.provider isKindOfClass:[ASAuthorizationPasswordProvider class]]) {
        //取的keychain中的用户名密码，这里可以直接登录了，然后返回正常的登录结果即可
        //此时并不是使用Sign with Apple
        ASPasswordCredential *passwordCredential = (ASPasswordCredential *)authorization.credential;
        if ([passwordCredential isKindOfClass:[ASPasswordCredential class]]) {
            NSString *userName = passwordCredential.user;
            NSString *password = passwordCredential.password;
            
            //直接使用邮箱登录
            if (self.passwordCredentialBlock)
            {
                self.passwordCredentialBlock(userName,password);
            }
            
        }
    }
    else if ([authorization.provider isKindOfClass:[ASAuthorizationAppleIDProvider class]]) {
        //此时为使用Sign With Apple 方式登录
        AppleIDInfo *user = [AppleIDInfo new];
        ASAuthorizationAppleIDCredential *credential = (ASAuthorizationAppleIDCredential *)authorization.credential;
        if ([credential isKindOfClass:[ASAuthorizationAppleIDCredential class]]) {
            NSString *tokenString = [[NSString alloc] initWithData:credential.identityToken encoding:NSUTF8StringEncoding];
            
            NSString *authorizationCodeString = [[NSString alloc] initWithData:credential.authorizationCode encoding:NSUTF8StringEncoding];
            
            NSString *userIdentifier = credential.user;
            NSString *email = credential.email;
            NSString *givenName = credential.fullName.givenName;
            NSString *familyName = credential.fullName.familyName;
            ASUserDetectionStatus realUserStatus = credential.realUserStatus;
            
            user.userIdentifier = userIdentifier;
            user.token = tokenString;
            user.authorizationCode = authorizationCodeString;
            user.email = email;
            user.realUserStatus = realUserStatus;
            user.givenName = givenName;
            user.familyName = familyName;
        }
        
        if ([user isVaildAppleUser])
        {
            //苹果返回的模型正确，可以进一步向后台进行登录行为
            //需要给后台传userIdentifier、token、authorizationCode
            [self configLocalAppleUserWith:user];
            [self saveLocalAppleUser];
        }
        else
        {
            //Sign with Apple 失败
            [CGBaseGobalTools gobalShowAlertTitle:AlertNormalTitle message:@"Sign-in With Apple失败"];
            if (self.failedBlock)
            {
                self.failedBlock();
            }
        }
    }
}

@end
