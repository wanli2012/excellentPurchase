//
//  GLMine_Team_MembersController.m
//  excellentPurchase
//
//  Created by 龚磊 on 2018/1/19.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "GLMine_Team_MembersController.h"
#import "SPPageMenu.h"
#import "GLMine_Team_MemberListController.h"//团队成员列表
#import "GLIdentifySelectController.h"//身份选择

#define pageMenuH 50   //菜单高度
@interface GLMine_Team_MembersController ()<SPPageMenuDelegate,UIScrollViewDelegate>

@property (nonatomic, strong) NSArray *menuArr;
@property (nonatomic, weak) SPPageMenu *pageMenu;
@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableArray *myChildViewControllers;
@property (nonatomic, strong) NSMutableArray *controllerClassNames;

@property (nonatomic, strong)UIButton *rightBtn;
@property (nonatomic, copy)NSString *group_id;
@property (nonatomic, assign)NSInteger selectIndex;//选中身份下标

@end

@implementation GLMine_Team_MembersController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"团队成员";
//    [self setNav];
    [self addMenu];//加载菜单
}
//- (void)setNav{
//
//    UIButton *button=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 80, 44)];
//    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;//右对齐
//
//    [button setTitle:@"筛选" forState:UIControlStateNormal];
//    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [button.titleLabel setFont:[UIFont systemFontOfSize:13]];
//    button.backgroundColor = [UIColor clearColor];
//    [button addTarget:self action:@selector(filter) forControlEvents:UIControlEventTouchUpInside];
//    self.rightBtn = button;
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.rightBtn];
//}

/**
 筛选
 */
//- (void)filter{
//
//    self.hidesBottomBarWhenPushed = YES;
//    GLIdentifySelectController *idSelectVC = [[GLIdentifySelectController alloc] init];
//    idSelectVC.selectIndex = [self.group_id integerValue];
//    __weak typeof(self) weakSelf = self;
//    idSelectVC.block = ^(NSString *name,NSString *group_id,NSInteger selectIndex) {
//
//        [weakSelf.rightBtn setTitle:name forState:UIControlStateNormal];
//        weakSelf.group_id = group_id;
//        weakSelf.selectIndex = selectIndex;
//        
//    };
//
//    [self.navigationController pushViewController:idSelectVC animated:YES];
//}

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
            GLMine_Team_MemberListController *baseVc = [[NSClassFromString(self.controllerClassNames[i]) alloc] init];
            
            if (i == 0) {//@"审核中",@"审核成功",@"审核失败"
                baseVc.type = [NSString stringWithFormat:@"2"];//1 通过 2审核中 3失败
            }else if(i == 1){
                baseVc.type = [NSString stringWithFormat:@"1"];//1 通过 2审核中 3失败
            }else if(i == 2){
                baseVc.type = [NSString stringWithFormat:@"3"];//1 通过 2审核中 3失败
            }
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
        GLMine_Team_MemberListController *baseVc = self.myChildViewControllers[self.pageMenu.selectedItemIndex];
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
        _menuArr = [NSArray arrayWithObjects:@"审核中",@"审核成功",@"审核失败",nil];
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
        _controllerClassNames = [NSMutableArray arrayWithObjects:@"GLMine_Team_MemberListController",@"GLMine_Team_MemberListController",@"GLMine_Team_MemberListController", nil];
    }
    
    return _controllerClassNames;
    
}
@end
