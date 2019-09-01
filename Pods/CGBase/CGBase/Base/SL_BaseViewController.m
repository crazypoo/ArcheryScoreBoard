//
//  SL_BaseViewController.m
//  BigTitleNavigationController
//
//  Created by admin on 2017/6/7.
//  Copyright © 2017年 admin. All rights reserved.
//

#import "SL_BaseViewController.h"

#if DEBUG
#import <PooTools/PTCheckAppStatus.h>
#import "MyOOMDataManager.h"
#import <FLEX/FLEXManager.h>
#endif

#import <PooTools/SQFloatWindow.h>
#import <PooTools/PMacros.h>
#import <LSSafeProtector/LSSafeProtector.h>
#import <PooTools/PBugReporter.h>
#import <Masonry/Masonry.h>
#import "CGBaseMarcos.h"
#import <PooTools/UIView+ModifyFrame.h>
#import <PooTools/NSString+WPAttributedMarkup.h>
#import "CGBaseGobalTools.h"

//#import "CGBaseFont.h"

//SL_UIViewControllerScrollBackgroundDelegate
@interface SL_BaseViewController ()
{
    NSString *_startTime;
    
    BOOL _isOptimzeScroll;
    float _optimzeOldY;
    NSInteger _scrollCount;
    
    CGPoint _beginPanScrollPoint;
    CGPoint _beginPanScrollContentOffset;
    CGPoint _beginPanOptimScrollContentOffset;
    
    //iphoneX viewWillDisappear神奇的篡改scrollview.contentOffset即使设置contentInsetAdjustmentBehavior也不起作用，暂时未发现解决方法
    CGPoint _iPoneXDisappearContentOffset;
    BOOL _willAppear;
    UIStatusBarStyle statusStyle;
}
@property (nonatomic,strong) SQFloatWindow *floatWindow;
//@property (nonatomic, strong) CGBaseFont *baseFont;
@end

@implementation SL_BaseViewController

-(void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
#if DEBUG
    if (!self.floatWindow)
    {
        self.floatWindow = [[SQFloatWindow alloc] initWithFrame:CGRectMake(0, 200, 50, 50) mainBtnName:@"调试工具" titles:@[@"QQ",@"Flex",@"Poo",@"TP"]];
        kWeakSelf(self);
        self.floatWindow.clickBlocks = ^(NSInteger i) {
            switch (i) {
                case 0:
                {
                    [weakself createOOMDetector];
                }
                    break;
                case 1:
                {
                    if ([[FLEXManager sharedManager] isHidden]) {
                        [[FLEXManager sharedManager] showExplorer];
                    }
                }
                    break;
                case 2:
                {
                    if ([PTCheckAppStatus sharedInstance].closed) {
                        [[PTCheckAppStatus sharedInstance] open];
                    }
                    else
                    {
                        [[PTCheckAppStatus sharedInstance] close];
                    }
                }
                    break;
                default:
                    break;
            }
        };
        [self.floatWindow showWindow];
    }
    else
    {
        [self.floatWindow dissmissWindow];
        self.floatWindow = nil;
    }
#endif
}

#if DEBUG
-(void)createOOMDetector
{
    OOMDetector *detector = [OOMDetector getInstance];
    [detector setupWithDefaultConfig];
    
    /*********************下面的几项可以根据自己的实际需要选择性设置******************/
    
    // 设置捕获堆栈数据、内存log代理，在出现单次大块内存分配、检查到内存泄漏且时、调用uploadAllStack方法时会触发此回调
    [detector setFileDataDelegate:[MyOOMDataManager getInstance]];
    
    // 设置app内存触顶监控数据代理，在调用startMaxMemoryStatistic:开启内存触顶监控后会触发此回调，返回前一次app运行时单次生命周期内的最大物理内存数据
    [detector setPerformanceDataDelegate:[MyOOMDataManager getInstance]];
    
    // 单次大块内存分配监控
    [detector startSingleChunkMallocDetector:50 * 1024 * 1024 callback:^(size_t bytes, NSString *stack) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"kChunkMallocNoti" object:stack];
    }];
    
    // 开启内存泄漏监控，目前只可检测真机运行时的内存泄漏，模拟器暂不支持
    [detector setupLeakChecker];
    
    // 开启MallocStackMonitor用以监控通过malloc方式分配的内存
    [detector startMallocStackMonitor:10 * 1024 * 1024 needAutoDumpWhenOverflow:YES dumpLimit:300 sampleInterval:0.1];
    
    // 开启VMStackMonitor用以监控非直接通过malloc方式分配的内存
    // 因为startVMStackMonitor:方法用到了私有API __syscall_logger会带来app store审核不通过的风险，此方法默认只在DEBUG模式下生效，如果
    // 需要在RELEASE模式下也可用，请打开USE_VM_LOGGER_FORCEDLY宏，但是切记在提交appstore前将此宏关闭，否则可能会审核不通过
    [detector startVMStackMonitor:10 * 1024 * 1024];
    
    // 调用该接口上报所有缓存的OOM相关log给通过setFileDataDelegate:方法设置的代理，建议在启动的时候调用
    [detector uploadAllStack];
    
    /*************************************************************************/
    //    [detector showMemoryIndicatorView:YES];
}
#endif

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    [UIView setAnimationsEnabled:YES];
    
    [MXRotationManager defaultManager].orientation = UIDeviceOrientationPortrait;
    
//    self.baseFont = [CGBaseFont shareManager];
//    self.baseFont.fontDidChangeBlock = ^{
//        [self fontChange];
//    };
    
    BOOL isDEBUG;
#if DEBUG
    isDEBUG = YES;
#else
    isDEBUG = NO;
#endif
    [LSSafeProtector openSafeProtectorWithIsDebug:isDEBUG block:^(NSException *exception, LSSafeProtectorCrashType crashType) {
        [PBugReporter TakeException:exception];
        //        //此方法方便在bugly后台查看bug崩溃位置，而不用点击跟踪数据，再点击crash_attach.log来查看崩溃位置
        //        [Bugly reportExceptionWithCategory:3 name:exception.name reason:[NSString stringWithFormat:@"%@  崩溃位置:%@",exception.reason,exception.userInfo[@"location"]] callStack:@[exception.userInfo[@"callStackSymbols"]] extraInfo:exception.userInfo terminateApp:NO];
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(layoutControllerSubViews) name:UIApplicationDidChangeStatusBarFrameNotification object:nil];

    self.view.backgroundColor = [UIColor whiteColor];
    if (self.navigationController.navigationBar.hidden == NO) {
        self.navigationController.navigationBar.hidden = YES;
    }
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.clipsToBounds = YES;
    
//    self.sl_enableScrollBackground = YES;
//    self.sl_scrollBackgroundDelgate = self;
//    self.sl_scrollBackgroundBounces = NO;
    
    // Do any additional setup after loading the view.

    _navigationBar = [[SL_NavigationBar alloc]initWithFrame:CGRectMake(0,0,kSCREEN_WIDTH, NavigationBarNormalHeight)];
//    _navigationBar.delegate = self;
    [_navigationBar.btnBack addTarget:self action:@selector(goBackClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_navigationBar];
    [_navigationBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.height.offset(NavigationBarNormalHeight);
    }];
    
//    _navigationBar.layer.shadowColor = AppBlack.CGColor;
//    _navigationBar.layer.shadowOffset = CGSizeMake(0, 5);
//    _navigationBar.layer.shadowOpacity = 0.9;
//    _navigationBar.layer.shadowRadius = 3;

    
//    self.sl_scrollBackgroundContentSize = CGSizeMake(self.view.width, self.view.height+self.navigationBar.height-self.navigationBar.btnBack.bottom-(isIPhoneXSeries()?(kScreenStatusBottom-10):0));

    _scrollCount = 0;
    
//    [[(SLBackGroundView*)self.view bgScroll].panGestureRecognizer addTarget:self action:@selector(scrollPanOptim:)];
//
//    [[(SLBackGroundView*)self.view bgScroll] mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.top.bottom.equalTo(self.view);
//    }];

    
    [self loadViewIfNeeded];
    
    [self createStatusBtn];
}

//-(void)fontChange
//{
//    
//}

-(void)createStatusBtn
{
    if (!self.statusBtn)
    {
        self.statusBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.statusBtn.backgroundColor = kClearColor;
        [self.statusBtn addTarget:self action:@selector(statusAction:) forControlEvents:UIControlEventTouchUpInside];
        [kAppDelegateWindow addSubview:self.statusBtn];
        [self.statusBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(kAppDelegateWindow);
            make.height.offset(HEIGHT_STATUS);
        }];
    }
}

-(void)layoutControllerSubViews
{
    if (self.changeBlock) {
        self.changeBlock();
    }
}

-(void)statusAction:(UIButton *)sender
{
    if (self.tapBlock)
    {
        self.tapBlock();
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return statusStyle;
}

-(void)setStatusBar:(UIStatusBarStyle)style
{
    statusStyle = style;
    [self setNeedsStatusBarAppearanceUpdate];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setStatusBar:UIStatusBarStyleDefault];
    adjustsScrollViewInsets(self.optimScrollView);
//    adjustsScrollViewInsets([(SLBackGroundView*)self.view bgScroll]);
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        
//        UIWindow * coverWindow =[[UIWindow alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 20)];
//        self.coverWindow = coverWindow;
//        coverWindow.hidden = NO;
//        coverWindow.backgroundColor = kClearColor;
//        coverWindow.windowLevel = UIWindowLevelAlert;
//        //添加手势
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(coverWindowClick)];
//        [coverWindow addGestureRecognizer:tap];
//    });
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userDidTakeScreenshot:) name:UIApplicationUserDidTakeScreenshotNotification object:nil];
    [self createStatusBtn];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    _willAppear=YES;
//    _iPoneXDisappearContentOffset = [(SLBackGroundView*)self.view bgScroll].contentOffset;
}

-(void)viewDidDisappear:(BOOL)animated
{
    //FIX:没有调用super
    [super viewDidDisappear:animated];
    
//    [(SLBackGroundView*)self.view bgScroll].contentOffset=_iPoneXDisappearContentOffset;
    _willAppear=NO;
    
//    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIApplicationUserDidTakeScreenshotNotification object:nil];
    [self.statusBtn removeFromSuperview];
    self.statusBtn = nil;
}

//#pragma mark ------> ScreenShot
//- (void)userDidTakeScreenshot:(NSNotification *)notification
//{
//    //人为截屏, 模拟用户截屏行为, 获取所截图片
//    UIImage *image = [self imageWithScreenshot];
//
//    PShareView *share = [[PShareView alloc] initWithShareLink:nil withShareContent:nil withShareImage:image withShareTitle:nil];
//    [share shareViewShow];
//}

- (NSData *)dataWithScreenshotInPNGFormat
{
    CGSize imageSize = CGSizeZero;
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (UIInterfaceOrientationIsPortrait(orientation))
        imageSize = [UIScreen mainScreen].bounds.size;
    else
        imageSize = CGSizeMake([UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width);
    
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    for (UIWindow *window in [[UIApplication sharedApplication] windows])
    {
        CGContextSaveGState(context);
        CGContextTranslateCTM(context, window.center.x, window.center.y);
        CGContextConcatCTM(context, window.transform);
        CGContextTranslateCTM(context, -window.bounds.size.width * window.layer.anchorPoint.x, -window.bounds.size.height * window.layer.anchorPoint.y);
        if (orientation == UIInterfaceOrientationLandscapeLeft)
        {
            CGContextRotateCTM(context, M_PI_2);
            CGContextTranslateCTM(context, 0, -imageSize.width);
        }
        else if (orientation == UIInterfaceOrientationLandscapeRight)
        {
            CGContextRotateCTM(context, -M_PI_2);
            CGContextTranslateCTM(context, -imageSize.height, 0);
        } else if (orientation == UIInterfaceOrientationPortraitUpsideDown) {
            CGContextRotateCTM(context, M_PI);
            CGContextTranslateCTM(context, -imageSize.width, -imageSize.height);
        }
        if ([window respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)])
        {
            [window drawViewHierarchyInRect:window.bounds afterScreenUpdates:YES];
        }
        else
        {
            [window.layer renderInContext:context];
        }
        CGContextRestoreGState(context);
    }
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return UIImagePNGRepresentation(image);
}

- (UIImage *)imageWithScreenshot
{
    NSData *imageData = [self dataWithScreenshotInPNGFormat];
    return [UIImage imageWithData:imageData];
}

- (void)coverWindowClick
{

}

-(void)setDisableBottomFill:(BOOL)disableBottomFill{
    _disableBottomFill = disableBottomFill;
    if (!(_disableBottomFill && isIPhoneXSeries())) {
        CGRect tmpFrame = self.view.frame;
        tmpFrame.size.height = kSCREEN_HEIGHT-33;
//        [(SLBackGroundView*)self.view bgScroll].frame = tmpFrame;
    }
}

-(void)setTitleCustom:(UIView *)customView
{
    [self.navigationBar setTitleCustom:customView];
}

-(void)setRightCustom:(UIView *)rightCustomView
{
    [self.navigationBar setRightView:rightCustomView];
}

-(void)goBackClick{
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
    
    if (self.presentingViewController)
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else
    {
        kReturnsToTheUpperLayer
    }
}

//-(CGRect)baseViewBounds{
//    if (self.navigationBar.hidden||self.navigationBar.height<=0) {
//        return CGRectMake(0, 0, self.view.width, (self.sl_enableScrollBackground?self.sl_scrollBackgroundContentSize.height:self.view.height)-(([self.tabBarController.viewControllers containsObject:self.navigationController] && [self.navigationController.viewControllers.firstObject isEqual:self])?self.tabBarController.tabBar.height:0)+((isIPhoneXSeries()&&_enableScrollToBottomFill)?33:0));
//    }
//
//
//    return CGRectMake(0, self.navigationBar.bottom, self.view.width, (self.sl_enableScrollBackground?self.sl_scrollBackgroundContentSize.height:self.view.height)-self.navigationBar.bottom-(([self.tabBarController.viewControllers containsObject:self.navigationController] && [self.navigationController.viewControllers.firstObject isEqual:self])?self.tabBarController.tabBar.height:0)+((isIPhoneXSeries()&&_enableScrollToBottomFill)?33:0));
//}

//#pragma mark -
//-(void)scrollPanOptim:(UIPanGestureRecognizer*)panGesture{
//    CGPoint scrollPoint=[panGesture locationInView:self.view];
//    if (panGesture.state==UIGestureRecognizerStateBegan) {
//        _beginPanScrollPoint=scrollPoint;
//        _beginPanScrollContentOffset=[(UIScrollView*)panGesture.view contentOffset];
//        _beginPanOptimScrollContentOffset=_optimScrollView.contentOffset;
//    }
//    if (panGesture.state==UIGestureRecognizerStateChanged) {
//        CGFloat changeY=scrollPoint.y-_beginPanScrollPoint.y;
//        CGFloat tmpContentOffset=_beginPanScrollContentOffset.y-changeY;
//        if (tmpContentOffset<=0) {
//            if (_optimScrollView) {
//                CGPoint tmpPoint=_beginPanOptimScrollContentOffset;
//                tmpPoint.y-=(changeY/2.);
//                [_optimScrollView setContentOffset:tmpPoint animated:NO];
//            }
//        }
//    }
//    if (panGesture.state==UIGestureRecognizerStateEnded||panGesture.state==UIGestureRecognizerStateCancelled) {
//        if (_optimScrollView.contentOffset.y<0) {
//            [_optimScrollView setContentOffset:CGPointZero animated:YES];
//        }
//    }
//}
//
//#pragma mark - SL_UIViewControllerScrollBackgroundProtocol
//-(void)sl_optimzeScroll:(UIScrollView*)scrollView{
//    _optimScrollView=scrollView;
//    if (_enableNavigtionPan&&[(SLBackGroundView*)self.view bgScroll].dragging) {
//        [scrollView setContentOffset:scrollView.contentOffset animated:NO];
//        return;
//    }
//
//    if (scrollView.contentSize.height>scrollView.height&&scrollView.contentSize.height<(scrollView.height+(NavigationBarNormalHeight-self.navigationBar.btnBack.bottom))) {
//        scrollView.contentSize=CGSizeMake(scrollView.contentSize.width, (scrollView.height+(NavigationBarNormalHeight-self.navigationBar.btnBack.bottom)));
//    }
//
//    _isOptimzeScroll=YES;
//
//    if (!_enableNavigtionPan) {
//        [(SLBackGroundView*)self.view bgScroll].scrollEnabled=NO;
//    }
//
//    float newY = 0;
//    BOOL isUp=NO;
//
//    newY = scrollView.contentOffset.y;
//
//    float diffOffsetY=newY-scrollView.sl_lastScrollContentOffset.y;
//
//    if (newY != scrollView.sl_lastScrollContentOffset.y) {
//        if (newY > scrollView.sl_lastScrollContentOffset.y) {
////            NSLog(@"Down");//✋↑
//            isUp=NO;
//        } else if (newY < scrollView.sl_lastScrollContentOffset.y) {
////            NSLog(@"Up");//✋↓
//            isUp=YES;
//        }
//
//        scrollView.sl_lastScrollContentOffset=scrollView.contentOffset;
//    }
//
//
//    CGPoint tmpContentOffset=[(SLBackGroundView*)self.view bgScroll].contentOffset;
//
//    if (isUp) {
//        if (tmpContentOffset.y<=(NavigationBarNormalHeight-(NavButonH+kScreenStatusBottom))&&scrollView.contentOffset.y<(NavigationBarNormalHeight-(NavButonH+kScreenStatusBottom))) {
//            tmpContentOffset.y+=diffOffsetY;
//        }
//    }
//    if (!isUp) {
//        if (tmpContentOffset.y<=(NavigationBarNormalHeight-(NavButonH+kScreenStatusBottom))&&tmpContentOffset.y>=0&&scrollView.contentOffset.y>0) {
//            tmpContentOffset.y+=diffOffsetY;
//        }
//    }
//
//    tmpContentOffset.y=(tmpContentOffset.y>(NavigationBarNormalHeight-(NavButonH+kScreenStatusBottom)))?(NavigationBarNormalHeight-(NavButonH+kScreenStatusBottom)):tmpContentOffset.y;
//    tmpContentOffset.y=(tmpContentOffset.y<0)?(0):tmpContentOffset.y;
//    tmpContentOffset.x=0;
//
//    [(SLBackGroundView*)self.view bgScroll].contentOffset=tmpContentOffset;
//
//}
//
//#pragma mark - SL_UIViewControllerScrollBackgroundDelegate
//-(void)sl_scrollViewDidScroll:(UIScrollView *)scrollView{
//    if (_willAppear) {
//        [(SLBackGroundView*)self.view bgScroll].bounds=CGRectMake(_iPoneXDisappearContentOffset.x, _iPoneXDisappearContentOffset.y, [(SLBackGroundView*)self.view bgScroll].bounds.size.width, [(SLBackGroundView*)self.view bgScroll].bounds.size.height);
//    }
//
//    //ios11 开始出现的诡异现象，首次进入scroll乱滚两次
//    if (_scrollCount<2&&scrollView.contentOffset.y<0) {
//        return;
//    }
//    _scrollCount++;
//
//    CGFloat scale= scrollView.contentOffset.y/(NavigationBarNormalHeight-self.navigationBar.btnBack.bottom);
//
//    if (_isOptimzeScroll) {
//        [self.navigationBar navigationBarAnimationWithScale:scale];
//    }
//    if ([scrollView isEqual:[(SLBackGroundView*)self.view bgScroll]]) {
//        [self.navigationBar navigationBarAnimationWithScale:scale];
//    }
//}

#pragma mark ------> EmptyData
- (nullable UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return AppNullDataImage;
}

- (nullable NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *emptyString = AppNullDataString;
    NSString *emptyTapString = AppNullDataTapString;
    NSDictionary *style = @{
                            @"HEAD":@[AppFontNormal,[CGBaseGobalTools AppRed]],
                            @"END":@[AppFontNormal,[CGBaseGobalTools AppGray]]
                            };
    
    return [[NSString stringWithFormat:@"<HEAD>%@</HEAD>\n<END>%@</END>",emptyString,emptyTapString] attributedStringWithStyleBook:style];
}

@end
