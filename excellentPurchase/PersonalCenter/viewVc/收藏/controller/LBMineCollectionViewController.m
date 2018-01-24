//
//  LBMineCollectionViewController.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/1/23.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "LBMineCollectionViewController.h"
#import "UIButton+SetEdgeInsets.h"
#import "SPPageMenu.h"
#import "LBMineCollectionProductViewController.h"
#import "LBMineCollectionShopViewController.h"
#import "PGGDropView.h"
#import "LBCollectionManager.h"

#define pageMenuH 50   //菜单高度

@interface LBMineCollectionViewController ()<SPPageMenuDelegate,UIScrollViewDelegate,PGGDropDelegate>

@property (nonatomic, weak) SPPageMenu *pageMenu;
@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableArray *myChildViewControllers;
@property (nonatomic, strong) NSMutableArray *controllerClassNames;
@property (nonatomic, strong) NSArray *menuArr;
@property(strong,nonatomic)PGGDropView * dropView;
@property (nonatomic, strong) UIButton *navigationBt;
@end

@implementation LBMineCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self defineNavigationView];
    self.navigationController.navigationBar.hidden = NO;
    [self addMenu];//加载菜单
}

/**
 管理

 @param sender <#sender description#>
 */
-(void)managerEvent:(UIButton*)sender{
    sender.selected = !sender.selected;
    if (sender.selected) {
        [LBCollectionManager defaultUser].index = 1;
        [[NSNotificationCenter defaultCenter]postNotificationName:@"showEditview" object:nil];
    }else{
        [LBCollectionManager defaultUser].index = 0;
         [[NSNotificationCenter defaultCenter]postNotificationName:@"dismissEditview" object:nil];
    }
    
}

/**
 筛选 商城

 @param sender <#sender description#>
 */
-(void)navigationBtEvent:(UIButton*)sender{
    sender.selected = !sender.selected;
    [self.dropView removeFromSuperview];
    self.dropView = nil;
        self.dropView = [[PGGDropView alloc] initWithFrame:CGRectMake(0, SafeAreaTopHeight ,UIScreenWidth, 300) withTitleArray:@[@"淘淘商城"]];
        self.dropView.delegate = self;
         [self.dropView beginAnimation];
        [self.view addSubview:self.dropView];
    
}
- (void)PGGDropView:(PGGDropView *)DropView didSelectAtIndex:(NSInteger )index{
    self.navigationBt.selected = NO;

}
-(void)dismissMaskview{
    self.navigationBt.selected = NO;
    
}

-(void)defineNavigationView{
    
    _navigationBt = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 150, 30)];
    [_navigationBt setTitle:@"诶吃么商城" forState:UIControlStateNormal];
    [_navigationBt setImage:[UIImage imageNamed:@"shoucang-n"] forState:UIControlStateNormal];
    [_navigationBt setImage:[UIImage imageNamed:@"shoucang-y"] forState:UIControlStateSelected];
    [_navigationBt setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _navigationBt.titleLabel.font = [UIFont systemFontOfSize:17];
     [_navigationBt horizontalCenterTitleAndImage:5];
    [_navigationBt addTarget:self action:@selector(navigationBtEvent:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.titleView = _navigationBt;
    
    UIButton *button=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    [button setTitle:@"管理" forState:UIControlStateNormal];
    [button setTitle:@"完成" forState:UIControlStateSelected];
    [button setTitleColor:LBHexadecimalColor(0x333333) forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    [button addTarget:self action:@selector(managerEvent:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *ba=[[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = ba;
    
}

-(void)addMenu{
    
    // trackerStyle:跟踪器的样式
    SPPageMenu *pageMenu = [SPPageMenu pageMenuWithFrame:CGRectMake(0, SafeAreaTopHeight, UIScreenWidth, pageMenuH) trackerStyle:SPPageMenuTrackerStyleLineLongerThanItem];
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
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, SafeAreaTopHeight+pageMenuH, UIScreenWidth, UIScreenHeight - SafeAreaTopHeight - pageMenuH)];
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
        baseVc.view.frame = CGRectMake(UIScreenWidth*self.pageMenu.selectedItemIndex, 0, UIScreenWidth, UIScreenHeight - SafeAreaTopHeight - pageMenuH);
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
    
    targetViewController.view.frame = CGRectMake(UIScreenWidth * toIndex, 0, UIScreenWidth, UIScreenHeight - SafeAreaTopHeight - pageMenuH);
    [_scrollView addSubview:targetViewController.view];
    
}

-(NSArray*)menuArr{
    
    if (!_menuArr) {
        _menuArr = [NSArray arrayWithObjects:@"商品",@"店铺",nil];
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
        _controllerClassNames = [NSMutableArray arrayWithObjects:@"LBMineCollectionProductViewController",@"LBMineCollectionShopViewController", nil];
    }
    
    return _controllerClassNames;
    
}


@end
