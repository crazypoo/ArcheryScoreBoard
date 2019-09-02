//
//  PSaveTools.m
//  Archery Score
//
//  Created by 邓杰豪 on 2017/3/24.
//  Copyright © 2017年 邓杰豪. All rights reserved.
//

#import "PSaveTools.h"
#import <DHSmartScreenshot/UITableView+DHSmartScreenshot.h>
#import <AssetsLibrary/AssetsLibrary.h>

@implementation PSaveTools

+(void)saveToScoreHistory:(UIImage *)image
{
    NSString *plistPath = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/History/%@.png",[self createCurrentTime]]];
    
    NSData *myData = UIImagePNGRepresentation(image);
    [myData writeToFile:plistPath atomically:YES];
}

+(void)saveScrollView:(UITableView *)tbView
{
    NSString *plistPath = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/History/%@-统计.png",[self createCurrentTime]]];
    UIImage *image = [tbView screenshot];
    NSData *myData = UIImagePNGRepresentation(image);
    [myData writeToFile:plistPath atomically:YES];

    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        [PHAssetChangeRequest creationRequestForAssetFromImage:image];
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        if (!error && success)
        {
            PNSLog(@"保存相册成功!");
        }
        else
        {
            PNSLog(@"保存相册失败! :%@",error);
        }
    }];
}

#pragma mark ---------------> 获取当前时间
+(NSString *)createCurrentTime
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:[NSString stringWithFormat:@"%@", @"yyyy-MM-dd HH:MM:ss"]];
    NSString *currentDate = [dateFormatter stringFromDate:[NSDate date]];
    return currentDate;
}

@end
