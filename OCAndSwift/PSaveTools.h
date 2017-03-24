//
//  PSaveTools.h
//  Archery Score
//
//  Created by 邓杰豪 on 2017/3/24.
//  Copyright © 2017年 邓杰豪. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PSaveTools : NSObject
+(void)saveToScoreHistory:(UIImage *)image;
+(void)saveScrollView:(UITableView *)tbView;
@end
