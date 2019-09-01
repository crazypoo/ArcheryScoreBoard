//
//  CBHistoryCollectionViewController.m
//  CreateBill
//
//  Created by 邓杰豪 on 2016/8/8.
//  Copyright © 2016年 邓杰豪. All rights reserved.
//

#import "CBHistoryCollectionViewController.h"

#import "CBHistoryCollectionViewCell.h"
#import "YMShowImageView.h"
#import <ShareSDK/ShareSDK.h>
#import <DZNemptyDataSet/UIScrollView+EmptyDataSet.h>
#import <CGBase/PShareView.h>

#define EmptyDataImage            @"1"
#define EmptyDataWithTitleString  @"OPPS!!暂时没有数据"
#define EmptyDataWithTapString    @"快去刷新成绩"

@interface CBHistoryCollectionViewController ()<UIActionSheetDelegate,UIPrintInteractionControllerDelegate,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>
{
    NSArray *tempFileList;
    NSMutableArray *currentViewImageArr;
    NSMutableArray *imageNameArray;
    NSString *imagePath;
    NSMutableArray *imageArray;
    UILabel *navTitleLabel;
}
@end

@implementation CBHistoryCollectionViewController

static NSString * const reuseIdentifier = @"Cell";

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.collectionView.emptyDataSetDelegate = self;
    self.collectionView.emptyDataSetSource = self;

    currentViewImageArr = [[NSMutableArray alloc] init];
    imageArray = [[NSMutableArray alloc] init];
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;

    navTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
    navTitleLabel.textAlignment = NSTextAlignmentCenter;
    navTitleLabel.textColor = [UIColor blackColor];
    navTitleLabel.font = kDEFAULT_FONT(FontName, 24);
    navTitleLabel.text = @"历史记录";
    self.navigationItem.titleView = navTitleLabel;
 
    // Register cell classes
    [self.collectionView registerClass:[CBHistoryCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    // Do any additional setup after loading the view.
    self.collectionView.backgroundColor = [UIColor whiteColor];

    imagePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/History"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    tempFileList = [[NSArray alloc] initWithArray:[fileManager contentsOfDirectoryAtPath:imagePath error:nil]];
    imageNameArray = [[NSMutableArray alloc] init];
    for(NSString *imageName in tempFileList)
    {
        [imageNameArray addObject:imageName];
    }
    [currentViewImageArr addObjectsFromArray:imageNameArray];

    for (int i = 0; i<tempFileList.count; i++) {
        NSString *imageStr = [NSString stringWithFormat:@"/%@",currentViewImageArr[i]];
        [imageArray addObject:[UIImage imageWithContentsOfFile:[imagePath stringByAppendingString:imageStr]]];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark ------> 按钮
-(void)backAct:(UIButton *)sender
{
    kReturnsToTheUpperLayer
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return imageArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CBHistoryCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    // Configure the cell
    cell.imageView.image = imageArray[indexPath.row];
    cell.nameLabel.text = imageNameArray[indexPath.row];
    cell.btn.cellsTag = indexPath;
    [cell.btn addTarget:self action:@selector(btnAct:) forControlEvents:UIControlEventTouchUpInside];

    cell.layer.borderColor = [UIColor lightGrayColor].CGColor;
    cell.layer.borderWidth = 1;

    return cell;
}

#pragma mark <UICollectionViewDelegate>
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray *imageModel = [NSMutableArray array];
    
    for (int i = 0; i < imageArray.count; i++) {
        PooShowImageModel *model = [PooShowImageModel new];
        model.imageShowType = PooShowImageModelTypeNormal;
        model.imageInfo = imageNameArray[i];
        model.imageUrl = imageArray[i];
        
        [imageModel addObject:model];
    }
    
    YMShowImageView *ymImageV = [[YMShowImageView alloc] initWithByClick:indexPath.row+YMShowImageViewClickTagAppend appendArray:imageModel titleColor:kRandomColor fontName:FontName showImageBackgroundColor:kRandomColor showWindow:kAppDelegateWindow loadingImageName:@"" deleteAble:YES saveAble:NO moreActionImageName:@"" hideImageName:@""];
    [ymImageV showWithFinish:^{
        [self.collectionView reloadData];
    }];
    ymImageV.saveImageStatus = ^(BOOL saveStatus) {
//        saveBlock(saveStatus);
    };
    ymImageV.otherBlock = ^(NSInteger index) {
//        otherBlock(index);
    };
    ymImageV.didDeleted = ^(YMShowImageView *siv, NSInteger index) {
        NSString *plistPath = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/History/%@",imageNameArray[index]]];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        [fileManager removeItemAtPath:plistPath error:nil];
        [imageArray removeObjectAtIndex:index];
        [imageNameArray removeObjectAtIndex:index];
    };
    [ymImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(kAppDelegateWindow);
    }];
}

#pragma mark ------> DZNEmptyDataSetDelegate&&DZNEmptyDataSetSource
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    return kImageNamed(EmptyDataImage);
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = EmptyDataWithTitleString;
    
    NSDictionary *attributes = @{NSFontAttributeName: kDEFAULT_FONT(FontName,18),
                                 NSForegroundColorAttributeName: [UIColor darkGrayColor]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = EmptyDataWithTapString;
    
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    
    NSDictionary *attributes = @{NSFontAttributeName: kDEFAULT_FONT(FontName,14),
                                 NSForegroundColorAttributeName: [UIColor lightGrayColor],
                                 NSParagraphStyleAttributeName: paragraph};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (UIColor *)backgroundColorForEmptyDataSet:(UIScrollView *)scrollView
{
    return [UIColor whiteColor];
}

- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView
{
    return 100;
}

- (CGFloat)spaceHeightForEmptyDataSet:(UIScrollView *)scrollView
{
    return 20.0f;
}

- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView
{
    return YES;
}

- (BOOL)emptyDataSetShouldAllowTouch:(UIScrollView *)scrollView
{
    return YES;
}

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView
{
    return NO;
}

- (void)emptyDataSetDidTapView:(UIScrollView *)scrollView
{
}

#pragma mark ---------------> 按钮
-(void)btnAct:(CBButton *)sender
{
    
    ALActionSheetView *actionSheetView = [[ALActionSheetView alloc] initWithTitle:@"图片操作" titleMessage:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@[@"分享给朋友"] buttonFontName:FontName singleCellBackgroundColor:kRandomColor normalCellTitleColor:kRandomColor destructiveCellTitleColor:kRandomColor titleCellTitleColor:kRandomColor separatorColor:kRandomColor heightlightColor:kRandomColor handler:^(ALActionSheetView *actionSheetView, NSInteger buttonIndex) {
        if (buttonIndex == 0)
        {
            PShareView *share = [[PShareView alloc] initWithShareLink:nil withShareContent:@"来看看我这次的成绩🤣"
                                                       withShareImage:(UIImage *)imageArray[sender.cellsTag.row] withShareTitle:@"ArcheryScoreBoard"
                                                     handleShareBlock:^(NSString *shareContent, UIImage *shareImage, NSURL *shareURL, NSString *shareTitle, NSString *shareBtnTitle) {
                [self wakeUpShareSDKWithButtonTitle:shareBtnTitle shareContent:shareContent shareImage:shareImage shareURL:shareURL shareTitle:shareTitle];

            } handleCancelBlock:^{
                
            }];
            [share shareViewShow];
        }
    }];
    [actionSheetView show];
}


-(void)wakeUpShareSDKWithButtonTitle:(NSString *)btnTitle shareContent:(NSString *)content shareImage:(UIImage *)image shareURL:(NSURL *)url shareTitle:(NSString *)title
{
    SSDKPlatformType shareType;
    if ([btnTitle isEqualToString:@"微博"])
    {
        shareType = SSDKPlatformTypeSinaWeibo;
    }
    else if ([btnTitle isEqualToString:@"微信"])
    {
        shareType = SSDKPlatformTypeWechat;
    }
    else if ([btnTitle isEqualToString:@"QQ"])
    {
        shareType = SSDKPlatformTypeQQ;
    }
    else if ([btnTitle isEqualToString:@"短信"])
    {
        shareType = SSDKPlatformTypeSMS;
    }
    else if ([btnTitle isEqualToString:@"复制"])
    {
        shareType = SSDKPlatformTypeCopy;
    }
    else
    {
        shareType = SSDKPlatformTypeUnknown;
    }
    
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    [shareParams SSDKSetupShareParamsByText:content
                                     images:image //传入要分享的图片
                                        url:url
                                      title:title
                                       type:SSDKContentTypeAuto];
    
    //进行分享
    [ShareSDK share:shareType //传入分享的平台类型
         parameters:shareParams
     onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
         // 回调处理....
         NSString *msg;
         switch (state) {
             case SSDKResponseStateSuccess:
             {
                 msg = @"分享成功";
             }
                 break;
             case SSDKResponseStateFail:
             {
                 msg = [NSString stringWithFormat:@"分享失败,原因:%@",error.description];
             }
                 break;
             case SSDKResponseStateCancel:
                 break;
             default:
                 break;
         }
         
         if (!kStringIsEmpty(msg))
         {
             [Utils alertVCOnlyShowWithTitle:@"提示" andMessage:msg];
         }
     }];
}
@end
