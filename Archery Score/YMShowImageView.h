//
//  YMShowImageView.h
//  WFCoretext
//
//  Created by 阿虎 on 14/11/3.
//  Copyright (c) 2014年 tigerwf. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YMShowImageView;

#define YMShowImageViewClickTagAppend 9999

typedef void(^didRemoveImage)(void);
typedef void(^YMShowImageViewDidDeleted) (YMShowImageView *siv,NSInteger index);

@interface YMShowImageView : UIView<UIScrollViewDelegate>{
    UIImageView *showImage;
}

@property (nonatomic,copy) didRemoveImage removeImg;
@property (nonatomic,copy) YMShowImageViewDidDeleted didDeleted;

- (void)showWithFinish:(didRemoveImage)tempBlock;

- (void)show:(UIView *)bgView didFinish:(didRemoveImage)tempBlock;

- (id)initWithFrame:(CGRect)frame byClick:(NSInteger)clickTag appendArray:(NSArray *)appendArray ;
- (id)initWithFrame:(CGRect)frame byClick:(NSInteger)clickTag appendArray:(NSArray *)appendArray deleteAble:(BOOL)canDelete;
- (id)initWithFrame:(CGRect)frame byClick:(NSInteger)clickTag appendArray:(NSArray *)appendArray imageTitleArray:(NSArray *)ita imageInfoArray:(NSArray *)iia;
- (id)initWithFrame:(CGRect)frame byClick:(NSInteger)clickTag appendArray:(NSArray *)appendArray imageTitleArray:(NSArray *)ita imageInfoArray:(NSArray *)iia deleteAble:(BOOL)canDelete;
@end
