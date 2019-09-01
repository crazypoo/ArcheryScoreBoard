//
//  YZLogFile.m
//  YZMonitorRunLoopDemo
//
//  Created by eagle on 2019/6/18.
//  Copyright © 2019 yongzhen. All rights reserved.
//

#import "YZLogFile.h"
#import <SSZipArchive/SSZipArchive.h>
#import "YZAppInfoUtil.h"
#import <PooTools/PTUploadDataSteamTools.h>
#import "CGGobalAPI.h"
#import "CGBaseGobalTools.h"

static const float DefaultMAXLogFileLength = 50;
@implementation YZLogFile
#pragma mark -  日志模块
+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static YZLogFile *cls;
    dispatch_once(&onceToken, ^{
        cls = [[[self class] alloc] init];
    });
    return cls;
}

-(NSString *)getLogPath{
    NSArray *paths  = NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask,YES);
    NSString *homePath = [paths objectAtIndex:0];
    
    NSString *filePath = [homePath stringByAppendingPathComponent:@"Caton.log"];
    return filePath;
}

-(NSString *)getLogZipPath{
    NSFileManager *myFileManager = [NSFileManager defaultManager];
    NSString *cachesDirectory = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *zipPath = [NSString stringWithFormat:@"%@/Caton.zip",cachesDirectory];
    [myFileManager removeItemAtPath:zipPath error:nil];
    return zipPath;
}

- (void)writefile:(NSString *)string withAPIBase:(NSMutableDictionary *)apiBase
{
    self.apiBase = apiBase;
    NSString *filePath = [self getLogPath];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if(![fileManager fileExistsAtPath:filePath]) //如果不存在
    {
        NSString *str = @"卡顿日志";
        NSString *systemVersion = [NSString stringWithFormat:@"手机版本: %@",[YZAppInfoUtil iphoneSystemVersion]];
        NSString *iphoneType = [NSString stringWithFormat:@"手机型号: %@",[YZAppInfoUtil iphoneType]];
        str = [NSString stringWithFormat:@"%@\n%@\n%@",str,systemVersion,iphoneType];
        [str writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
        
    }
    else
    {
        float filesize = -1.0;
        if ([fileManager fileExistsAtPath:filePath]) {
            NSDictionary *fileDic = [fileManager attributesOfItemAtPath:filePath error:nil];
            unsigned long long size = [[fileDic objectForKey:NSFileSize] longLongValue];
            filesize = 1.0 * size / 1024;
        }
        
        PNSLog(@"文件大小 filesize = %lf",filesize);
        PNSLog(@"文件内容 %@",string);
        PNSLog(@" ---------------------------------");
        
        if (filesize > (self.MAXFileLength > 0 ? self.MAXFileLength:DefaultMAXLogFileLength)) {
            // 上传到服务器
            PNSLog(@" 上传到服务器");
            [self writeToLocalLogFilePath:filePath contentStr:string];
            if (self.canUploadBlock)
            {
                self.canUploadBlock(YES);
            }
            else
            {
                [self update];
            }
        }
        else
        {
            PNSLog(@"继续写入本地");
            if (self.canUploadBlock)
            {
                self.canUploadBlock(NO);
            }
            [self writeToLocalLogFilePath:filePath contentStr:string];
        }
    }
    
}

-(void)writeToLocalLogFilePath:(NSString *)localFilePath contentStr:(NSString *)contentStr{
    
    NSFileHandle *fileHandle = [NSFileHandle fileHandleForUpdatingAtPath:localFilePath];
    
    [fileHandle seekToEndOfFile];  //将节点跳到文件的末尾
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *datestr = [dateFormatter stringFromDate:[NSDate date]];
    
    NSString *str = [NSString stringWithFormat:@"\n%@\n%@",datestr,contentStr];
    
    NSData* stringData  = [str dataUsingEncoding:NSUTF8StringEncoding];
    
    [fileHandle writeData:stringData]; //追加写入数据
    
    [fileHandle closeFile];
}

-(BOOL)clearLocalLogFile{
    NSFileManager *myFileManager = [NSFileManager defaultManager];
    return [myFileManager removeItemAtPath:[self getLogPath] error:nil];
    
}

-(BOOL)clearLocalLogZipFile{
    NSFileManager *myFileManager = [NSFileManager defaultManager];
    return [myFileManager removeItemAtPath:[self getLogZipPath] error:nil];
    
}

-(BOOL)clearLocalLogZipAndLogFile{
    return [self clearLocalLogFile] && [self clearLocalLogZipFile];
    
}

// 上传日志
-(void)update
{
    NSString *zipPath = [self getLogZipPath];
    NSString *password = nil;
    NSMutableArray *filePaths = [[NSMutableArray alloc] init];
    [filePaths addObject:[self getLogPath]];
    BOOL success = [SSZipArchive createZipFileAtPath:zipPath withFilesAtPaths:filePaths withPassword:password.length > 0 ? password : nil];
    
    if (success)
    {
        [self.apiBase setObject:@"true" forKey:@"isLogin"];
        
        PTUploadDataModel *uploadModel = [PTUploadDataModel new];
        uploadModel.uploadImage = nil;
        uploadModel.imageType = CGUploadTypeZIPFILE;
        uploadModel.imageName = [zipPath pathExtension];
        uploadModel.imageData = [NSData dataWithContentsOfFile:zipPath];
        uploadModel.imageDataName = @"file";

        [[PTUploadDataSteamTools sharedInstance] uploadComboDataSteamProgressInView:nil withParameters:self.apiBase withServerAddress:[NSString stringWithFormat:@"%@://%@%@",[CGBaseGobalTools httpsString],REQUEST_BASE_URL,UploadAppHistory] imageArray:@[uploadModel] timeOut:15 success:^(NSDictionary * _Nonnull result) {
            PNSLog(@"上传成功");
            [self clearLocalLogFile];
        } failure:^(NSError * _Nonnull error) {
            PNSLog(@"上传失败");
        }];
    }
    else
    {
        PNSLog(@"压缩失败");
    }
}

@end
