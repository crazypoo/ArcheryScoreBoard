//
//  PShareView.h
//  CloudGateCustom
//
//  Created by 邓杰豪 on 2019/3/17.
//  Copyright © 2019年 邓杰豪. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ShareViewBlock)(NSString *shareContent,UIImage *shareImage,NSURL *shareURL,NSString *shareTitle,NSString *shareBtnTitle);
typedef void (^ShareViewDismissBlock)(void);

@interface PShareView : UIView
-(instancetype)initWithShareLink:(NSURL *)shareURL
                withShareContent:(NSString *)shareContent
                  withShareImage:(id)shareImage
                  withShareTitle:(NSString *)shareTitle
                handleShareBlock:(ShareViewBlock)viewShareBolck
               handleCancelBlock:(ShareViewDismissBlock)cancelBlock;
-(void)shareViewShow;
@end
