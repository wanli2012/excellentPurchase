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
#import "LBEat_cateModel.h"
#import "LBHistoryHotSerachViewController.h"
#import "NodataView.h"
#import "GYZChooseCityController.h"
#import <CoreLocation/CoreLocation.h>

#define pageMenuH 50   //菜单高度

@interface LBEatAndDrinkViewController ()<SPPageMenuDelegate,UIScrollViewDelegate,GYZChooseCityDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *navigationH;
@property (nonatomic, weak) SPPageMenu *pageMenu;
@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableArray *myChildViewControllers;
@property (nonatomic, strong) NSMutableArray *controllerClassNames;
@property (nonatomic, strong) NSMutableArray *menuArr;
@property (nonatomic, strong) NSArray *dataArr;
@property (weak, nonatomic) IBOutlet UILabel *cityLb;
@property (nonatomic, strong) NodataView *nodataView;//无数据的时候
/** 地理编码 */
@property (nonatomic, strong) CLGeocoder *geoC;
@property (weak, nonatomic) IBOutlet UIView *navigationView;

@end

@implementation LBEatAndDrinkViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    if ([NSString StringIsNullOrEmpty:[LBSaveLocationInfoModel defaultUser].currentCity] == NO && ![[LBSaveLocationInfoModel defaultUser].currentCity isEqualToString:self.cityLb.text]) {
         self.cityLb.text =  [LBSaveLocationInfoModel defaultUser].currentCity;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.nodataView];
    //同步城市选择
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshCityData) name:@"LBEatAndDrinkViewController" object:nil];
    [self loadData];//加载数据
    WeakSelf;
    _nodataView.cancekBlock = ^{
        [weakSelf loadData];//加载数据
    };
}

-(void)loadData{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"app_handler"] = @"SEARCH";
    [NetworkManager requestPOSTWithURLStr:HappyPlayBanner paramDic:dic finish:^(id responseObject) {
   
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE) {
            self.dataArr  = responseObject[@"data"];
            [self.controllerClassNames removeAllObjects];
            [self.menuArr removeAllObjects];
            [self.myChildViewControllers removeAllObjects];
            for (int i = 0; i < self.dataArr.count; i++) {
                [self.controllerClassNames addObject:@"LBEat_CateViewController"];
                [self.menuArr addObject:self.dataArr[i][@"catename"]];
            }
            if (self.dataArr.count > 0) {
                [LBEat_cateModel defaultUser].cate_id = self.dataArr[0][@"cate_id"];
                [LBEat_cateModel defaultUser].cate_banners = self.dataArr[0][@"cate_banners"];
                [self.nodataView removeFromSuperview];
            }
             [self addMenu];//加载菜单
        }else{

            [EasyShowTextView showErrorText:responseObject[@"message"]];
        }
        
    } enError:^(NSError *error) {
       [EasyShowTextView showErrorText:error.localizedDescription];
    }];
    
}
//选择城市
- (IBAction)tapgestureChooseCity:(UITapGestureRecognizer *)sender {
    GYZChooseCityController *cityPickerVC = [[GYZChooseCityController alloc] init];
    [cityPickerVC setDelegate:self];
    
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:[[UINavigationController alloc] initWithRootViewController:cityPickerVC] animated:YES completion:^{
        
    }];
}
//搜索
- (IBAction)tapgestureSearch:(UITapGestureRecognizer *)sender {
    self.hidesBottomBarWhenPushed = YES;
    LBHistoryHotSerachViewController *vc = [[LBHistoryHotSerachViewController alloc]init];
    vc.type = 2;
    [self.navigationController pushViewController:vc animated:true];
    self.hidesBottomBarWhenPushed = NO;
}

-(void)addMenu{
    [self.view.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (![obj isMemberOfClass:[self.navigationView class]]) {
            [obj removeFromSuperview];
        }
    }];
 
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
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, SafeAreaTopHeight+pageMenuH, UIScreenWidth, UIScreenHeight - SafeAreaTopHeight - pageMenuH - 49)];
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
        baseVc.view.frame = CGRectMake(UIScreenWidth*self.pageMenu.selectedItemIndex, 0, UIScreenWidth, UIScreenHeight - SafeAreaTopHeight - pageMenuH- 49);
        scrollView.contentOffset = CGPointMake(UIScreenWidth*self.pageMenu.selectedItemIndex, 0);
        scrollView.contentSize = CGSizeMake(self.menuArr.count*UIScreenWidth, 0);
    }
    
}

#pragma mark - SPPageMenu的代理方法

- (void)pageMenu:(SPPageMenu *)pageMenu itemSelectedAtIndex:(NSInteger)index {
 
}

- (void)pageMenu:(SPPageMenu *)pageMenu itemSelectedFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex {
 
    [LBEat_cateModel defaultUser].cate_id = self.dataArr[toIndex][@"cate_id"];
    [LBEat_cateModel defaultUser].cate_banners = self.dataArr[toIndex][@"cate_banners"];
    
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
    [LBEat_WholeClassifyView showWholeClassifyViewBlock:^(NSString *cate_id,NSString *catename) {
        weaks.hidesBottomBarWhenPushed = YES;
        LBEat_StoreClassifyViewController *vc = [[LBEat_StoreClassifyViewController alloc]init];
        vc.cate_id = cate_id;
        vc.cate_name = catename;
        [self.navigationController pushViewController:vc animated:YES];
        weaks.hidesBottomBarWhenPushed = NO;
    }];
    
}

//选择城市
- (void) cityPickerController:(GYZChooseCityController *)chooseCityController
                didSelectCity:(GYZCity *)city{
    
    [self.geoC geocodeAddressString:city.cityName completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        
        // CLPlacemark : 地标
        // location : 位置对象
        // addressDictionary : 地址字典
        // name : 地址详情
        // locality : 城市
        
        if(error == nil)
        {
            CLPlacemark *pl = [placemarks firstObject];
            [LBSaveLocationInfoModel defaultUser].currentCity = pl.locality;
            [LBSaveLocationInfoModel defaultUser].strLatitude = @(pl.location.coordinate.latitude).stringValue;
            [LBSaveLocationInfoModel defaultUser].strLongitude = @(pl.location.coordinate.longitude).stringValue;
            self.cityLb.text = city.cityName;
            [self loadData];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"LBHomeViewController" object:nil];
        }else
        {
            NSLog(@"错误");
        }
    }];
    
    [[UIApplication sharedApplication].keyWindow.rootViewController dismissViewControllerAnimated:YES completion:^{
        
    }];
}

-(void)refreshCityData{
    self.cityLb.text = [LBSaveLocationInfoModel defaultUser].currentCity;
    [self loadData];
}
//取消
- (void) cityPickerControllerDidCancel:(GYZChooseCityController *)chooseCityController{
    
    [[UIApplication sharedApplication].keyWindow.rootViewController dismissViewControllerAnimated:YES completion:^{
        
    }];
    
}

-(NSArray*)dataArr{
    
    if (!_dataArr) {
        _dataArr = [NSArray array];
    }
    
    return _dataArr;
    
}
-(NSMutableArray*)menuArr{
    
    if (!_menuArr) {
        _menuArr = [NSMutableArray array];
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
        _controllerClassNames = [NSMutableArray array];
    }
    
    return _controllerClassNames;
    
}

-(void)updateViewConstraints{
    [super updateViewConstraints];
    self.navigationH.constant = SafeAreaTopHeight;
}

-(NodataView*)nodataView{
    if (!_nodataView) {
        _nodataView = [[NSBundle mainBundle]loadNibNamed:@"NodataView" owner:nil options:nil].firstObject;
        _nodataView.autoresizingMask = 0;
        _nodataView.frame = CGRectMake(0, SafeAreaTopHeight, UIScreenWidth, UIScreenHeight - SafeAreaTopHeight - 49);
        
    }
    return _nodataView;
}
#pragma mark -懒加载
-(CLGeocoder *)geoC
{
    if (!_geoC) {
        _geoC = [[CLGeocoder alloc] init];
    }
    return _geoC;
}
@end
