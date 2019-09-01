//
//  UIViewController+HXPhotoEX.h
//  CloudGateCustom
//
//  Created by mouth on 2018/5/10.
//  Copyright © 2018年 邓杰豪. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CGPhotoEXViewController.h"
#import <HXWeiboPhotoPicker/HXCustomCameraViewController.h>
#import <HXWeiboPhotoPicker/HXCustomNavigationController.h>
#import <HXWeiboPhotoPicker/HXDatePhotoToolManager.h>

@interface UIViewController (HXPhotoEX)
-(void)photoEXWithManager:(HXPhotoManager *)manager wihtToolManager:(HXDatePhotoToolManager *)toolMamager handleImages:(void (^)(NSArray<NSURL *> *photoURL,NSArray<UIImage *> *imageList,BOOL original))imageBlock handleCancel:(HXAlbumListViewControllerDidCancelBlock)cancelBlock failed:(void(^)(NSUInteger failedLevel))failedBlock;

-(void)workerPhotoEXWithManager:(HXPhotoManager *)manager
                wihtToolManager:(HXDatePhotoToolManager *)toolMamager
                   handleImages:(void (^)(NSArray<HXPhotoModel *> *photoList,NSArray<NSURL *> *photoURL,NSArray<UIImage *> *imageList,BOOL original))imageBlock
                   handleCancel:(HXAlbumListViewControllerDidCancelBlock)cancelBlock
                         failed:(void(^)(NSUInteger failedLevel))failedBlock;
@end
