//
//  UIViewController+HXPhotoEX.m
//  CloudGateCustom
//
//  Created by mouth on 2018/5/10.
//  Copyright © 2018年 邓杰豪. All rights reserved.
//

#import "UIViewController+HXPhotoEX.h"

@implementation UIViewController (HXPhotoEX)

-(void)photoEXWithManager:(HXPhotoManager *)manager wihtToolManager:(HXDatePhotoToolManager *)toolMamager handleImages:(void (^)(NSArray<NSURL *> *photoURL,NSArray<UIImage *> *imageList,BOOL original))imageBlock handleCancel:(HXAlbumListViewControllerDidCancelBlock)cancelBlock failed:(void(^)(NSUInteger failedLevel))failedBlock
{
    CGPhotoEXViewController *vc = [[CGPhotoEXViewController alloc] init];
    vc.manager = manager;
    vc.doneBlock = ^(NSArray<HXPhotoModel *> *allList, NSArray<HXPhotoModel *> *photoList, NSArray<HXPhotoModel *> *videoList, BOOL original, HXAlbumListViewController *viewController) {
        [toolMamager writeSelectModelListToTempPathWithList:photoList success:^(NSArray<NSURL *> *allURL, NSArray<NSURL *> *photoURL, NSArray<NSURL *> *videoURL) {
            [toolMamager getSelectedImageList:photoList requestType:original success:^(NSArray<UIImage *> *imageList) {
                imageBlock(photoURL,imageList,original);
            } failed:^{
                failedBlock(1);
            }];
        } failed:^{
            failedBlock(0);
        }];
    };
    vc.cancelBlock = cancelBlock;
    HXCustomNavigationController *nav = [[HXCustomNavigationController alloc] initWithRootViewController:vc];
    nav.supportRotation = manager.configuration.supportRotation;
    nav.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:nav animated:YES completion:nil];
}

-(void)workerPhotoEXWithManager:(HXPhotoManager *)manager
                wihtToolManager:(HXDatePhotoToolManager *)toolMamager
                   handleImages:(void (^)(NSArray<HXPhotoModel *> *photoList,NSArray<NSURL *> *photoURL,NSArray<UIImage *> *imageList,BOOL original))imageBlock
                   handleCancel:(HXAlbumListViewControllerDidCancelBlock)cancelBlock
                         failed:(void(^)(NSUInteger failedLevel))failedBlock
{
    CGPhotoEXViewController *vc = [[CGPhotoEXViewController alloc] init];
    vc.manager = manager;
    vc.doneBlock = ^(NSArray<HXPhotoModel *> *allList, NSArray<HXPhotoModel *> *photoList, NSArray<HXPhotoModel *> *videoList, BOOL original, HXAlbumListViewController *viewController) {
        [toolMamager writeSelectModelListToTempPathWithList:photoList success:^(NSArray<NSURL *> *allURL, NSArray<NSURL *> *photoURL, NSArray<NSURL *> *videoURL) {
            [toolMamager getSelectedImageList:photoList requestType:original success:^(NSArray<UIImage *> *imageList) {
                imageBlock(photoList,photoURL,imageList,original);
            } failed:^{
                failedBlock(1);
            }];
        } failed:^{
            failedBlock(0);
        }];
    };
    vc.cancelBlock = cancelBlock;
    HXCustomNavigationController *nav = [[HXCustomNavigationController alloc] initWithRootViewController:vc];
    nav.supportRotation = manager.configuration.supportRotation;
    nav.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:nav animated:YES completion:nil];
}
@end
