//
//  LBHomeViewActivityViewController.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/2/9.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "LBHomeViewActivityViewController.h"
#import "LBHomeViewActivityHeaderView.h"
#import "SPPageMenu.h"
#import "LBHomeOneDolphinAllViewController.h"
#import "LBHomeOneDolphinIngViewController.h"
#import "LBHomeOneDolphinWaitViewController.h"
#import "LBHomeViewActivityHistoryModel.h"
#import "CountDown.h"
#import "LBHomeOneDolphinDetailController.h"

#define kHeaderViewH   ((UIScreenWidth - 22)/3.0  +  90)//headerview的高度
#define kPageMenuH 60 //菜单的高度

@interface LBHomeViewActivityViewController ()<UIScrollViewDelegate,SPPageMenuDelegate>

@property (nonatomic, weak) SPPageMenu *pageMenu;
@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableArray *myChildViewControllers;
@property (nonatomic, strong) NSMutableArray *controllerClassNames;
@property (nonatomic, strong) NSArray *menuArr;
@property (nonatomic, strong) NSMutableArray *dataArr;
//头部视图
@property (nonatomic, strong) LBHomeViewActivityHeaderView *headerView;

@property (nonatomic, strong) CountDown *countDown;

@end

@implementation LBHomeViewActivityViewController

-(void)dealloc{
    [self.countDown destoryTimer];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = self.titileStr;
     adjustsScrollViewInsets_NO(self.scrollView, self);
    
    [self requestDataSorce];//请求数据
    
//    [self addMenu];//加载菜单
    
    [self.countDown countDownWithPER_SECBlock:^{
        
        [[NSNotificationCenter defaultCenter]postNotificationName:@"countDownoneDolphin" object:nil];
    }];
    
}
-(void)requestDataSorce{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"app_handler"] = @"SEARCH";
    dic[@"type"] = @"0";
    dic[@"page"] = @"1";
    
    [EasyShowLodingView showLoding];
    [NetworkManager requestPOSTWithURLStr:kIndianaindiana_main paramDic:dic finish:^(id responseObject) {
        
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE) {
            
            for (NSDictionary *dic in responseObject[@"data"][@"history"]) {
                LBHomeViewActivityHistoryModel *model = [LBHomeViewActivityHistoryModel mj_objectWithKeyValues:dic];
                [self.dataArr addObject:model];
            }
            if (self.dataArr.count > 0) {
                [self.view addSubview:self.headerView];
            }
            [self addMenu];//加载菜单
            
            self.headerView.dataArr = self.dataArr;
        }else{
            
            [EasyShowTextView showErrorText:responseObject[@"message"]];
        }
         [EasyShowLodingView hidenLoding];
    } enError:^(NSError *error) {
        [EasyShowLodingView hidenLoding];
    }];
    
}

-(void)addMenu{
    
    // trackerStyle:跟踪器的样式
    SPPageMenu *pageMenu;
    if (self.dataArr.count > 0) {
        pageMenu = [SPPageMenu pageMenuWithFrame:CGRectMake(0, SafeAreaTopHeight + kHeaderViewH, UIScreenWidth, kPageMenuH) trackerStyle:SPPageMenuTrackerStyleLine];
    }else{
        pageMenu = [SPPageMenu pageMenuWithFrame:CGRectMake(0, SafeAreaTopHeight, UIScreenWidth, kPageMenuH) trackerStyle:SPPageMenuTrackerStyleLine];
    }
    // 传递数组，默认选中第1个
    [pageMenu setItems:self.menuArr selectedItemIndex:0];
    pageMenu.showFuntionButton = NO;
    pageMenu.permutationWay = SPPageMenuPermutationWayNotScrollEqualWidths;
    
    // 设置代理
    pageMenu.delegate = self;
    pageMenu.itemTitleFont = [UIFont systemFontOfSize:15];
    pageMenu.selectedItemTitleColor = YYSRGBColor(251, 73, 80, 1);
    pageMenu.unSelectedItemTitleColor = YYSRGBColor(118, 118, 118, 1);
    pageMenu.dividingLine.backgroundColor = [UIColor clearColor];
    pageMenu.tracker.backgroundColor = YYSRGBColor(251, 73, 80, 1);
    self.pageMenu.selectedItemIndex = 0;
    [self.view addSubview:pageMenu];
    _pageMenu = pageMenu;
    
    for (int i = 0; i < self.menuArr.count; i++) {
        if (self.controllerClassNames.count > i) {
            UIViewController *baseVc = [[NSClassFromString(self.controllerClassNames[i]) alloc] init];
            //            NSString *text = [self.pageMenu titleForItemAtIndex:i];
            [self addChildViewController:baseVc];
            // 控制器本来自带childViewControllers,但是遗憾的是该数组的元素顺序永远无法改变，只要是addChildViewController,都是添加到最后一个，而控制器不像数组那样，可以插入或删除任意位置，所以这里自己定义可变数组，以便插入(删除)(如果没有插入(删除)功能，直接用自带的childViewControllers即可)
            [self.myChildViewControllers addObject:baseVc];
        }
    }
    UIScrollView *scrollView;
    if (self.dataArr.count > 0) {
        scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, SafeAreaTopHeight+kPageMenuH+kHeaderViewH, UIScreenWidth, UIScreenHeight - SafeAreaTopHeight - kPageMenuH - kHeaderViewH)];
    }else{
        scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, SafeAreaTopHeight+kPageMenuH, UIScreenWidth, UIScreenHeight - SafeAreaTopHeight - kPageMenuH)];
    }
    scrollView.delegate = self;
    scrollView.pagingEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
    
    // 这一行赋值，可实现pageMenu的跟踪器时刻跟随scrollView滑动的效果
    self.pageMenu.bridgeScrollView = self.scrollView;
    
    // pageMenu.selectedItemIndex就是选中的item下标
    if (self.pageMenu.selectedItemIndex < self.myChildViewControllers.count) {
        UIViewController *baseVc = self.myChildViewControllers[self.pageMenu.selectedItemIndex];
        [scrollView addSubview:baseVc.view];
       
        baseVc.view.frame = CGRectMake(UIScreenWidth*self.pageMenu.selectedItemIndex, 0, UIScreenWidth, self.scrollView.height);
        
        scrollView.contentOffset = CGPointMake(UIScreenWidth*self.pageMenu.selectedItemIndex, 0);
        scrollView.contentSize = CGSizeMake(self.menuArr.count*UIScreenWidth, 0);
    }
    
}

#pragma mark - SPPageMenu的代理方法

- (void)pageMenu:(SPPageMenu *)pageMenu itemSelectedAtIndex:(NSInteger)index {
    
}

- (void)pageMenu:(SPPageMenu *)pageMenu itemSelectedFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex {
    
    // 如果fromIndex与toIndex之差大于等于2,说明跨界面移动了,此时不动画.
    if (labs(toIndex - fromIndex) >= 2) {
        [self.scrollView setContentOffset:CGPointMake(UIScreenWidth * toIndex, 0) animated:NO];
    } else {
        [self.scrollView setContentOffset:CGPointMake(UIScreenWidth * toIndex, 0) animated:YES];
    }
    if (self.myChildViewControllers.count <= toIndex) {return;}
    
    UIViewController *targetViewController = self.myChildViewControllers[toIndex];
    // 如果已经加载过，就不再加载
    if ([targetViewController isViewLoaded]) return;
   
    targetViewController.view.frame = CGRectMake(UIScreenWidth * toIndex, 0, UIScreenWidth, self.scrollView.height);

    [_scrollView addSubview:targetViewController.view];
    
}

-(NSArray*)menuArr{
    
    if (!_menuArr) {
        _menuArr = [NSArray arrayWithObjects:@"全部夺宝",@"正在夺宝",@"等待开奖",nil];
    }
    
    return _menuArr;
    
}
-(NSMutableArray*)myChildViewControllers{
    
    if (!_myChildViewControllers) {
        _myChildViewControllers = [NSMutableArray array];
    }
    
    return _myChildViewControllers;
    
}
-(NSMutableArray*)controllerClassNames{
    
    if (!_controllerClassNames) {
        _controllerClassNames = [NSMutableArray arrayWithObjects:@"LBHomeOneDolphinAllViewController",@"LBHomeOneDolphinIngViewController",@"LBHomeOneDolphinWaitViewController", nil];
    }
    
    return _controllerClassNames;
    
}


- (LBHomeViewActivityHeaderView *)headerView {
    
    if (!_headerView) {
        _headerView = [[NSBundle mainBundle]loadNibNamed:@"LBHomeViewActivityHeaderView" owner:self options:nil].firstObject;
        _headerView.frame = CGRectMake(0, SafeAreaTopHeight, UIScreenWidth, kHeaderViewH);
        _headerView.autoresizingMask = 0;
        
        WeakSelf;
        _headerView.jumpactivitydetail = ^(LBHomeViewActivityHistoryModel *model) {
            weakSelf.hidesBottomBarWhenPushed = YES;
            LBHomeOneDolphinDetailController *vc = [[LBHomeOneDolphinDetailController alloc]init];
            vc.indiana_id = model.indiana_id;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        };
    }
    return _headerView;
}

-(NSMutableArray*)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

-(CountDown*)countDown{
    if (!_countDown) {
        _countDown = [[CountDown alloc]init];
    }
    return _countDown;
}
@end
