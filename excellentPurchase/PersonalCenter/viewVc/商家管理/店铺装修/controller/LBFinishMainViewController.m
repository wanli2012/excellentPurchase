//
//  LBFinishMainViewController.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/1/24.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "LBFinishMainViewController.h"
#import "UIButton+SetEdgeInsets.h"
#import "SPPageMenu.h"
#import "LBStoreInformationViewController.h"
#import "LBFinishAmendPhotosViewController.h"
#import "LBEat_StoreCommentsViewController.h"
#import "LBStoreCounterMainViewController.h"

#define pageMenuH 50   //菜单高度

@interface LBFinishMainViewController ()<SPPageMenuDelegate,UIScrollViewDelegate>

@property (nonatomic, weak) SPPageMenu *pageMenu;
@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableArray *myChildViewControllers;
@property (nonatomic, strong) NSMutableArray *controllerClassNames;
@property (nonatomic, strong) NSArray *menuArr;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewTop;
@property (weak, nonatomic) IBOutlet UIButton *signBt;//换牌照
@property (weak, nonatomic) IBOutlet UIButton *databt;//修改资料
@property (weak, nonatomic) IBOutlet UIButton *counterBt;//我的货柜
@property (weak, nonatomic) IBOutlet UIButton *replyBt;//回复评论


@end

@implementation LBFinishMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = NO;
    self.navigationItem.title = @"我的小店";
    
    [self addMenu];//加载菜单
    
}

-(void)addMenu{
    
    // trackerStyle:跟踪器的样式
    SPPageMenu *pageMenu = [SPPageMenu pageMenuWithFrame:CGRectMake(0, SafeAreaTopHeight + 82, UIScreenWidth, pageMenuH) trackerStyle:SPPageMenuTrackerStyleLineAttachment];
    // 传递数组，默认选中第1个
    [pageMenu setItems:self.menuArr selectedItemIndex:0];
    pageMenu.permutationWay = SPPageMenuPermutationWayNotScrollEqualWidths;
    pageMenu.tracker.backgroundColor = [UIColor clearColor];
    pageMenu.dividingLine.backgroundColor = [UIColor groupTableViewBackgroundColor];
    // 设置代理
    pageMenu.delegate = self;
    pageMenu.itemTitleFont = [UIFont systemFontOfSize:15];
    pageMenu.selectedItemTitleColor = YYSRGBColor(251, 73, 80, 1);
    pageMenu.unSelectedItemTitleColor = YYSRGBColor(118, 118, 118, 1);
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
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, SafeAreaTopHeight+pageMenuH + 81, UIScreenWidth, UIScreenHeight - SafeAreaTopHeight - pageMenuH -136)];
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
        baseVc.view.frame = CGRectMake(UIScreenWidth*self.pageMenu.selectedItemIndex, 0, UIScreenWidth, UIScreenHeight - SafeAreaTopHeight - pageMenuH - 136);
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

/**
 换招牌照

 @param sender <#sender description#>
 */
- (IBAction)amendSignEvent:(UIButton *)sender {
    self.hidesBottomBarWhenPushed = YES;
    LBFinishAmendPhotosViewController *vc = [[LBFinishAmendPhotosViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

/**
 修改资料

 @param sender <#sender description#>
 */
- (IBAction)amendinfoEvent:(UIButton *)sender {
    self.hidesBottomBarWhenPushed = YES;
    LBStoreInformationViewController *vc = [[LBStoreInformationViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

/**
 修改货柜

 @param sender <#sender description#>
 */
- (IBAction)amendGoodsEvent:(UIButton *)sender {
    self.hidesBottomBarWhenPushed = YES;
    LBStoreCounterMainViewController *vc = [[LBStoreCounterMainViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

/**
 回复评论

 @param sender <#sender description#>
 */
- (IBAction)replyEvent:(UIButton *)sender {
    self.hidesBottomBarWhenPushed = YES;
    LBEat_StoreCommentsViewController *vc = [[LBEat_StoreCommentsViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}


-(NSArray*)menuArr{
    
    if (!_menuArr) {
        _menuArr = [NSArray arrayWithObjects:@"淘淘商品",@"吃喝玩乐",@"活动商品",nil];
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
        _controllerClassNames = [NSMutableArray arrayWithObjects:@"LBFinishProductsViewController",@"LBFinishProductsViewController",@"LBFinishProductsViewController", nil];
    }
    
    return _controllerClassNames;
    
}


-(void)updateViewConstraints{
    [super updateViewConstraints];
    
     [self.signBt verticalCenterImageAndTitle:5];
     [self.databt verticalCenterImageAndTitle:5];
     [self.counterBt verticalCenterImageAndTitle:5];
     [self.replyBt verticalCenterImageAndTitle:5];
    
    self.viewTop.constant = SafeAreaTopHeight + 1;
}

@end
