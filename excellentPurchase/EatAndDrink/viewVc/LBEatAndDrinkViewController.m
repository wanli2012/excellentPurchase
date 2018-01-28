//
//  LBEatAndDrinkViewController.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/1/9.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "LBEatAndDrinkViewController.h"
#import "SPPageMenu.h"
#import "LBEat_CateViewController.h"
#import "LBEat_ActivityViewController.h"
#import "LBEat_WholeClassifyView.h"
#import "LBEat_StoreClassifyViewController.h"
#import "LBSaveLocationInfoModel.h"
#define pageMenuH 50   //菜单高度

@interface LBEatAndDrinkViewController ()<SPPageMenuDelegate,UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *navigationH;
@property (nonatomic, weak) SPPageMenu *pageMenu;
@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableArray *myChildViewControllers;
@property (nonatomic, strong) NSMutableArray *controllerClassNames;
@property (nonatomic, strong) NSArray *menuArr;
@property (weak, nonatomic) IBOutlet UILabel *cityLb;

@end

@implementation LBEatAndDrinkViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    self.cityLb.text =  [LBSaveLocationInfoModel defaultUser].currentCity;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self addMenu];//加载菜单
    [self loadData];//加载数据
    
}

-(void)loadData{
    
}

-(void)addMenu{
    
    // trackerStyle:跟踪器的样式
    SPPageMenu *pageMenu = [SPPageMenu pageMenuWithFrame:CGRectMake(0, SafeAreaTopHeight, UIScreenWidth, pageMenuH) trackerStyle:SPPageMenuTrackerStyleLineAttachment];
    // 传递数组，默认选中第1个
    [pageMenu setItems:self.menuArr selectedItemIndex:0];
    pageMenu.showFuntionButton = YES;
//    文字为空 图片占满整个item
    [pageMenu setFunctionButtonTitle:@"" image:[UIImage imageNamed:@"eat-menudown"] imagePosition:SPItemImagePositionTop imageRatio:0.5 forState:UIControlStateNormal];
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
#pragma mark - functionbutton点击的代理方法
- (void)pageMenu:(SPPageMenu *)pageMenu functionButtonClicked:(UIButton *)functionButton {
    
    __weak typeof(self) weaks = self;
    [LBEat_WholeClassifyView showWholeClassifyViewBlock:^(NSInteger section) {
        weaks.hidesBottomBarWhenPushed = YES;
        LBEat_StoreClassifyViewController *vc = [[LBEat_StoreClassifyViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
        weaks.hidesBottomBarWhenPushed = NO;
    }];
    
}

-(NSArray*)menuArr{
    
    if (!_menuArr) {
        _menuArr = [NSArray arrayWithObjects:@"美食",@"住宿",@"玩乐",@"活动",@"全部",nil];
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
        _controllerClassNames = [NSMutableArray arrayWithObjects:@"LBEat_CateViewController",@"UIViewController",@"UIViewController",@"LBEat_ActivityViewController",@"UIViewController", nil];
    }
    
    return _controllerClassNames;
    
}

-(void)updateViewConstraints{
    [super updateViewConstraints];
    self.navigationH.constant = SafeAreaTopHeight;
}


@end
