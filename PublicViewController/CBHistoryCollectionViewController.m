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
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import <DZNemptyDataSet/UIScrollView+EmptyDataSet.h>

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
    navTitleLabel.textColor = [UIColor whiteColor];
    navTitleLabel.font = DEFAULT_FONT(FontName, 24);
    navTitleLabel.text = @"历史记录";
    self.navigationItem.titleView = navTitleLabel;

    CreatReturnButton(@"image_back", backAct:)


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
    ReturnsToTheUpperLayer
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
    YMShowImageView *ymImageV = [[YMShowImageView alloc] initWithFrame:[UIScreen mainScreen].bounds byClick:indexPath.row+YMShowImageViewClickTagAppend appendArray:imageArray imageTitleArray:imageNameArray imageInfoArray:nil deleteAble:YES];

    NSMutableArray *newPhotoArr = [[NSMutableArray alloc] init];
    [newPhotoArr addObjectsFromArray:imageArray];

    NSMutableArray *newPhotoNameArr = [[NSMutableArray alloc] init];
    [newPhotoNameArr addObjectsFromArray:imageNameArray];

    ymImageV.didDeleted = ^(YMShowImageView *siv,NSInteger index)
    {
        if (newPhotoArr && index < [newPhotoArr count]) {
            [newPhotoArr removeObjectAtIndex:index];
            [newPhotoNameArr removeObjectAtIndex:index];

            NSString *plistPath = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/History/%@",imageNameArray[index]]];
            NSFileManager *fileManager = [NSFileManager defaultManager];
            [fileManager removeItemAtPath:plistPath error:nil];


            [imageArray removeAllObjects];
            [imageNameArray removeAllObjects];

            [self.collectionView reloadData];
            for (UIImage *img in newPhotoArr) {
                if ([img isKindOfClass:[UIImage class]]) {
                    [imageArray addObject:img];
                }
            }
            for (NSString *imgName in newPhotoNameArr) {
                if ([imgName isKindOfClass:[NSString class]]) {
                    [imageNameArray addObject:imgName];
                }
            }
        }
    };
    [ymImageV showWithFinish:^{
        [self.collectionView reloadData];
    }];
}

#pragma mark ------> DZNEmptyDataSetDelegate&&DZNEmptyDataSetSource
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    return ImageNamed(EmptyDataImage);
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = EmptyDataWithTitleString;
    
    NSDictionary *attributes = @{NSFontAttributeName: DEFAULT_FONT(FontName,18),
                                 NSForegroundColorAttributeName: [UIColor darkGrayColor]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = EmptyDataWithTapString;
    
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    
    NSDictionary *attributes = @{NSFontAttributeName: DEFAULT_FONT(FontName,14),
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
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"图片操作" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"分享给朋友", nil];
    sheet.tag = sender.cellsTag.row;
    [sheet showInView:self.view];
}

#pragma mark - action sheet delegte
-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        //1、创建分享参数

        UIImage *imgeee = imageArray[actionSheet.tag];

        NSArray* shareImageArray = @[imgeee];
        //        （注意：图片必须要在Xcode左边目录里面，名称必须要传正确，如果要分享网络图片，可以这样传iamge参数 images:@[@"http://mob.com/Assets/images/logo.png?v=20150320"]）
        if (shareImageArray) {

            NSIndexPath *cellIndexPath = [NSIndexPath indexPathForRow:actionSheet.tag inSection:0];
            CBHistoryCollectionViewCell *cells = (CBHistoryCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:cellIndexPath];

            NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];

            [shareParams SSDKSetupShareParamsByText:@"来看看我这次的成绩🤣"
                                             images:shareImageArray
                                                url:nil
                                              title:@"ArcheryScoreBoard"
                                               type:SSDKContentTypeAuto];

            [shareParams SSDKEnableUseClientShare];

            //2、分享（可以弹出我们的分享菜单和编辑界面）
            [ShareSDK showShareActionSheet:cells.btn //要显示菜单的视图, iPad版中此参数作为弹出菜单的参照视图，只有传这个才可以弹出我们的分享菜单，可以传分享的按钮对象或者自己创建小的view 对象，iPhone可以传nil不会影响
                                     items:nil
                               shareParams:shareParams
                       onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {

                           switch (state) {
                               case SSDKResponseStateSuccess:
                               {
                                   UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                                       message:nil
                                                                                      delegate:nil
                                                                             cancelButtonTitle:@"确定"
                                                                             otherButtonTitles:nil];
                                   [alertView show];
                                   break;
                               }
                               case SSDKResponseStateFail:
                               {
                                   UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                                   message:[NSString stringWithFormat:@"%@",error]
                                                                                  delegate:nil
                                                                         cancelButtonTitle:@"OK"
                                                                         otherButtonTitles:nil, nil];
                                   [alert show];
                                   break;
                               }
                               default:
                                   break;
                           }
                       }
             ];
        }
    }
}
@end
