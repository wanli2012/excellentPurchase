//
//  LBFinancialCenterViewController.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/1/9.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "LBFinancialCenterViewController.h"
#import "LBFinancialCenterHeaderView.h"
#import "SPPageMenu.h"
#import "LBFinancialCenterBaseViewController.h"
#import "LBFinancialCenterMarketvalueViewController.h"
#import "LBFinancialCenterSaleRecoderViewController.h"
#import "LBFinancialCenterExchangeRecodervc.h"
#import "LBFinancialCenetrSaleViewController.h"
#import "LBFinancialExchangeViewController.h"

#define kHeaderViewH (196 + SafeAreaTopHeight) //headerview的高度
#define kPageMenuH 60 //菜单的高度

@interface LBFinancialCenterViewController ()<UIScrollViewDelegate,SPPageMenuDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
//头部视图
@property (nonatomic, strong) LBFinancialCenterHeaderView *headerView;
//菜单
@property (nonatomic, strong) SPPageMenu *pageMenu;

@property (nonatomic, assign) CGFloat lastPageMenuY;

@property (nonatomic, assign) CGPoint lastPoint;

@end

@implementation LBFinancialCenterViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:nil style:UIBarButtonItemStylePlain target:self action:nil];
    self.navigationController.navigationBar.hidden = YES;
    adjustsScrollViewInsets_NO(self.scrollView, self);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.lastPageMenuY = kHeaderViewH;
    
    [self.view addSubview:self.scrollView];
    [self.view addSubview:self.headerView];
    
    // 添加悬浮菜单
    [self.view addSubview:self.pageMenu];
    
//    if ([[UserModel defaultUser].group_id integerValue] == 8) {//商家身份
        // 添加3个子控制器
        [self addChildViewController:[[LBFinancialCenterMarketvalueViewController alloc] init]];
        [self addChildViewController:[[LBFinancialCenterSaleRecoderViewController alloc] init]];
        [self addChildViewController:[[LBFinancialCenterExchangeRecodervc alloc] init]];
        
//    }else{    //除商家以外的身份
//
//        [self addChildViewController:[[LBFinancialCenterMarketvalueViewController alloc] init]];
//        [self addChildViewController:[[LBFinancialCenterSaleRecoderViewController alloc] init]];
//    }
    
    // 先将第一个子控制的view添加到scrollView上去
    [self.scrollView addSubview:self.childViewControllers[0].view];
    
    // 监听子控制器发出的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(subScrollViewDidScroll:) name:ChildScrollViewDidScrollNSNotificationFinancial  object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshState:) name:ChildScrollViewRefreshStateNSNotificationFinancial object:nil];
}

/**
 出售
 */
-(void)financialSaleEvent{
    
    self.hidesBottomBarWhenPushed = YES;
    LBFinancialCenetrSaleViewController *vc = [[LBFinancialCenetrSaleViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}

/**
 兑换
 */
-(void)financialExchangeEvent{
    self.hidesBottomBarWhenPushed = YES;
    LBFinancialExchangeViewController *vc = [[LBFinancialExchangeViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}

#pragma mark - 通知

// 子控制器上的scrollView已经滑动的代理方法所发出的通知(核心)
- (void)subScrollViewDidScroll:(NSNotification *)noti {
    
    // 取出当前正在滑动的tableView
    UIScrollView *scrollingScrollView = noti.userInfo[@"scrollingScrollView"];
    CGFloat offsetDifference = [noti.userInfo[@"offsetDifference"] floatValue];
    
    CGFloat distanceY;
    
    // 取出的scrollingScrollView并非是唯一的，当有多个子控制器上的scrollView同时滑动时都会发出通知来到这个方法，所以要过滤
    LBFinancialCenterBaseViewController *baseVc = self.childViewControllers[self.pageMenu.selectedItemIndex];
    
    if (scrollingScrollView == baseVc.scrollView && baseVc.isFirstViewLoaded == NO) {
        
        // 让悬浮菜单跟随scrollView滑动
        CGRect pageMenuFrame = self.pageMenu.frame;
        if (pageMenuFrame.origin.y >= SafeAreaTopHeight) {
            // 往上移
            if (offsetDifference > 0 && scrollingScrollView.contentOffset.y+kScrollViewBeginTopInset > 0) {
                
                if (((scrollingScrollView.contentOffset.y+kScrollViewBeginTopInset+self.pageMenu.frame.origin.y)>=kHeaderViewH) || scrollingScrollView.contentOffset.y+kScrollViewBeginTopInset < 0) {
                    // 悬浮菜单的y值等于当前正在滑动且显示在屏幕范围内的的scrollView的contentOffset.y的改变量(这是最难的点)
                    pageMenuFrame.origin.y += -offsetDifference;
                    if (pageMenuFrame.origin.y <= SafeAreaTopHeight) {
                        pageMenuFrame.origin.y = SafeAreaTopHeight;
                    }
                }
            } else { // 往下移
                if ((scrollingScrollView.contentOffset.y+kScrollViewBeginTopInset+self.pageMenu.frame.origin.y)<kHeaderViewH+ 0) {
                    pageMenuFrame.origin.y = -scrollingScrollView.contentOffset.y-kScrollViewBeginTopInset+kHeaderViewH+ 0;
                    if (pageMenuFrame.origin.y >= kHeaderViewH + 0) {
                        pageMenuFrame.origin.y = kHeaderViewH + 0;
                    }
                }
            }
        }
        self.pageMenu.frame = pageMenuFrame;
        
        CGRect headerFrame = self.headerView.frame;
        headerFrame.origin.y = self.pageMenu.frame.origin.y-kHeaderViewH;
        self.headerView.frame = headerFrame;
        
        // 记录悬浮菜单的y值改变量
        distanceY = pageMenuFrame.origin.y - self.lastPageMenuY;
        self.lastPageMenuY = self.pageMenu.frame.origin.y;
        
        // 让其余控制器的scrollView跟随当前正在滑动的scrollView滑动
        [self followScrollingScrollView:scrollingScrollView distanceY:distanceY];
        
        [self changeColorWithOffsetY:-self.pageMenu.frame.origin.y+kHeaderViewH];
    }
    baseVc.isFirstViewLoaded = NO;
}

- (void)followScrollingScrollView:(UIScrollView *)scrollingScrollView distanceY:(CGFloat)distanceY{
    LBFinancialCenterBaseViewController *baseVc = nil;
    for (int i = 0; i < self.childViewControllers.count; i++) {
        baseVc = self.childViewControllers[i];
        if (baseVc.scrollView == scrollingScrollView) {
            continue;
        } else {
            CGPoint contentOffSet = baseVc.scrollView.contentOffset;
            contentOffSet.y += -distanceY;
            baseVc.scrollView.contentOffset = contentOffSet;
        }
    }
}

- (void)refreshState:(NSNotification *)noti {
    BOOL state = [noti.userInfo[@"isRefreshing"] boolValue];
    // 正在刷新时禁止self.scrollView滑动
    self.scrollView.scrollEnabled = !state;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    LBFinancialCenterBaseViewController *baseVc = self.childViewControllers[self.pageMenu.selectedItemIndex];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (baseVc.scrollView.contentSize.height < UIScreenHeight && [baseVc isViewLoaded]) {
            [baseVc.scrollView setContentOffset:CGPointMake(0, -kScrollViewBeginTopInset) animated:YES];
        }
    });
}

/**
 滑动的时候调用
 */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    LBFinancialCenterBaseViewController *baseVc = self.childViewControllers[self.pageMenu.selectedItemIndex];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (baseVc.scrollView.contentSize.height < UIScreenHeight && [baseVc isViewLoaded]) {
            [baseVc.scrollView setContentOffset:CGPointMake(0, -kScrollViewBeginTopInset) animated:YES];
        }
    });
}

#pragma mark - SPPageMenuDelegate
- (void)pageMenu:(SPPageMenu *)pageMenu itemSelectedFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex {
    if (!self.childViewControllers.count) { return;}
    // 如果上一次点击的button下标与当前点击的buton下标之差大于等于2,说明跨界面移动了,此时不动画.
    if (labs(toIndex - fromIndex) >= 2) {
        [self.scrollView setContentOffset:CGPointMake(_scrollView.frame.size.width * toIndex, 0) animated:NO];
    } else {
        [self.scrollView setContentOffset:CGPointMake(_scrollView.frame.size.width * toIndex, 0) animated:YES];
    }
    
    LBFinancialCenterBaseViewController *targetViewController = self.childViewControllers[toIndex];
    // 如果已经加载过，就不再加载
    if ([targetViewController isViewLoaded]) return;
    
    // 来到这里必然是第一次加载控制器的view，这个属性是为了防止下面的偏移量的改变导致走scrollViewDidScroll
    targetViewController.isFirstViewLoaded = YES;
    
    targetViewController.view.frame = CGRectMake(UIScreenWidth*toIndex, 0, UIScreenWidth, UIScreenHeight);
    UIScrollView *s = targetViewController.scrollView;
    CGPoint contentOffset = s.contentOffset;
    contentOffset.y = -self.headerView.frame.origin.y-kScrollViewBeginTopInset;
    if (contentOffset.y + kScrollViewBeginTopInset >= kHeaderViewH) {
        contentOffset.y = kHeaderViewH-kScrollViewBeginTopInset;
    }
    s.contentOffset = contentOffset;
    [self.scrollView addSubview:targetViewController.view];
}


- (void)panGestureRecognizerAction:(UIPanGestureRecognizer *)pan {
    if (pan.state == UIGestureRecognizerStateBegan) {
        
    } else if (pan.state == UIGestureRecognizerStateChanged) {
        CGPoint currenrPoint = [pan translationInView:pan.view];
        CGFloat distanceY = currenrPoint.y - self.lastPoint.y;
        self.lastPoint = currenrPoint;
        
        LBFinancialCenterBaseViewController *baseVc = self.childViewControllers[self.pageMenu.selectedItemIndex];
        CGPoint offset = baseVc.scrollView.contentOffset;
        offset.y += -distanceY;
        if (offset.y <= -kScrollViewBeginTopInset) {
            offset.y = -kScrollViewBeginTopInset;
        }
        baseVc.scrollView.contentOffset = offset;
    } else {
        [pan setTranslation:CGPointZero inView:pan.view];
        self.lastPoint = CGPointZero;
    }
    
}
- (void)changeColorWithOffsetY:(CGFloat)offsetY {
    
    self.headerView.titileLb.alpha = offsetY/(kHeaderViewH - SafeAreaTopHeight);
    self.headerView.saleBt.alpha = 1- offsetY/(kHeaderViewH - SafeAreaTopHeight);
    self.headerView.exchangeBt.alpha = 1- offsetY/(kHeaderViewH - SafeAreaTopHeight);
}

- (UIScrollView *)scrollView {
    
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.frame = CGRectMake(0, 0, UIScreenWidth, UIScreenHeight - 49);
        _scrollView.delegate = self;
        _scrollView.pagingEnabled = YES;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        
//        if ([[UserModel defaultUser].group_id integerValue] == 8) {
        
            _scrollView.contentSize = CGSizeMake(UIScreenWidth*3, 0);
//        }else{
//            _scrollView.contentSize = CGSizeMake(UIScreenWidth*2, 0);
//        }
        
        _scrollView.backgroundColor = [UIColor colorWithWhite:1 alpha:0];
    }
    return _scrollView;
}
- (LBFinancialCenterHeaderView *)headerView {
    
    if (!_headerView) {
        _headerView = [[NSBundle mainBundle]loadNibNamed:@"LBFinancialCenterHeaderView" owner:self options:nil].firstObject;
        _headerView.frame = CGRectMake(0, 0, UIScreenWidth, kHeaderViewH);
        _headerView.autoresizingMask = 0;
        [_headerView.saleBt addTarget:self action:@selector(financialSaleEvent) forControlEvents:UIControlEventTouchUpInside];
         [_headerView.exchangeBt addTarget:self action:@selector(financialExchangeEvent) forControlEvents:UIControlEventTouchUpInside];
    }
    return _headerView;
}

- (SPPageMenu *)pageMenu{
    
    if (!_pageMenu) {
        _pageMenu = [SPPageMenu pageMenuWithFrame:CGRectMake(0, CGRectGetMaxY(self.headerView.frame), UIScreenWidth, kPageMenuH) trackerStyle:SPPageMenuTrackerStyleLineLongerThanItem];
        
//        if([[UserModel defaultUser].group_id integerValue] == 8){
            [_pageMenu setItems:@[@"优购币市值",@"出售记录",@"兑换记录"] selectedItemIndex:0];
//        }else{
//            [_pageMenu setItems:@[@"优购币市值",@"出售记录"] selectedItemIndex:0];
//        }
        _pageMenu.delegate = self;
        _pageMenu.itemTitleFont = [UIFont systemFontOfSize:15];
        _pageMenu.selectedItemTitleColor = YYSRGBColor(251, 77, 83, 1);
        _pageMenu.unSelectedItemTitleColor = [UIColor colorWithWhite:0 alpha:0.6];
        _pageMenu.tracker.backgroundColor = YYSRGBColor(251, 77, 83, 1);
        _pageMenu.permutationWay = SPPageMenuPermutationWayNotScrollEqualWidths;
        _pageMenu.bridgeScrollView = self.scrollView;
        
    }
    return _pageMenu;
}

@end
