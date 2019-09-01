//
//  CGAppDataDownLoadView.m
//  LandloardTool
//
//  Created by crazypoo on 2019/8/1.
//  Copyright © 2019 邓杰豪. All rights reserved.
//

#import "CGAppDataDownLoadView.h"

#import <PooTools/IGFileDownLoadManager.h>
#import <SSZipArchive/SSZipArchive.h>
#import <PooTools/YMShowImageView.h>
#import <PooTools/PMacros.h>
#import <Masonry/Masonry.h>

#import "CGBaseGobalTools.h"
#import "CGBaseMarcos.h"
#import "CGGobalAPI.h"

//InitApp
#define LOGINVIDEONAME @"loginVideo"
#define INITAPPVIDEO @"正在加载登录视频"
#define INITAPPSTARTIMAGE @"正在加载启动图片"

typedef void (^GetAppFile)(NSString *loginVideoFile,NSString *AppStartInfoFile,NSString *TapTuneFile);
typedef void (^GetAppFileMany)(BOOL success);

@interface CGAppDataDownLoadView ()
@property (nonatomic, strong)UILabel *loadingLabel;
@property (nonatomic ,strong) HZWaitingView *waitingView;
@property (nonatomic, strong) NSString *videoPathLoadData;
@property (nonatomic, strong) NSString *firstUsePath;
@property (nonatomic, strong) NSString *tapTunePath;
@property (nonatomic, copy) ViewDoneBlock doneBlock;
@property (nonatomic, strong) NSMutableDictionary *apiDic;
@end

@implementation CGAppDataDownLoadView

+(NSString *)videoPath
{
    NSString *pathDocuments = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    return [NSString stringWithFormat:@"%@/VideoPath/%@", pathDocuments,[NSString stringWithFormat:@"%@%@.mp4",LOGINVIDEONAME,[CGBaseGobalTools downLoadFileEX]]];
}

-(instancetype)initWithAppIsFirsUse:(BOOL)isFirst withApiBaseDic:(NSMutableDictionary *)apiBaseDic handle:(ViewDoneBlock)block;
{
    self = [super init];
    if (self)
    {
        self.apiDic = apiBaseDic;
        
        NSFileManager *fileManager = [[NSFileManager alloc] init];
        NSString *pathDocuments = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        self.videoPathLoadData    = [NSString stringWithFormat:@"%@/VideoPath/", pathDocuments];
        self.firstUsePath = [NSString stringWithFormat:@"%@/FirstUsePath/", pathDocuments];
        self.tapTunePath  = [NSString stringWithFormat:@"%@/TapTunePath/", pathDocuments];
        if (![[NSFileManager defaultManager] fileExistsAtPath:[CGAppDataDownLoadView videoPath]]) {
            [fileManager createDirectoryAtPath:[CGAppDataDownLoadView videoPath] withIntermediateDirectories:YES attributes:nil error:nil];
        }
        if (![[NSFileManager defaultManager] fileExistsAtPath:self.firstUsePath])
        {
            [fileManager createDirectoryAtPath:self.firstUsePath withIntermediateDirectories:YES attributes:nil error:nil];
        }
        if (![[NSFileManager defaultManager] fileExistsAtPath:self.tapTunePath])
        {
            [fileManager createDirectoryAtPath:self.tapTunePath withIntermediateDirectories:YES attributes:nil error:nil];
        }
        
        NSString *filePath = [[CGAppDataDownLoadView videoPath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%@.mp4",LOGINVIDEONAME,[CGBaseGobalTools downLoadFileEX]]];

#if DEBUG
        [self createDownLoadView];
#endif
        if (isFirst)
        {
            [self createDownLoadView];
        }
        else
        {
            if ([fileManager fileExistsAtPath:filePath])
            {
                [self createDownLoadView];
            }
        }
        
        self.doneBlock = block;
    }
    return self;
}

-(void)createDownLoadView
{
    self.loadingLabel = [UILabel new];
    self.loadingLabel.textColor = [CGBaseGobalTools AppGray];
    self.loadingLabel.font = AppNavCoupleButton_BOLD;
    self.loadingLabel.textAlignment = NSTextAlignmentCenter;
    self.loadingLabel.numberOfLines = 0;
    self.loadingLabel.lineBreakMode = NSLineBreakByCharWrapping;
    [self addSubview:self.loadingLabel];

//    kWeakSelf(self);
    [self getAppInitData:^(BOOL success) {
        self.doneBlock(self,success);
    }];
}

-(void)getAppInitData:(void (^)(BOOL success))allComplete
{
    //    self.retry.hidden = YES;
    [self getADWithHandle:^(NSString *loginVideoFile,NSString *AppStartInfoFile,NSString *TapTuneFile) {
        [self loadVideoURL:loginVideoFile withVideoPath:self.videoPathLoadData loadWhat:INITAPPVIDEO handle:^(BOOL success) {
            if (success) {
                [self loadVideoURL:AppStartInfoFile withVideoPath:self.firstUsePath loadWhat:@"正在加载欢迎页面" handle:^(BOOL AppStartInfoSuccess) {
                    if (AppStartInfoSuccess) {
                        [self loadVideoURL:TapTuneFile withVideoPath:self.tapTunePath loadWhat:@"正在加载按键声音" handle:^(BOOL TapTuneSuccess) {
                            if (TapTuneSuccess) {
                                [self releaseZipFilesWithUnzipFileAtPath:[NSString stringWithFormat:@"%@AppStartInfo%@.zip",self.firstUsePath,[CGBaseGobalTools downLoadFileEX]] Destination:self.firstUsePath unzipAction:@"App欢迎图片"  completionHandler:^(BOOL unzipAndDeleteFileDone) {
                                    if (unzipAndDeleteFileDone) {
                                        [self releaseZipFilesWithUnzipFileAtPath:[NSString stringWithFormat:@"%@Taptune.zip",self.tapTunePath] Destination:self.tapTunePath unzipAction:@"按键音" completionHandler:^(BOOL unzipTapTune) {
                                            if (unzipTapTune) {
                                                allComplete(YES);
                                            }
                                        }];
                                    }
                                    else
                                    {
                                        [self createDownLoadView];
                                        return;
                                    }
                                }];
                            }
                            else
                            {
                                [self createDownLoadView];
                                return;
                            }
                        }];
                    }
                    else
                    {
                        [self createDownLoadView];
                        return;
                    }
                }];
            }
            else
            {
                [self createDownLoadView];
                return;
            }
        }];
    }];
}

#pragma mark ------> API
- (void)getADWithHandle:(GetAppFile)block
{
    NSMutableDictionary *dic = self.apiDic;
    [dic setObject:@"true" forKey:@"isLogin"];
    
    [CGBaseGobalTools apiServeApiURL:StarAD withParmars:dic hideHub:YES handle:^(BOOL success, NSMutableDictionary *infoDict) {
        if (success) {
            if (GETDATAFALSE) {
                //                self.retry.hidden = NO;
                [self createDownLoadView];
                [CGBaseGobalTools gobalShowHUDWithMessgae:ERRORMESSAGE];
            }
            else
            {
                NSArray *jobList = infoDict[@"viewData"];
                if (jobList && [jobList isKindOfClass:[NSArray class]])
                {
                    kUserDefaultSetObjectForKey(jobList, kAppStartAdModel);
                }
                NSString *videoString = [CGBaseGobalTools getImageFullUrlwithServerPartUrl:infoDict[@"LoginVideo"]].description;
                NSString *AppStartString = [CGBaseGobalTools getImageFullUrlwithServerPartUrl:infoDict[@"AppStartInfo"]].description;
                NSString *TaptuneString = [CGBaseGobalTools getImageFullUrlwithServerPartUrl:infoDict[@"TapTone"]].description;
                block(videoString,AppStartString,TaptuneString);
            }
        }
        else
        {
            //            self.retry.hidden = NO;
            [self createDownLoadView];
            PNSLog(@">>>>>>>>>>>>>服务器可能失败了");
        }
    }];
}

-(void)loadVideoURL:(NSString *)urlString withVideoPath:(NSString *)videoPath loadWhat:(NSString *)what handle:(GetAppFileMany)block
{
    kShowNetworkActivityIndicator();

    [self createWaitingView];
    
    [IGFileDownLoadManager fileDownloadWithUrl:urlString withFileSavePath:videoPath withTimeOut:15 progress:^(NSProgress * _Nonnull downloadProgress) {
        self.waitingView.progress = downloadProgress.fractionCompleted;
        self.loadingLabel.text = what;
        if (downloadProgress.fractionCompleted >= 1) {
            self.loadingLabel.hidden = YES;
        }
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        if (!error)
        {
            [self.waitingView removeFromSuperview];
            self.waitingView = nil;
            self.loadingLabel.hidden = YES;
            
            block(YES);
        }
        else
        {
            block(NO);
        }
    }];
}

- (void)releaseZipFilesWithUnzipFileAtPath:(NSString *)zipPath Destination:(NSString *)unzipPath unzipAction:(NSString *)unzipString completionHandler:(void (^)(BOOL unzipAndDeleteFileDone))completion
{
    NSString *destinationPath = unzipPath;
    [self createWaitingView];
    
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    //    ------------ 带回调的解压    ------------
    [SSZipArchive unzipFileAtPath:zipPath toDestination:destinationPath progressHandler:^(NSString * _Nonnull entry, unz_file_info zipInfo, long entryNumber, long total) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.waitingView.progress = entryNumber/total;
            self.loadingLabel.text = [NSString stringWithFormat:@"正在解压%@:%@",unzipString,entry];
            if (self.waitingView.progress >= 1) {
                self.loadingLabel.hidden = YES;
            }
        });
    } completionHandler:^(NSString * _Nonnull path, BOOL succeeded, NSError * _Nullable error) {
        //path : 被解压的压缩吧全路径
        //succeeded 是否成功
        // error 错误信息
        if (!error)
        {
            [self.waitingView removeFromSuperview];
            self.waitingView = nil;
            self.loadingLabel.hidden = YES;
            NSError *zipError;
            if ([fileManager removeItemAtPath:zipPath error:&zipError])
            {
                completion(YES);
            }
            else
            {
                completion(NO);
            }
        }
    }];
}

-(void)createWaitingView
{
    if (!self.waitingView)
    {
        self.waitingView = [[HZWaitingView alloc] init];
        self.waitingView.mode = HZWaitingViewModePieDiagram;
        [self addSubview:self.waitingView];
        [self.waitingView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.offset(68);
            make.centerX.equalTo(self);
            make.top.equalTo(self);
        }];
        
        self.loadingLabel.hidden = NO;
        [self.loadingLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.left.equalTo(self);
            make.height.offset(AppNavCoupleButton_SIZE*2+10);
            make.top.equalTo(self.waitingView.mas_bottom);
        }];
    }
}

@end
