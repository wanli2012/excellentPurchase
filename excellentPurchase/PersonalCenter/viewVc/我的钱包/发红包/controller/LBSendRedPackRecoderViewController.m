//
//  LBSendRedPackRecoderViewController.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/1/11.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "LBSendRedPackRecoderViewController.h"
#import "LBSendRedPackHeaderV.h"
#import "LBSendRedPackMenu.h"
#import "LBSendRedPackRecoderReciveVc.h"
#import "LBSendRedPackRecoderSendVc.h"
#import "LBSendRedPackRecoderBasevc.h"
#import "SPPageMenu.h"
#import "LBSendRedPackViewController.h"

#define kHeaderViewH 150  //headerview的高度
#define kPageMenuH 60 //菜单的高度

@interface LBSendRedPackRecoderViewController ()<UIScrollViewDelegate,SPPageMenuDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
//头部视图
@property (nonatomic, strong) LBSendRedPackHeaderV *headerView;
//菜单
//@property (nonatomic, strong) LBSendRedPackMenu *pageMenu;

@property (nonatomic, strong) SPPageMenu *pageMenu;

@property (nonatomic, assign) CGFloat lastPageMenuY;

@property (nonatomic, assign) CGPoint lastPoint;

@end

@implementation LBSendRedPackRecoderViewController

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"我的红包";
    adjustsScrollViewInsets_NO(self.scrollView, self);
    self.navigationController.navigationBar.hidden = NO;
    self.lastPageMenuY = kHeaderViewH + SafeAreaTopHeight;
    
    // 添加一个全屏的scrollView
    [self.view addSubview:self.scrollView];
    
    // 添加头部视图
    [self.view addSubview:self.headerView];
    
    // 添加悬浮菜单
    [self.view addSubview:self.pageMenu];
    
    // 添加4个子控制器
    [self addChildViewController:[[LBSendRedPackRecoderSendVc alloc] init]];
    [self addChildViewController:[[LBSendRedPackRecoderReciveVc alloc] init]];
    // 先将第一个子控制的view添加到scrollView上去
    [self.scrollView addSubview:self.childViewControllers[0].view];
    
    // 监听子控制器发出的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(subScrollViewDidScroll:) name:ChildScrollViewDidScrollNSNotification  object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshState:) name:ChildScrollViewRefreshStateNSNotification object:nil];

    
    UIButton *button=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 80, 44)];
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;//右对齐
    [button setTitle:@"发红包" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont systemFontOfSize:13]];
    button.backgroundColor = [UIColor clearColor];
    [button addTarget:self action:@selector(sendRedpack) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
}

-(void)sendRedpack{
    self.hidesBottomBarWhenPushed = YES;
    LBSendRedPackViewController *vc = [[LBSendRedPackViewController alloc]init];
    WeakSelf;
    vc.refreshdata = ^{
        [weakSelf refreshRequest];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"rfreshRedPack" object:nil];
    };
    [self.navigationController pushViewController:vc animated:YES];
    
}

#pragma mark - 通知

// 子控制器上的scrollView已经滑动的代理方法所发出的通知(核心)
- (void)subScrollViewDidScroll:(NSNotification *)noti {

    // 取出当前正在滑动的tableView
    UIScrollView *scrollingScrollView = noti.userInfo[@"scrollingScrollView"];
    CGFloat offsetDifference = [noti.userInfo[@"offsetDifference"] floatValue];

    CGFloat distanceY;

    // 取出的scrollingScrollView并非是唯一的，当有多个子控制器上的scrollView同时滑动时都会发出通知来到这个方法，所以要过滤
    LBSendRedPackRecoderBasevc *baseVc = self.childViewControllers[self.pageMenu.selectedItemIndex];

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
                if ((scrollingScrollView.contentOffset.y+kScrollViewBeginTopInset+self.pageMenu.frame.origin.y)<kHeaderViewH+ SafeAreaTopHeight) {
                    pageMenuFrame.origin.y = -scrollingScrollView.contentOffset.y-kScrollViewBeginTopInset+kHeaderViewH+ SafeAreaTopHeight;
                    if (pageMenuFrame.origin.y >= kHeaderViewH + SafeAreaTopHeight) {
                        pageMenuFrame.origin.y = kHeaderViewH + SafeAreaTopHeight;
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
    LBSendRedPackRecoderBasevc *baseVc = nil;
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
  
    LBSendRedPackRecoderBasevc *baseVc = self.childViewControllers[self.pageMenu.selectedItemIndex];
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
 
    LBSendRedPackRecoderBasevc *baseVc = self.childViewControllers[self.pageMenu.selectedItemIndex];
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

    LBSendRedPackRecoderBasevc *targetViewController = self.childViewControllers[toIndex];
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
        
        LBSendRedPackRecoderBasevc *baseVc = self.childViewControllers[self.pageMenu.selectedItemIndex];
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
   
}

#pragma mark - 刷新接口
- (void)refreshRequest{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"app_handler"] = @"SEARCH";
    dict[@"uid"] = [UserModel defaultUser].uid;
    dict[@"token"] = [UserModel defaultUser].token;
    
    [NetworkManager requestPOSTWithURLStr:krefresh paramDic:dict finish:^(id responseObject) {
        
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE) {
            
            [UserModel defaultUser].phone = [self judgeStringIsNull:responseObject[@"data"][@"phone"] andDefault:NO];
            [UserModel defaultUser].user_name = [self judgeStringIsNull:responseObject[@"data"][@"user_name"] andDefault:NO];
            [UserModel defaultUser].truename = [self judgeStringIsNull:responseObject[@"data"][@"truename"] andDefault:NO];
            [UserModel defaultUser].tg_status = [self judgeStringIsNull:responseObject[@"data"][@"tg_status"] andDefault:NO];
            [UserModel defaultUser].del = [self judgeStringIsNull:responseObject[@"data"][@"del"] andDefault:NO];
            [UserModel defaultUser].pic = [self judgeStringIsNull:responseObject[@"data"][@"pic"] andDefault:NO];
            [UserModel defaultUser].group_id = [self judgeStringIsNull:responseObject[@"data"][@"group_id"] andDefault:NO];
            [UserModel defaultUser].group_name = [self judgeStringIsNull:responseObject[@"data"][@"group_name"] andDefault:NO];
            [UserModel defaultUser].nick_name = [self judgeStringIsNull:responseObject[@"data"][@"nick_name"] andDefault:NO];
            [UserModel defaultUser].rzstatus = [self judgeStringIsNull:responseObject[@"data"][@"rzstatus"] andDefault:NO];
            [UserModel defaultUser].tjr_name = [self judgeStringIsNull:responseObject[@"data"][@"tjr_name"] andDefault:NO];
            [UserModel defaultUser].tjr_group = [self judgeStringIsNull:responseObject[@"data"][@"tjr_group"] andDefault:NO];
            [UserModel defaultUser].voucher_ratio = [self judgeStringIsNull:responseObject[@"data"][@"voucher_ratio"] andDefault:NO];
            [UserModel defaultUser].mark = [self judgeStringIsNull:responseObject[@"data"][@"mark"] andDefault:YES];
            [UserModel defaultUser].balance = [self judgeStringIsNull:responseObject[@"data"][@"balance"] andDefault:YES];
            [UserModel defaultUser].shopping_voucher = [self judgeStringIsNull:responseObject[@"data"][@"shopping_voucher"] andDefault:YES];
            [UserModel defaultUser].keti_bean = [self judgeStringIsNull:responseObject[@"data"][@"keti_bean"] andDefault:YES];
            [UserModel defaultUser].currency = [self judgeStringIsNull:responseObject[@"data"][@"currency"] andDefault:YES];
            [UserModel defaultUser].Total_money = [self judgeStringIsNull:responseObject[@"data"][@"Total_money"] andDefault:YES];
            [UserModel defaultUser].Total_mark = [self judgeStringIsNull:responseObject[@"data"][@"Total_mark"] andDefault:YES];
            [UserModel defaultUser].Total_currency = [self judgeStringIsNull:responseObject[@"data"][@"Total_currency"] andDefault:YES];
            [UserModel defaultUser].money_sum = [self judgeStringIsNull:responseObject[@"data"][@"money_sum"] andDefault:YES];
            
            [usermodelachivar achive];
            
            self.headerView.integrallb.text = [UserModel defaultUser].mark;
            self.headerView.blessinglb.text = [UserModel defaultUser].keti_bean;
            
        }else{
            
            [EasyShowTextView showErrorText:responseObject[@"message"]];
        }
        
    } enError:^(NSError *error) {
        
        [EasyShowTextView showErrorText:error.localizedDescription];
        
    }];
}
//判空 给数字设置默认值
- (NSString *)judgeStringIsNull:(id )sender andDefault:(BOOL)isNeedDefault{
    
    NSString *str = [NSString stringWithFormat:@"%@",sender];
    
    if ([NSString StringIsNullOrEmpty:str]) {
        
        if (isNeedDefault) {
            return @"0.00";
        }else{
            return @"";
            
        }
    }else{
        return str;
    }
}
- (UIScrollView *)scrollView {
    
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.frame = CGRectMake(0, SafeAreaTopHeight, UIScreenWidth, UIScreenHeight-SafeAreaBottomHeight);
        _scrollView.delegate = self;
        _scrollView.pagingEnabled = YES;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.contentSize = CGSizeMake(UIScreenWidth*2, 0);
        _scrollView.backgroundColor = [UIColor colorWithWhite:1 alpha:0];
    }
    return _scrollView;
}
- (LBSendRedPackHeaderV *)headerView {
    
    if (!_headerView) {
        _headerView = [[LBSendRedPackHeaderV alloc] initWithFrame:CGRectMake(0, SafeAreaTopHeight, UIScreenWidth, kHeaderViewH)];
        _headerView.integrallb.text = [UserModel defaultUser].mark;
        _headerView.blessinglb.text = [UserModel defaultUser].keti_bean;
    }
    return _headerView;
}

- (SPPageMenu *)pageMenu{
    
    if (!_pageMenu) {
        _pageMenu = [SPPageMenu pageMenuWithFrame:CGRectMake(0, CGRectGetMaxY(self.headerView.frame), UIScreenWidth, kPageMenuH) trackerStyle:SPPageMenuTrackerStyleLineLongerThanItem];
        [_pageMenu setItems:@[@"收到红包",@"发出红包"] selectedItemIndex:0];
        _pageMenu.delegate = self;
        _pageMenu.itemTitleFont = [UIFont systemFontOfSize:17];
        _pageMenu.selectedItemTitleColor = YYSRGBColor(251, 77, 83, 1);
        _pageMenu.unSelectedItemTitleColor = [UIColor colorWithWhite:0 alpha:0.6];
        _pageMenu.tracker.backgroundColor = [UIColor clearColor];
        _pageMenu.permutationWay = SPPageMenuPermutationWayNotScrollEqualWidths;
        _pageMenu.bridgeScrollView = self.scrollView;
        
    }
    return _pageMenu;
}

@end
