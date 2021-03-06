//
//  GLMine_Team_AchievementManageController.m
//  excellentPurchase
//
//  Created by 龚磊 on 2018/1/17.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "GLMine_Team_AchievementManageController.h"
#import "GLMine_Team_AchieveManageHeader.h"
#import "GLMine_Team_AchieveDoneController.h"//下属完成业绩
#import "GLMine_Team_AchieveNotDoneController.h"//下属未完成业绩
#import "SPPageMenu.h"

#import "GLMine_Team_MonthAchieveManageController.h"//当月绩效设置
#import "GLMine_Team_HistoryRecordController.h"//历史记录


@interface GLMine_Team_AchievementManageController ()<UIScrollViewDelegate,SPPageMenuDelegate,GLMine_Team_AchieveManageHeaderDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
//头部视图
@property (nonatomic, strong) GLMine_Team_AchieveManageHeader *headerView;
//@property (nonatomic, strong)GLMine_Team_HistoryHeader *historyHeader;

@property (nonatomic, strong) SPPageMenu *pageMenu;

@property (nonatomic, assign) CGFloat lastPageMenuY;

@property (nonatomic, assign) CGPoint lastPoint;

@property (nonatomic, assign)CGFloat kHeaderViewH;
@property (nonatomic, assign)CGFloat kPageMenuH;
@property (nonatomic, assign)CGFloat kGLMine_TeamScrollViewBeginTopInset;

@end

@implementation GLMine_Team_AchievementManageController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.kHeaderViewH = 240;
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
    GLMine_Team_AchieveDoneController *doneVC = [[GLMine_Team_AchieveDoneController alloc] init];
    GLMine_Team_AchieveNotDoneController *notDoneVC = [[GLMine_Team_AchieveNotDoneController alloc] init];
    
    doneVC.scrollViewBeginTopInset = self.kGLMine_TeamScrollViewBeginTopInset;
    notDoneVC.scrollViewBeginTopInset = self.kGLMine_TeamScrollViewBeginTopInset;
    
    [self addChildViewController:doneVC];
    [self addChildViewController:notDoneVC];
    // 先将第一个子控制的view添加到scrollView上去
    [self.scrollView addSubview:self.childViewControllers[0].view];
    
    // 监听子控制器发出的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(subScrollViewDidScroll:) name:GLMine_Team_ChildScrollViewDidScrollNSNotification  object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshState:) name:GLMine_Team_ChildScrollViewRefreshStateNSNotification object:nil];
    
    [self getpersonInfo];//请求数据
    
}

-(void)getpersonInfo{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"app_handler"] = @"SEARCH";
    dic[@"uid"] = [UserModel defaultUser].uid;
    dic[@"token"] = [UserModel defaultUser].token;
    dic[@"group_id"] = [UserModel defaultUser].group_id;
    
    [EasyShowLodingView showLodingText:@"数据请求中"];
    [NetworkManager requestPOSTWithURLStr:kteam_appraisals paramDic:dic finish:^(id responseObject) {
        
        [EasyShowLodingView hidenLoding];
        
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE) {
            [self.headerView.headImage sd_setImageWithURL:[NSURL URLWithString:responseObject[@"data"][@"pic"]] placeholderImage:[UIImage imageNamed:@"shangpinxiangqing"]];
            self.headerView.namelb.text = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"truename"]];
            if ([NSString StringIsNullOrEmpty:self.headerView.namelb.text] == YES) {
                self.headerView.namelb.text = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"nickname"]];
            }
            self.headerView.uidtsr.text = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"user_name"]];
            self.headerView.planlb.text = [NSString stringWithFormat:@"¥%@",responseObject[@"data"][@"set_money"]];
            self.headerView.donelb.text = [NSString stringWithFormat:@"¥%@",responseObject[@"data"][@"done_money"]];
            
        }else{
            
            [EasyShowTextView showErrorText:responseObject[@"message"]];
        }
    } enError:^(NSError *error) {
        
        [EasyShowLodingView hidenLoding];
        [EasyShowTextView showErrorText:error.localizedDescription];
    }];
}

#pragma mark - 导航栏设置
- (void)setNav{
    
    self.navigationItem.title = @"绩效管理";
    self.navigationController.navigationBar.hidden = NO;
    
    UIButton *button=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 80, 44)];
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;//右对齐
    
    [button setTitle:@"历史记录" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont systemFontOfSize:13]];
    button.backgroundColor = [UIColor clearColor];
    [button addTarget:self action:@selector(historyRecord) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];

}

#pragma mark - 历史记录
/**
 历史记录
 */
- (void)historyRecord {
    self.hidesBottomBarWhenPushed = YES;
    GLMine_Team_HistoryRecordController *recordVC = [[GLMine_Team_HistoryRecordController alloc] init];
    [self.navigationController pushViewController:recordVC animated:YES];
}

#pragma mark - 设置布置绩效
- (void)setAchieveMent{
    
    self.hidesBottomBarWhenPushed = YES;
    GLMine_Team_MonthAchieveManageController *setVC = [[GLMine_Team_MonthAchieveManageController alloc] init];
    [self.navigationController pushViewController:setVC animated:YES];
    
}
#pragma mark - 日期选择
- (void)dateChoose{
    NSLog(@"日期选择");
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

- (GLMine_Team_AchieveManageHeader *)headerView {
    
    if (!_headerView) {
        _headerView = [[GLMine_Team_AchieveManageHeader alloc] initWithFrame:CGRectMake(0, SafeAreaTopHeight, UIScreenWidth, _kHeaderViewH)];
        _headerView.delegate = self;
    }
    return _headerView;
}

- (SPPageMenu *)pageMenu {
    
    if (!_pageMenu) {
        _pageMenu = [SPPageMenu pageMenuWithFrame:CGRectMake(0, CGRectGetMaxY(self.headerView.frame), UIScreenWidth, _kPageMenuH) trackerStyle:SPPageMenuTrackerStyleLineLongerThanItem];
        [_pageMenu setItems:@[@"下属绩效已完成",@"下属绩效未完成"] selectedItemIndex:0];
        _pageMenu.delegate = self;
        _pageMenu.itemTitleFont = [UIFont systemFontOfSize:17];
        _pageMenu.selectedItemTitleColor = YYSRGBColor(251, 77, 83, 1);
        _pageMenu.unSelectedItemTitleColor = [UIColor colorWithWhite:0 alpha:0.6];
        _pageMenu.tracker.backgroundColor = [UIColor redColor];
        _pageMenu.permutationWay = SPPageMenuPermutationWayNotScrollEqualWidths;
        _pageMenu.bridgeScrollView = self.scrollView;
        
    }
    return _pageMenu;
}

@end
