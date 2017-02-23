//
//  YMShowImageView.m
//  WFCoretext
//
//  Created by 阿虎 on 14/11/3.
//  Copyright (c) 2014年 tigerwf. All rights reserved.
//

#import "YMShowImageView.h"

#import <SDWebImage/UIImageView+WebCache.h>

#import "IGAlertView.h"
#import "ALActionSheetView.h"


@implementation YMShowImageView
{
    UIScrollView *_scrollView;
    CGRect self_Frame;
    NSInteger page;
    BOOL doubleClick;
    UIButton *deleteButton;
    NSMutableArray *imageScrollViews;
    UIImageView *nilViews;
}

- (id)initWithFrame:(CGRect)frame byClick:(NSInteger)clickTag appendArray:(NSArray *)appendArray {
    return [self initWithFrame:frame byClick:clickTag appendArray:appendArray imageTitleArray:nil imageInfoArray:nil deleteAble:NO];
}

- (id)initWithFrame:(CGRect)frame byClick:(NSInteger)clickTag appendArray:(NSArray *)appendArray deleteAble:(BOOL)canDelete{
    return [self initWithFrame:frame byClick:clickTag appendArray:appendArray imageTitleArray:nil imageInfoArray:nil deleteAble:canDelete];
}

- (id)initWithFrame:(CGRect)frame byClick:(NSInteger)clickTag appendArray:(NSArray *)appendArray imageTitleArray:(NSArray *)ita imageInfoArray:(NSArray *)iia{
    return [self initWithFrame:frame byClick:clickTag appendArray:appendArray imageTitleArray:ita imageInfoArray:iia deleteAble:NO];
}

- (id)initWithFrame:(CGRect)frame byClick:(NSInteger)clickTag appendArray:(NSArray *)appendArray imageTitleArray:(NSArray *)ita imageInfoArray:(NSArray *)iia deleteAble:(BOOL)canDelete{

    self = [super initWithFrame:frame];
    if (self) {
        
        self_Frame = frame;
        
        self.backgroundColor = [UIColor redColor];
        self.alpha = 0.0f;
        page = 0;
        doubleClick = YES;
        
        [self configScrollViewWith:clickTag andAppendArray:appendArray imageTitleArray:ita imageInfoArray:iia];
        
        if (canDelete) {
            deleteButton                           = [UIButton buttonWithType:UIButtonTypeCustom];
            deleteButton.frame                     = CGRectMake(self.width - 50.0f, self.height-50, 45.0f, 45.0f);
            deleteButton.imageEdgeInsets           = UIEdgeInsetsMake(5.0f, 5.0f, 5.0f, 5.0f);
            deleteButton.showsTouchWhenHighlighted = YES;
            [deleteButton setImage:[UIImage imageNamed:@"error"] forState:UIControlStateNormal];
            [deleteButton addTarget:self action:@selector(removeCurrImage) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:deleteButton];
        }
        
        
        UITapGestureRecognizer *tapGser = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(disappear)];
        tapGser.numberOfTouchesRequired = 1;
        tapGser.numberOfTapsRequired = 1;
        [self addGestureRecognizer:tapGser];
        
        UITapGestureRecognizer *doubleTapGser = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeBig:)];
        doubleTapGser.numberOfTapsRequired = 2;
        [self addGestureRecognizer:doubleTapGser];
        [tapGser requireGestureRecognizerToFail:doubleTapGser];
        
    }
    return self;

    
}

-(void)removeFromSuperview
{
    [super removeFromSuperview];
    nilViews = nil;
}

- (void)configScrollViewWith:(NSInteger)clickTag andAppendArray:(NSArray *)appendArray imageTitleArray:(NSArray *)ita imageInfoArray:(NSArray *)iia
{

    _scrollView = [[UIScrollView alloc] initWithFrame:self_Frame];
    _scrollView.backgroundColor = [UIColor blackColor];
    _scrollView.pagingEnabled = true;
    _scrollView.delegate = self;
    _scrollView.contentSize = CGSizeMake(self.frame.size.width * appendArray.count, 0);
    [self addSubview:_scrollView];
    
    imageScrollViews = [[NSMutableArray alloc] init];
    
    float W = self.frame.size.width;
    
    
    for (int i = 0; i < appendArray.count; i ++) {
        
        UIScrollView *imageScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(self.frame.size.width * i, 0, self.frame.size.width, self.frame.size.height)];
        imageScrollView.backgroundColor = [UIColor blackColor];
        imageScrollView.contentSize = CGSizeMake(self.frame.size.width, self.frame.size.height);
        imageScrollView.delegate = self;
        imageScrollView.maximumZoomScale = 4;
        imageScrollView.minimumZoomScale = 1;
        
        nilViews = [[UIImageView alloc] initWithFrame:self.bounds];
        NSString *imageURLString = [appendArray objectAtIndex:i];
        if (imageURLString) {
            if ([imageURLString isKindOfClass:[NSString class]]) {
                [nilViews sd_setImageWithURL:[NSURL URLWithString:imageURLString]
                             placeholderImage:[UIImage imageNamed:@"1"]];
            }else if([imageURLString isKindOfClass:[NSURL class]]){
                [nilViews sd_setImageWithURL:(NSURL*)imageURLString
                             placeholderImage:[UIImage imageNamed:@"1"]];

            }else if([imageURLString isKindOfClass:[UIImage class]]){
                nilViews.image = (UIImage*)imageURLString;
            }
        }
        nilViews.contentMode = UIViewContentModeScaleAspectFit;
        [imageScrollView addSubview:nilViews];


        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, imageScrollView.height-80, screenWidth-20, 40)];
        titleLabel.textAlignment = NSTextAlignmentLeft;
        titleLabel.textColor     = [UIColor whiteColor];
        titleLabel.font          = DEFAULT_FONT(FontName, 16);
        titleLabel.numberOfLines = 0;
        titleLabel.lineBreakMode = NSLineBreakByCharWrapping;
        titleLabel.text          = ita?ita[i]:@"";
        titleLabel.hidden        = titleLabel.text.length == 0;
        [imageScrollView addSubview:titleLabel];

        UILabel *infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, imageScrollView.height-40, screenWidth-20, 40)];
        infoLabel.textAlignment = NSTextAlignmentLeft;
        infoLabel.textColor     = [UIColor whiteColor];
        infoLabel.font          = DEFAULT_FONT(FontName, 16);
        infoLabel.numberOfLines = 0;
        infoLabel.lineBreakMode = NSLineBreakByCharWrapping;
        infoLabel.text          = iia?iia[i]:@"";
        infoLabel.hidden        = infoLabel.text.length == 0;
        [imageScrollView addSubview:infoLabel];

        [_scrollView addSubview:imageScrollView];
        [imageScrollViews addObject:imageScrollView];
        
        imageScrollView.tag = 100 + i ;
        nilViews.tag = 1000 + i;
        
        
    }
    [_scrollView setContentOffset:CGPointMake(W * (clickTag - YMShowImageViewClickTagAppend), 0) animated:YES];
    page = clickTag - YMShowImageViewClickTagAppend;

}

- (void)disappear{
    if (_removeImg) {
        _removeImg();
    }
}


- (void)changeBig:(UITapGestureRecognizer *)tapGes{

    CGFloat newscale = 1.9;
    UIScrollView *currentScrollView = (UIScrollView *)[self viewWithTag:page + 100];
    CGRect zoomRect = [self zoomRectForScale:newscale withCenter:[tapGes locationInView:tapGes.view] andScrollView:currentScrollView];
    
    if (doubleClick == YES)  {
        
        [currentScrollView zoomToRect:zoomRect animated:YES];
        
    }else {
      
        [currentScrollView zoomToRect:currentScrollView.frame animated:YES];
    }
    
    doubleClick = !doubleClick;

}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    
    UIImageView *imageView = (UIImageView *)[self viewWithTag:scrollView.tag + 900];
    return imageView;

}

- (CGRect)zoomRectForScale:(CGFloat)newscale withCenter:(CGPoint)center andScrollView:(UIScrollView *)scrollV{
   
    CGRect zoomRect = CGRectZero;
    
    zoomRect.size.height = scrollV.frame.size.height / newscale;
    zoomRect.size.width = scrollV.frame.size.width  / newscale;
    zoomRect.origin.x = center.x - (zoomRect.size.width  / 2.0);
    zoomRect.origin.y = center.y - (zoomRect.size.height / 2.0);
   // NSLog(@" === %f",zoomRect.origin.x);
    return zoomRect;

}

- (void)showWithFinish:(didRemoveImage)tempBlock{
    UIView *maskview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
    maskview.backgroundColor = [UIColor blackColor];
    [[AppDelegate appDelegate].window addSubview:maskview];
    
    [self show:maskview didFinish:^{
        [UIView animateWithDuration:0.5f animations:^{
            self.alpha = 0.0f;
            maskview.alpha = 0.0f;
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
            [maskview removeFromSuperview];
            nilViews = nil;
            _scrollView = nil;
            imageScrollViews = nil;
            if (tempBlock) {
                tempBlock();
            }
        }];
    }];

}

- (void)show:(UIView *)bgView didFinish:(didRemoveImage)tempBlock{
    
     [bgView addSubview:self];
    
     _removeImg = tempBlock;
    
     [UIView animateWithDuration:.4f animations:^(){
         
         self.alpha = 1.0f;
    
      } completion:^(BOOL finished) {
        
     }];

}


#pragma mark - ScorllViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
  
    CGPoint offset = _scrollView.contentOffset;
    page = offset.x / self.frame.size.width ;
   
    
    UIScrollView *scrollV_next = (UIScrollView *)[self viewWithTag:page+100+1]; //前一页
    
    if (scrollV_next.zoomScale != 1.0){
    
        scrollV_next.zoomScale = 1.0;
    }
    
    UIScrollView *scollV_pre = (UIScrollView *)[self viewWithTag:page+100-1]; //后一页
    if (scollV_pre.zoomScale != 1.0){
        scollV_pre.zoomScale = 1.0;
    }
    
   // NSLog(@"page == %d",page);
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView{
  

}

#pragma mark - ----> 删除图片
- (void)removeCurrImage{

    ALActionSheetView *actionSheetView = [ALActionSheetView showActionSheetWithTitle:nil
                                                                   cancelButtonTitle:@"取消"
                                                              destructiveButtonTitle:nil
                                                                   otherButtonTitles:@[@"删除照片"]
                                                                             handler:^(ALActionSheetView *actionSheetView, NSInteger buttonIndex)
                                          {
                                              if (buttonIndex == 0)
                                              {
                                                  NSInteger index = page;

                                                  if (self.didDeleted)
                                                  {
                                                      self.didDeleted(self,index);
                                                  }

                                                  UIView *currView = imageScrollViews[index];
                                                  if (currView) {
                                                      if (imageScrollViews.count == 1)
                                                      {
                                                          [self disappear];
                                                      }
                                                      else
                                                      {
                                                          __block float lastWidth = currView.width;
                                                          [UIView animateWithDuration:0.2 animations:^{
                                                              currView.alpha = 0;
                                                              currView.frame = CGRectMake(currView.x*0.5, currView.y, 0, 0);

                                                              _scrollView.contentSize = CGSizeMake(_scrollView.contentSize.width - lastWidth, _scrollView.contentSize.height);
                                                              [imageScrollViews removeObjectAtIndex:index];

                                                              if (index >= imageScrollViews.count)
                                                              {
                                                                  page = page - 1;
                                                              }
                                                              else
                                                              {
                                                                  for (int i = (int)index ; i < imageScrollViews.count ;  i++)
                                                                  {
                                                                      UIView *nextView = imageScrollViews[i];
                                                                      nextView.tag = i+100;
                                                                      nextView.x -= lastWidth;
                                                                      lastWidth = nextView.width;
                                                                  }
                                                              }
                                                          } completion:^(BOOL finished) {
                                                              [currView removeFromSuperview];
                                                          }];
                                                      }
                                                  }
                                              }
                                          }];
    [actionSheetView show];
}




@end
