//
//  LBFinishMainViewController.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/1/24.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "LBFinishMainViewController.h"
#import "UIButton+SetEdgeInsets.h"
#import "LBFinishMainHeaderView.h"
#import "SPPageMenu.h"
#import "LBStoreInformationViewController.h"
#import "LBFinishAmendPhotosViewController.h"
#import "LBEat_StoreCommentsViewController.h"
#import "LBStoreCounterMainViewController.h"
#import "LBBaseFinishProductsViewController.h"
#import "LBFinishProductsViewController.h"

#import "GLFinishMainModel.h"

#define kHeaderViewH 70 //headerview的高度
#define pageMenuH 50   //菜单高度

@interface LBFinishMainViewController ()<SPPageMenuDelegate,UIScrollViewDelegate>

@property (nonatomic, strong) SPPageMenu *pageMenu;
@property (nonatomic, strong) UIScrollView *scrollView;
//头部视图
@property (nonatomic, strong) LBFinishMainHeaderView *headerView;

@property (nonatomic, assign) CGFloat lastPageMenuY;

@property (nonatomic, assign) CGPoint lastPoint;

@property (weak, nonatomic) IBOutlet UIButton *signBt;//换牌照
@property (weak, nonatomic) IBOutlet UIButton *databt;//修改资料
@property (weak, nonatomic) IBOutlet UIButton *counterBt;//我的货柜
@property (weak, nonatomic) IBOutlet UIButton *replyBt;//回复评论

@property (nonatomic, strong)GLFinishMainModel *model;

@end

@implementation LBFinishMainViewController

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    adjustsScrollViewInsets_NO(self.scrollView, self);
    self.navigationController.navigationBar.hidden = NO;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"我的小店";
    
    self.lastPageMenuY = kHeaderViewH + SafeAreaTopHeight;
    
    [self.view addSubview:self.scrollView];
    [self.view addSubview:self.headerView];
    // 添加悬浮菜单
    [self.view addSubview:self.pageMenu];
    
    // 添加3个子控制器
    LBFinishProductsViewController *vc = [[LBFinishProductsViewController alloc] init];
    vc.type = 1;
    LBFinishProductsViewController *vc2 = [[LBFinishProductsViewController alloc] init];
    vc.type = 2;
    [self addChildViewController:vc];
    [self addChildViewController:vc2];
//    [self addChildViewController:[[LBFinishProductsViewController alloc] init]];
    // 先将第一个子控制的view添加到scrollView上去
    [self.scrollView addSubview:self.childViewControllers[0].view];
    
    // 监听子控制器发出的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(subScrollViewDidScroll:) name:ChildScrollViewDidScrollNSNotificationFinancial2  object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshState:) name:ChildScrollViewRefreshStateNSNotificationFinancial2 object:nil];

    [self postRequest];//请求数据
}

#pragma mark - 请求店铺信息
- (void)postRequest{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"app_handler"] = @"SEARCH";
    dic[@"token"] = [UserModel defaultUser].token;
    dic[@"uid"] = [UserModel defaultUser].uid;
    
    [EasyShowLodingView showLoding];
    [NetworkManager requestPOSTWithURLStr:kstore_info paramDic:dic finish:^(id responseObject) {
        
        [EasyShowLodingView hidenLoding];
        
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE) {
            
            GLFinishMainModel *model = [GLFinishMainModel mj_objectWithKeyValues:responseObject[@"data"]];
            self.model = model;
            [self assignment];//赋值
            
        }else{
            [EasyShowTextView showErrorText:responseObject[@"message"]];
        }
    } enError:^(NSError *error) {
        [EasyShowLodingView hidenLoding];
        [EasyShowTextView showErrorText:error.localizedDescription];
    }];
}

#pragma mark - 赋值
- (void)assignment{
    
    [self.headerView.picImageV sd_setImageWithURL:[NSURL URLWithString:self.model.store_thumb] placeholderImage:[UIImage imageNamed:PlaceHolder]];
    
    self.headerView.nameLabel.text = self.model.store_name;
    self.headerView.storeTypeLabel.text = [NSString stringWithFormat:@"店铺类型:%@", self.model.typename];
    self.headerView.fansLabel.text = [NSString stringWithFormat:@"%@粉丝",self.model.ct];
    self.headerView.totalSaleLabel.text = [NSString stringWithFormat:@"总销售量:%@件", self.model.salenum];
    
}

#pragma mark - 底部功能
/**
 换招牌照
 */
- (IBAction)amendSignEvent:(UIButton *)sender {
    self.hidesBottomBarWhenPushed = YES;
    LBFinishAmendPhotosViewController *vc = [[LBFinishAmendPhotosViewController alloc]init];
    vc.store_id = self.model.store_id;
    [self.navigationController pushViewController:vc animated:YES];
}

/**
 修改资料
 */
- (IBAction)amendinfoEvent:(UIButton *)sender {
    self.hidesBottomBarWhenPushed = YES;
    LBStoreInformationViewController *vc = [[LBStoreInformationViewController alloc]init];
    vc.store_id = self.model.store_id;
    [self.navigationController pushViewController:vc animated:YES];
}

/**
 修改货柜
 */
- (IBAction)amendGoodsEvent:(UIButton *)sender {
    self.hidesBottomBarWhenPushed = YES;
    LBStoreCounterMainViewController *vc = [[LBStoreCounterMainViewController alloc]init];
    vc.store_id = self.model.store_id;
    [self.navigationController pushViewController:vc animated:YES];
}

/**
 回复评论
 */
- (IBAction)replyEvent:(UIButton *)sender {
    self.hidesBottomBarWhenPushed = YES;
    LBEat_StoreCommentsViewController *vc = [[LBEat_StoreCommentsViewController alloc]init];
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
    LBBaseFinishProductsViewController *baseVc = self.childViewControllers[self.pageMenu.selectedItemIndex];
    
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
        
        
        [self changeColorWithOffsetY:-self.pageMenu.frame.origin.y+kHeaderViewH];
    }
    baseVc.isFirstViewLoaded = NO;
}


- (void)followScrollingScrollView:(UIScrollView *)scrollingScrollView distanceY:(CGFloat)distanceY{
    LBBaseFinishProductsViewController *baseVc = nil;
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
    
    LBBaseFinishProductsViewController *baseVc = self.childViewControllers[self.pageMenu.selectedItemIndex];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (baseVc.scrollView.contentSize.height < (UIScreenHeight) && [baseVc isViewLoaded]) {
            [baseVc.scrollView setContentOffset:CGPointMake(0, -kScrollViewBeginTopInset) animated:YES];
        }
    });
}

/**
 滑动的时候调用
 */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    LBBaseFinishProductsViewController *baseVc = self.childViewControllers[self.pageMenu.selectedItemIndex];
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
    
    LBBaseFinishProductsViewController *targetViewController = self.childViewControllers[toIndex];
    // 如果已经加载过，就不再加载
    if ([targetViewController isViewLoaded]){
        return;
    };
    
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
        
        LBBaseFinishProductsViewController *baseVc = self.childViewControllers[self.pageMenu.selectedItemIndex];
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

- (UIScrollView *)scrollView {
    
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.frame = CGRectMake(0, SafeAreaTopHeight, UIScreenWidth, UIScreenHeight-SafeAreaTopHeight - 55);
        _scrollView.delegate = self;
        _scrollView.pagingEnabled = YES;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.contentSize = CGSizeMake(UIScreenWidth*2, 0);
        _scrollView.backgroundColor = [UIColor colorWithWhite:1 alpha:0];
    }
    return _scrollView;
}
- (LBFinishMainHeaderView *)headerView {
    
    if (!_headerView) {
        _headerView = [[NSBundle mainBundle]loadNibNamed:@"LBFinishMainHeaderView" owner:self options:nil].firstObject;
        _headerView.frame = CGRectMake(0, SafeAreaTopHeight, UIScreenWidth, kHeaderViewH);
        _headerView.autoresizingMask = 0;
        
    }
    return _headerView;
}
- (SPPageMenu *)pageMenu{
    
    if (!_pageMenu) {
        _pageMenu = [SPPageMenu pageMenuWithFrame:CGRectMake(0, CGRectGetMaxY(self.headerView.frame), UIScreenWidth, pageMenuH) trackerStyle:SPPageMenuTrackerStyleLineLongerThanItem];
//        [_pageMenu setItems:@[@"海淘商品",@"吃喝玩乐",@"活动商品"] selectedItemIndex:0];
        [_pageMenu setItems:@[@"海淘商品",@"吃喝玩乐"] selectedItemIndex:0];
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

-(void)updateViewConstraints{
    [super updateViewConstraints];
    
     [self.signBt verticalCenterImageAndTitle:5];
     [self.databt verticalCenterImageAndTitle:5];
     [self.counterBt verticalCenterImageAndTitle:5];
     [self.replyBt verticalCenterImageAndTitle:5];
    
}

@end
