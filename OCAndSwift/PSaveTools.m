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
    ALAssetsLibrary *libary = [ALAssetsLibrary new];
    NSString *plistPath = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/History/%@-统计.png",[self createCurrentTime]]];
    UIImage *image = [tbView screenshot];
    NSData *myData = UIImagePNGRepresentation(image);
    [myData writeToFile:plistPath atomically:YES];
    [libary writeImageDataToSavedPhotosAlbum:myData metadata:nil completionBlock:^(NSURL *assetURL, NSError *error) {
        
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
