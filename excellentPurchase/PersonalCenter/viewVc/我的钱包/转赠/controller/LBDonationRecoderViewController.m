//
//  LBDonationRecoderViewController.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/1/11.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "LBDonationRecoderViewController.h"
#import "SPPageMenu.h"
#import "GLDonationRecordListController.h"

#define pageMenuH 50   //菜单高度

@interface LBDonationRecoderViewController ()<SPPageMenuDelegate,UIScrollViewDelegate>

@property (nonatomic, strong) NSArray *menuArr;
@property (nonatomic, weak) SPPageMenu *pageMenu;
@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableArray *myChildViewControllers;
@property (nonatomic, strong) NSMutableArray *controllerClassNames;

@property (nonatomic, strong)UIButton *rightBtn;
@property (nonatomic, copy)NSString *group_id;
@property (nonatomic, assign)NSInteger selectIndex;//选中身份下标
@property (strong, nonatomic)NSMutableArray *models;
@property (assign, nonatomic)NSInteger page;//页数默认为1

@end

@implementation LBDonationRecoderViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"转赠记录";
    [self addMenu];//加载菜单
}

//加载菜单
-(void)addMenu{
    
    // trackerStyle:跟踪器的样式
    SPPageMenu *pageMenu = [SPPageMenu pageMenuWithFrame:CGRectMake(0, SafeAreaTopHeight, UIScreenWidth, pageMenuH) trackerStyle:SPPageMenuTrackerStyleLineLongerThanItem];
    
    pageMenu.permutationWay = SPPageMenuPermutationWayNotScrollEqualWidths;
    
    // 传递数组，默认选中第1个
    [pageMenu setItems:self.menuArr selectedItemIndex:0];
    pageMenu.needTextColorGradients = NO;
    // 设置代理
    pageMenu.delegate = self;
    pageMenu.itemTitleFont = [UIFont systemFontOfSize:15];
    pageMenu.selectedItemTitleColor = [UIColor blackColor];
    pageMenu.unSelectedItemTitleColor = YYSRGBColor(118, 118, 118, 1);
    pageMenu.dividingLine.backgroundColor = [UIColor groupTableViewBackgroundColor];
    pageMenu.tracker.backgroundColor = [UIColor blackColor];
    [self.view addSubview:pageMenu];
    _pageMenu = pageMenu;
    
    for (int i = 0; i < self.menuArr.count; i++) {
        if (self.controllerClassNames.count > i) {
            GLDonationRecordListController *baseVc = [[NSClassFromString(self.controllerClassNames[i]) alloc] init];

            baseVc.type = i + 1;
            [self addChildViewController:baseVc];
            
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
        GLDonationRecordListController *baseVc = self.myChildViewControllers[self.pageMenu.selectedItemIndex];
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
        _menuArr = [NSArray arrayWithObjects:@"获赠记录",@"转赠记录",nil];
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
        _controllerClassNames = [NSMutableArray arrayWithObjects:@"GLDonationRecordListController",@"GLDonationRecordListController" ,nil];
    }
    
    return _controllerClassNames;
    
}

@end
