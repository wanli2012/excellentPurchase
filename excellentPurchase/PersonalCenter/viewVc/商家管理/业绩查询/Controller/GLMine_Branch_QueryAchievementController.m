//
//  GLMine_Branch_QueryAchievementController.m
//  excellentPurchase
//
//  Created by 龚磊 on 2018/1/25.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "GLMine_Branch_QueryAchievementController.h"
#import "GLMine_Team_HistoryHeader.h"
#import "GLMine_Branch_AchievementController.h"//业绩
#import "GLMine_Team_HistoryDateChooseView.h"//月份选择器

#import "SPPageMenu.h"

@interface GLMine_Branch_QueryAchievementController ()<UIScrollViewDelegate,SPPageMenuDelegate,GLMine_Team_HistoryHeaderDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;

//头部视图
@property (nonatomic, strong) GLMine_Team_HistoryHeader *headerView;

@property (nonatomic, strong) SPPageMenu *pageMenu;

@property (nonatomic, assign) CGFloat lastPageMenuY;

@property (nonatomic, assign) CGPoint lastPoint;

@property (nonatomic, assign)CGFloat kHeaderViewH;
@property (nonatomic, assign)CGFloat kPageMenuH;
@property (nonatomic, assign)CGFloat kGLMine_TeamScrollViewBeginTopInset;

@end

@implementation GLMine_Branch_QueryAchievementController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.kHeaderViewH = 120;
    self.kPageMenuH = 60;
    self.kGLMine_TeamScrollViewBeginTopInset = self.kHeaderViewH + self.kPageMenuH;
    
    adjustsScrollViewInsets_NO(self.scrollView, self);
    
    self.lastPageMenuY = self.kHeaderViewH + SafeAreaTopHeight;
    
    //导航栏设置  右键添加
    [self setNav];
    
    // 添加一个全屏的scrollView
    [self.view addSubview:self.scrollView];
    
    // 添加头部视图
    [self.view addSubview:self.headerView];
    
    // 添加悬浮菜单
    [self.view addSubview:self.pageMenu];
    
    // 添加子控制器
    GLMine_Branch_AchievementController *onlineVC = [[GLMine_Branch_AchievementController alloc] init];
    onlineVC.typeIndex = self.typeIndex;
    onlineVC.type = 1;
    onlineVC.shop_uid = self.shop_uid;
    GLMine_Branch_AchievementController *offlineVC = [[GLMine_Branch_AchievementController alloc] init];
    offlineVC.type = 2;
    offlineVC.typeIndex = self.typeIndex;
    offlineVC.shop_uid = self.shop_uid;
    onlineVC.scrollViewBeginTopInset = self.kGLMine_TeamScrollViewBeginTopInset;
    offlineVC.scrollViewBeginTopInset = self.kGLMine_TeamScrollViewBeginTopInset;
    
    [self addChildViewController:onlineVC];
    [self addChildViewController:offlineVC];
    
    // 先将第一个子控制的view添加到scrollView上去
    [self.scrollView addSubview:self.childViewControllers[0].view];
    
    // 监听子控制器发出的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(subScrollViewDidScroll:) name:GLMine_Team_ChildScrollViewDidScrollNSNotification  object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshState:) name:GLMine_Team_ChildScrollViewRefreshStateNSNotification object:nil];
    
}

#pragma mark - 导航栏设置
- (void)setNav{
    
    self.navigationItem.title = @"业绩查询";
    self.navigationController.navigationBar.hidden = NO;
    
}

#pragma mark - HeaderViewDelegate 日期选择
- (void)dateChoose{
    
    WeakSelf;
    [GLMine_Team_HistoryDateChooseView showDateChooseViewWith:^(NSString *dateStr) {
        
        weakSelf.headerView.dateLabel.text = dateStr;

        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy年MM月"];
        NSDate *date = [dateFormatter dateFromString:dateStr];
        
        NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc] init];
        [dateFormatter2 setDateFormat:@"yyyy-MM"];

        NSString *strDate = [dateFormatter2 stringFromDate:date];
       
        ///此处调 数据更新方法
        [[NSNotificationCenter defaultCenter] postNotificationName:@"AchievementNotification" object:nil userInfo:@{@"month":strDate}];;
        
    }];
}

#pragma mark - 通知
// 子控制器上的scrollView已经滑动的代理方法所发出的通知(核心)
- (void)subScrollViewDidScroll:(NSNotification *)noti {
    
    // 取出当前正在滑动的tableView
    UIScrollView *scrollingScrollView = noti.userInfo[@"scrollingScrollView"];
    CGFloat offsetDifference = [noti.userInfo[@"offsetDifference"] floatValue];
    
    CGFloat distanceY;
    
    // 取出的scrollingScrollView并非是唯一的，当有多个子控制器上的scrollView同时滑动时都会发出通知来到这个方法，所以要过滤
    GLMine_Team_AchieveManageBaseController *baseVc = self.childViewControllers[self.pageMenu.selectedItemIndex];
    
    if (scrollingScrollView == baseVc.scrollView && baseVc.isFirstViewLoaded == NO) {
        
        // 让悬浮菜单跟随scrollView滑动
        CGRect pageMenuFrame = self.pageMenu.frame;
        if (pageMenuFrame.origin.y >= SafeAreaTopHeight) {
            // 往上移
            if (offsetDifference > 0 && scrollingScrollView.contentOffset.y+self.kGLMine_TeamScrollViewBeginTopInset > 0) {
                
                if (((scrollingScrollView.contentOffset.y+self.kGLMine_TeamScrollViewBeginTopInset+self.pageMenu.frame.origin.y)>=self.kHeaderViewH) || scrollingScrollView.contentOffset.y+self.kGLMine_TeamScrollViewBeginTopInset < 0) {
                    // 悬浮菜单的y值等于当前正在滑动且显示在屏幕范围内的的scrollView的contentOffset.y的改变量(这是最难的点)
                    pageMenuFrame.origin.y += -offsetDifference;
                    if (pageMenuFrame.origin.y <= SafeAreaTopHeight) {
                        pageMenuFrame.origin.y = SafeAreaTopHeight;
                    }
                }
            } else { // 往下移
                if ((scrollingScrollView.contentOffset.y+self.kGLMine_TeamScrollViewBeginTopInset+self.pageMenu.frame.origin.y)<self.kHeaderViewH+ SafeAreaTopHeight) {
                    pageMenuFrame.origin.y = -scrollingScrollView.contentOffset.y-self.kGLMine_TeamScrollViewBeginTopInset+self.kHeaderViewH+ SafeAreaTopHeight;
                    if (pageMenuFrame.origin.y >= self.kHeaderViewH + SafeAreaTopHeight) {
                        pageMenuFrame.origin.y = self.kHeaderViewH + SafeAreaTopHeight;
                    }
                }
            }
        }
        self.pageMenu.frame = pageMenuFrame;
        
        CGRect headerFrame = self.headerView.frame;
        headerFrame.origin.y = self.pageMenu.frame.origin.y-self.kHeaderViewH;
        self.headerView.frame = headerFrame;
        
        // 记录悬浮菜单的y值改变量
        distanceY = pageMenuFrame.origin.y - self.lastPageMenuY;
        self.lastPageMenuY = self.pageMenu.frame.origin.y;
        
        // 让其余控制器的scrollView跟随当前正在滑动的scrollView滑动
        [self followScrollingScrollView:scrollingScrollView distanceY:distanceY];
        
        [self changeColorWithOffsetY:-self.pageMenu.frame.origin.y+self.kHeaderViewH];
    }
    baseVc.isFirstViewLoaded = NO;
}

- (void)followScrollingScrollView:(UIScrollView *)scrollingScrollView distanceY:(CGFloat)distanceY{
    GLMine_Team_AchieveManageBaseController *baseVc = nil;
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
    
    GLMine_Team_AchieveManageBaseController *baseVc = self.childViewControllers[self.pageMenu.selectedItemIndex];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        if (baseVc.scrollView.contentSize.height < UIScreenHeight && [baseVc isViewLoaded]) {
            [baseVc.scrollView setContentOffset:CGPointMake(0, -self.kGLMine_TeamScrollViewBeginTopInset) animated:YES];
        }
    });
}

/**
 滑动的时候调用
 */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    GLMine_Team_AchieveManageBaseController *baseVc = self.childViewControllers[self.pageMenu.selectedItemIndex];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (baseVc.scrollView.contentSize.height < UIScreenHeight && [baseVc isViewLoaded]) {
            [baseVc.scrollView setContentOffset:CGPointMake(0, -self.kGLMine_TeamScrollViewBeginTopInset) animated:YES];
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
    
    GLMine_Team_AchieveManageBaseController *targetViewController = self.childViewControllers[toIndex];
    // 如果已经加载过，就不再加载
    if ([targetViewController isViewLoaded]) return;
    
    // 来到这里必然是第一次加载控制器的view，这个属性是为了防止下面的偏移量的改变导致走scrollViewDidScroll
    targetViewController.isFirstViewLoaded = YES;
    
    targetViewController.view.frame = CGRectMake(UIScreenWidth*toIndex, 0, UIScreenWidth, UIScreenHeight);
    UIScrollView *s = targetViewController.scrollView;
    CGPoint contentOffset = s.contentOffset;
    contentOffset.y = -self.headerView.frame.origin.y-self.kGLMine_TeamScrollViewBeginTopInset;
    if (contentOffset.y + self.kGLMine_TeamScrollViewBeginTopInset >= self.kHeaderViewH) {
        contentOffset.y = self.kHeaderViewH-self.kGLMine_TeamScrollViewBeginTopInset;
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
        
        GLMine_Team_AchieveManageBaseController *baseVc = self.childViewControllers[self.pageMenu.selectedItemIndex];
        CGPoint offset = baseVc.scrollView.contentOffset;
        offset.y += -distanceY;
        if (offset.y <= -self.kGLMine_TeamScrollViewBeginTopInset) {
            offset.y = -self.kGLMine_TeamScrollViewBeginTopInset;
        }
        baseVc.scrollView.contentOffset = offset;
    } else {
        [pan setTranslation:CGPointZero inView:pan.view];
        self.lastPoint = CGPointZero;
    }
    
}

- (void)changeColorWithOffsetY:(CGFloat)offsetY {
    
}

- (UIScrollView *)scrollView {
    
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.frame = CGRectMake(0, SafeAreaTopHeight, UIScreenWidth, UIScreenHeight - SafeAreaTopHeight);
        _scrollView.delegate = self;
        _scrollView.pagingEnabled = YES;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.contentSize = CGSizeMake(UIScreenWidth*2, 0);
        _scrollView.backgroundColor = [UIColor colorWithWhite:1 alpha:0];
    }
    return _scrollView;
}

- (GLMine_Team_HistoryHeader *)headerView {
    
    if (!_headerView) {
        _headerView = [[GLMine_Team_HistoryHeader alloc] initWithFrame:CGRectMake(0, SafeAreaTopHeight, UIScreenWidth, _kHeaderViewH)];
        _headerView.delegate = self;
    }
    return _headerView;
}

- (SPPageMenu *)pageMenu {
    
    if (!_pageMenu) {
        _pageMenu = [SPPageMenu pageMenuWithFrame:CGRectMake(0, CGRectGetMaxY(self.headerView.frame), UIScreenWidth, _kPageMenuH) trackerStyle:SPPageMenuTrackerStyleLineLongerThanItem];
        [_pageMenu setItems:@[@"线上业绩",@"线下业绩"] selectedItemIndex:0];
        _pageMenu.delegate = self;
        _pageMenu.itemTitleFont = [UIFont systemFontOfSize:16];
        _pageMenu.selectedItemTitleColor = MAIN_COLOR;
        _pageMenu.unSelectedItemTitleColor = [UIColor colorWithWhite:0 alpha:0.6];
        _pageMenu.tracker.backgroundColor = MAIN_COLOR;
        _pageMenu.permutationWay = SPPageMenuPermutationWayNotScrollEqualWidths;
        _pageMenu.bridgeScrollView = self.scrollView;
        //        _pageMenu.closeTrackerFollowingMode = NO;
        
        
    }
    return _pageMenu;
}

@end
