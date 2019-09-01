//
//  PShareView.m
//  CloudGateCustom
//
//  Created by 邓杰豪 on 2019/3/17.
//  Copyright © 2019年 邓杰豪. All rights reserved.
//

#import "PShareView.h"

#import "zhImageButton.h"

#import <pop/POP.h>
#import <PooTools/PMacros.h>
#import <PooTools/UIButton+Block.h>
#import <Masonry/Masonry.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "CGBaseMarcos.h"
#import "CGBaseGobalTools.h"

@interface PShareView ()
@property (nonatomic,strong)NSURL *sURL;
@property (nonatomic,strong)NSString *sContent;
@property (nonatomic,strong)NSString *sTitle;
@property (nonatomic,strong)id sshareImage;
@property (nonatomic,strong)UIView *actionSheetView;
@property (nonatomic,strong)UIView *shareImageMask;
@property (nonatomic,assign)CGFloat actionSheetH;
@property (nonatomic,strong)UIImage *shareImage;
@property (nonatomic,copy) ShareViewBlock viewShareBolck;
@property (nonatomic,copy) ShareViewDismissBlock viewCancelBlock;
@property (nonatomic,strong)UIView *imageBG;
@property (nonatomic,strong)UIImageView *shareImageView;
@end

@implementation PShareView

-(NSArray *)shareTitle
{
    NSMutableArray *titleArr = [NSMutableArray array];
    [titleArr addObject:@"微博"];
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"wechat://"]] ) {
        [titleArr addObject:@"微信"];
    }
    
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"mqqapi://"]] ) {
        [titleArr addObject:@"QQ"];
    }
    
    [titleArr addObject:@"短信"];
    [titleArr addObject:@"复制"];
    return [titleArr copy];
}

-(NSArray *)shareImages
{
    NSMutableArray *imageArr = [NSMutableArray array];
    [imageArr addObject:@"image_share_weibo"];
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"wechat://"]] ) {
        [imageArr addObject:@"image_share_wechat"];
    }
    
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"mqqapi://"]] ) {
        [imageArr addObject:@"image_share_qq"];
    }
    [imageArr addObject:@"image_share_message"];
    [imageArr addObject:@"image_share_copy"];
    return [imageArr copy];
}

-(instancetype)initWithShareLink:(NSURL *)shareURL
                withShareContent:(NSString *)shareContent
                  withShareImage:(id)shareImage
                  withShareTitle:(NSString *)shareTitle
                handleShareBlock:(ShareViewBlock)viewShareBolck
               handleCancelBlock:(ShareViewDismissBlock)cancelBlock
{
    self = [super init];
    if (self)
    {
        self.viewShareBolck = viewShareBolck;
        self.viewCancelBlock = cancelBlock;
        self.sURL = shareURL;
        self.sContent = shareContent;
        self.sshareImage = shareImage;
        self.sTitle = shareTitle;
    }
    return self;
}

-(void)shareViewShow
{
    self.backgroundColor = kDevMaskBackgroundColor;
    [kAppDelegateWindow addSubview:self];
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(kAppDelegateWindow);
    }];
    
    self.actionSheetH = ButtonH+5+ButtonH*2;
    self.actionSheetView = [UIView new];
    [self addSubview:self.actionSheetView];
    [self.actionSheetView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.height.offset(self.actionSheetH);
        make.bottom.equalTo(self).offset(-HEIGHT_TABBAR_SAFEAREA);
    }];
    
    self.imageBG = [UIView new];
    [self addSubview:self.imageBG];
    [self.imageBG mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self);
        make.bottom.equalTo(self.actionSheetView.mas_top);
    }];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideViewAction:)];
    tapGesture.numberOfTapsRequired    = 1;
    [self addGestureRecognizer:tapGesture];
    
    self.shareImage = [CGBaseGobalTools image:@"image_ad_loading" compatibleWithTraitCollection:kAppDelegateWindow.rootViewController.traitCollection];
    
    CGFloat imageMaskW = kSCREEN_WIDTH - ViewSpace*4;
    CGFloat imageScale = (imageMaskW -20)/self.shareImage.size.width;
    CGFloat imageMaskH = imageScale * self.shareImage.size.height;

    self.shareImageMask = [UIView new];
    self.shareImageMask.backgroundColor = [CGBaseGobalTools AppCellBGColor];
    [self.imageBG addSubview:self.shareImageMask];
    [self.shareImageMask mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.centerX.equalTo(self);
        make.width.offset(imageMaskW);
        make.height.offset(imageMaskH);
    }];
    kViewBorderRadius(self.shareImageMask, AppRadius, 0, kClearColor);
    
    self.shareImageView = [UIImageView new];
    self.shareImageView.image = self.shareImage;
    [self.shareImageMask addSubview:self.shareImageView];
    [self.shareImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.shareImageMask).offset(10);
        make.right.bottom.equalTo(self.shareImageMask).offset(-10);
    }];
    kViewBorderRadius(self.shareImageView, AppRadius, 0, kClearColor);
    
    POPSpringAnimation *animationImage = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerTranslationY];
    self.shareImageMask.layer.transform = CATransform3DMakeTranslation(0, -imageMaskH, 0);
    animationImage.toValue = @(0);
    animationImage.springBounciness = 1.0f;
    [self.shareImageMask.layer pop_addAnimation:animationImage forKey:@"ImageAnimation"];

    if ([self.sshareImage isKindOfClass:[UIImage class]]) {
        self.shareImage = (UIImage *)self.sshareImage;
        [self showImageView:YES];
    }
    else if ([self.sshareImage isKindOfClass:[NSURL class]])
    {
        [[SDWebImageManager sharedManager] loadImageWithURL:(NSURL *)self.sshareImage options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
            [self showImageView:NO];
        } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
            self.shareImage = image;
            [self showImageView:YES];
        }];
    }
    else if ([self.sshareImage isKindOfClass:[NSString class]])
    {
        [[SDWebImageManager sharedManager] loadImageWithURL:[NSURL URLWithString:(NSString *)self.sshareImage] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
            [self showImageView:NO];
        } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
            self.shareImage = image;
            [self showImageView:YES];
        }];
    }
    
    UIButton *pBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    pBtn.backgroundColor = [CGBaseGobalTools AppCellBGColor];
    pBtn.titleLabel.font = AppFontNormal;
    [pBtn setTitleColor:[CGBaseGobalTools AppTextBlack] forState:UIControlStateNormal];
    [pBtn setTitle:@"取消" forState:UIControlStateNormal];
    [pBtn addActionHandler:^(UIButton *sender) {
        [self removeSelfFromSuperView];
    }];
    [self.actionSheetView addSubview:pBtn];
    [pBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.actionSheetView);
        make.height.offset(ButtonH);
        make.bottom.equalTo(self.actionSheetView);
    }];
    
    UIView *spaceView = [UIView new];
    spaceView.backgroundColor = [CGBaseGobalTools AppSuperLightGray];
    [self.actionSheetView addSubview:spaceView];
    [spaceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.actionSheetView);
        make.bottom.equalTo(pBtn.mas_top);
        make.height.offset(5);
    }];
    
    UIScrollView *shareScroller = [UIScrollView new];
    shareScroller.backgroundColor = [CGBaseGobalTools AppCellBGColor];
    shareScroller.scrollEnabled = YES;
    [self.actionSheetView addSubview:shareScroller];
    [shareScroller mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.actionSheetView);
        make.height.offset(ButtonH*2);
        make.bottom.equalTo(spaceView.mas_top);
    }];
    
    CGFloat buttonW = kSCREEN_WIDTH/4.5;
    shareScroller.contentSize = CGSizeMake(buttonW*self.shareTitle.count, ButtonH*2);
    
    POPSpringAnimation *animation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerTranslationY];
    self.actionSheetView.layer.transform = CATransform3DMakeTranslation(0, self.actionSheetH, 0);
    animation.toValue = @(0);
    animation.springBounciness = 1.0f;
    [self.actionSheetView.layer pop_addAnimation:animation forKey:@"ActionSheetAnimation"];
    
    for (int i = 0; i < self.shareTitle.count; i++) {
        zhImageButton *shareBtn = [zhImageButton buttonWithType:UIButtonTypeCustom];
        shareBtn.titleLabel.font = AppFontNormal;
        shareBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [shareBtn setTitleColor:[CGBaseGobalTools AppTextBlack] forState:UIControlStateNormal];
        [shareBtn setTitleColor:[CGBaseGobalTools AppTextWhite] forState:UIControlStateHighlighted];
        [shareBtn setTitle:self.shareTitle[i] forState:UIControlStateNormal];
        [shareBtn setImage:[CGBaseGobalTools image:self.shareImages[i] compatibleWithTraitCollection:self.traitCollection] forState:UIControlStateNormal];
        [shareBtn setBackgroundImage:[Utils createImageWithColor:kClearColor] forState:UIControlStateNormal];
        [shareBtn setBackgroundImage:[Utils createImageWithColor:[CGBaseGobalTools AppOrange]] forState:UIControlStateHighlighted];
        shareBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        shareBtn.tag = i;
        [shareBtn imagePosition:zhImageButtonPositionTop spacing:10 imageViewResize:CGSizeMake(30, 30)];
        [shareBtn addActionHandler:^(UIButton *sender) {
            self.viewShareBolck(self.sContent,self.shareImage,self.sURL,self.sTitle,sender.titleLabel.text);
            [self removeSelfFromSuperView];
        }];
        [shareScroller addSubview:shareBtn];
        [shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.offset(buttonW);
            make.top.offset((ButtonH*2-buttonW)/2);
            make.left.offset(buttonW*i);
        }];
        kViewBorderRadius(shareBtn, AppRadius, 0, kClearColor);
    }
}

-(void)showImageView:(BOOL)show
{
    if (show)
    {
        if (!kObjectIsEmpty(self.shareImage))
        {
            CGFloat imageMaskW = kSCREEN_WIDTH - ViewSpace*4;
            CGFloat imageScale = (imageMaskW -20)/self.shareImage.size.width;
            CGFloat imageMaskH = imageScale * self.shareImage.size.height;
            
            CGFloat imageBGCenterToActionSheetTop = kSCREEN_HEIGHT/2 - self.actionSheetH;
            
            CGFloat realMaskH;
            CGFloat realMaskW;
            BOOL imageBigger;
            if (imageMaskH >= (kSCREEN_HEIGHT-self.actionSheetH))
            {
                realMaskH = kSCREEN_HEIGHT-self.actionSheetH - ViewSpace*2;
                realMaskW = (realMaskH - 20)/self.shareImage.size.height*self.shareImage.size.width;
                imageBigger = YES;
            }
            else if ((imageMaskH/2) >= (imageBGCenterToActionSheetTop-ViewSpace))
            {
                realMaskH = imageMaskH;
                realMaskW = imageMaskW;
                imageBigger = YES;
            }
            else
            {
                realMaskH = imageMaskH;
                realMaskW = imageMaskW;
                imageBigger = NO;
            }
            
            [self.shareImageMask mas_updateConstraints:^(MASConstraintMaker *make) {
                make.centerY.centerX.equalTo(imageBigger ? self.imageBG : self);
                make.width.offset(imageMaskW);
                make.height.offset(imageMaskH);
            }];
            
            self.shareImageView.image = self.shareImage;
            [self.shareImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.top.equalTo(self.shareImageMask).offset(10);
                make.right.bottom.equalTo(self.shareImageMask).offset(-10);
            }];
        }
    }
}

-(void)hideViewAction:(UIGestureRecognizer *)ges
{
    self.viewCancelBlock();
    [self removeSelfFromSuperView];
}

-(void)removeSelfFromSuperView
{
    POPBasicAnimation *offscreenAnimation = [POPBasicAnimation easeOutAnimation];
    offscreenAnimation.property = [POPAnimatableProperty propertyWithName:kPOPLayerTranslationY];
    offscreenAnimation.toValue = @(self.actionSheetH);
    offscreenAnimation.duration = 0.35f;
    [offscreenAnimation setCompletionBlock:^(POPAnimation *anim, BOOL finished) {
        [UIView animateWithDuration:0.35f delay:0 usingSpringWithDamping:0.9f initialSpringVelocity:0.7f options:UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionLayoutSubviews animations:^{
            self.alpha = 0.0;
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    }];
    [self.actionSheetView.layer pop_addAnimation:offscreenAnimation forKey:@"offscreenAnimation"];
    
    POPBasicAnimation *offscreenAnimationImage = [POPBasicAnimation easeOutAnimation];
    offscreenAnimationImage.property = [POPAnimatableProperty propertyWithName:kPOPLayerTranslationY];
    offscreenAnimationImage.toValue = @(-(kSCREEN_HEIGHT-self.actionSheetH-ViewSpace*3));
    offscreenAnimationImage.duration = 0.35f;
    [self.shareImageMask.layer pop_addAnimation:offscreenAnimationImage forKey:@"offscreenImageAnimation"];
}
@end
