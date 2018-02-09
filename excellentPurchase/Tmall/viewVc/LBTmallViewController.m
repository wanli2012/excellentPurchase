//
//  LBTmallViewController.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/1/9.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "LBTmallViewController.h"
#import "SPPageMenu.h"
#import "LBTmallChildredViewController.h"
#import "LBTmallProductListViewController.h"
#import "LBTmallFirstCalssifymodel.h"
#import "LBTmallHotsearchViewController.h"
#import "NodataView.h"
#import "GLMine_MessageController.h"

#define pageMenuH 50   //菜单高度

@interface LBTmallViewController ()<SPPageMenuDelegate,UIScrollViewDelegate>

@property (nonatomic, strong) NSMutableArray *menuArr;
@property (nonatomic, weak) SPPageMenu *pageMenu;
@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableArray *myChildViewControllers;
@property (nonatomic, strong) NSMutableArray *controllerClassNames;
@property (nonatomic, strong) NSArray *dataArr;
@property (nonatomic, strong) NodataView *nodataView;//无数据的时候

@end

@implementation LBTmallViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;

}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.titleView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"taotao-biaoti"]];
//    自定义左右按钮
    UIBarButtonItem *letfItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"taotao-saerch"] style:UIBarButtonItemStylePlain target:self action:@selector(searchProducts)];
    self.navigationItem.leftBarButtonItem = letfItem;
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"taotao-xiaoxi"] style:UIBarButtonItemStylePlain target:self action:@selector(messageEvent)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    [self.view addSubview:self.nodataView];
    [self loadData];//加载数据
    WeakSelf;
    _nodataView.cancekBlock = ^{
        [weakSelf loadData];//加载数据
    };
}

-(void)loadData{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"app_handler"] = @"SEARCH";
    [NetworkManager requestPOSTWithURLStr:SeaShoppingNav_cate paramDic:dic finish:^(id responseObject) {
        
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE) {
            self.dataArr  = responseObject[@"data"];
            for (int i = 0; i < self.dataArr.count; i++) {
                [self.controllerClassNames addObject:@"LBTmallChildredViewController"];
                [self.menuArr addObject:self.dataArr[i][@"typename"]];
            }
            if ( self.dataArr.count > 0) {
                [LBTmallFirstCalssifymodel defaultUser].type_id = self.dataArr[0][@"type_id"];
                [LBTmallFirstCalssifymodel defaultUser].typeName = self.dataArr[0][@"typename"];
                [self.nodataView removeFromSuperview];
            }
    
            [self addMenu];//加载菜单
        }else{
            
            [EasyShowTextView showErrorText:responseObject[@"message"]];
        }
        
    } enError:^(NSError *error) {
        
    }];
    
}

-(void)addMenu{
    
    // trackerStyle:跟踪器的样式
    SPPageMenu *pageMenu = [SPPageMenu pageMenuWithFrame:CGRectMake(0, SafeAreaTopHeight, UIScreenWidth, pageMenuH) trackerStyle:SPPageMenuTrackerStyleLine];
    // 传递数组，默认选中第1个
    [pageMenu setItems:self.menuArr selectedItemIndex:0];
    pageMenu.needTextColorGradients = NO;
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
            LBTmallChildredViewController *baseVc = [[NSClassFromString(self.controllerClassNames[i]) alloc] init];
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
        LBTmallChildredViewController *baseVc = self.myChildViewControllers[self.pageMenu.selectedItemIndex];
        [scrollView addSubview:baseVc.view];
        baseVc.view.frame = CGRectMake(UIScreenWidth*self.pageMenu.selectedItemIndex, 0, UIScreenWidth, UIScreenHeight - SafeAreaTopHeight - pageMenuH);
        scrollView.contentOffset = CGPointMake(UIScreenWidth*self.pageMenu.selectedItemIndex, 0);
        scrollView.contentSize = CGSizeMake(self.menuArr.count*UIScreenWidth, 0);
    }
    
}

#pragma mark -----搜索
-(void)searchProducts{
    self.hidesBottomBarWhenPushed = YES;
    LBTmallHotsearchViewController *vc =[[LBTmallHotsearchViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
     self.hidesBottomBarWhenPushed = NO;
}
#pragma mark -----xiao xi
-(void)messageEvent{
    self.hidesBottomBarWhenPushed = YES;
    GLMine_MessageController *vc = [[GLMine_MessageController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}

#pragma mark - SPPageMenu的代理方法

- (void)pageMenu:(SPPageMenu *)pageMenu itemSelectedAtIndex:(NSInteger)index {
 
}

- (void)pageMenu:(SPPageMenu *)pageMenu itemSelectedFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex {
    
    [LBTmallFirstCalssifymodel defaultUser].type_id = self.dataArr[toIndex][@"type_id"];
    [LBTmallFirstCalssifymodel defaultUser].typeName = self.dataArr[toIndex][@"typename"];
    
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


-(NSMutableArray*)menuArr{
    
    if (!_menuArr) {
        _menuArr = [NSMutableArray array];
    }
    
    return _menuArr;
    
}
-(NSArray*)dataArr{
    
    if (!_dataArr) {
        _dataArr = [NSArray array];
    }
    
    return _dataArr;
    
}
-(NSMutableArray*)myChildViewControllers{
    
    if (!_myChildViewControllers) {
        _myChildViewControllers = [NSMutableArray array];
    }
    
    return _myChildViewControllers;
    
}
-(NSMutableArray*)controllerClassNames{
    
    if (!_controllerClassNames) {
        _controllerClassNames = [NSMutableArray array];
    }
    
    return _controllerClassNames;
    
}
-(NodataView*)nodataView{
    if (!_nodataView) {
        _nodataView = [[NSBundle mainBundle]loadNibNamed:@"NodataView" owner:nil options:nil].firstObject;
        _nodataView.autoresizingMask = 0;
        _nodataView.frame = CGRectMake(0, SafeAreaTopHeight, UIScreenWidth, UIScreenHeight - SafeAreaTopHeight - 49);
        
    }
    return _nodataView;
}
@end
