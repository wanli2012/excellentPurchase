//
//  LBHomeViewController.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/1/9.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "LBHomeViewController.h"
#import "GLNearby_ClassifyHeaderView.h"
#import "LBHorseGroupTableViewCell.h"
#import "UIImage+GIF.h"
#import <CoreLocation/CoreLocation.h>
#import "LBTmallHotsearchViewController.h"
#import "LBSaveLocationInfoModel.h"
#import "GYZChooseCityController.h"
#import "GLHomeModel.h"
#import "LBXScanView.h"
#import "LBXScanResult.h"
#import "LBXScanWrapper.h"
#import "SubLBXScanViewController.h"
#import "LBFaceToFace_PayController.h"
#import "LLWebViewController.h"
#import "LBHomeViewActivityViewController.h"
#import "LBVoucherCenterViewController.h"//充值
#import "LBTmallProductListViewController.h"
#import "LBEat_StoreClassifyViewController.h"
#import "GLMine_MessageController.h"
#import "LBTimeLimitBuyingViewController.h"
#import "LBHomeActivityTableViewCell.h"
#import "LBTodayTimeLimitModel.h"
#import "LBSnapUpDetailViewController.h"

@interface LBHomeViewController ()<UITableViewDelegate,UITableViewDataSource,CLLocationManagerDelegate,GYZChooseCityDelegate,LBHorseGroupTableViewCellDelegate,ClassifyHeaderViewdelegete>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *navigationH;//导航栏高度
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) IBOutlet UIView *navigationView;//自定义导航栏
@property (weak, nonatomic) IBOutlet UIView *searchView;//自定义搜索view
@property (strong, nonatomic)GLNearby_ClassifyHeaderView *classfyHeaderV;//自定义头部视图
@property (strong, nonatomic)NSArray *tradeArr;//分类数据数组
@property (weak, nonatomic) IBOutlet UIImageView *activityImage;//底部活动图片

@property (nonatomic,strong ) CLLocationManager *locationManager;//定位服务
/** 地理编码 */
@property (nonatomic, strong) CLGeocoder *geoC;

@property (weak, nonatomic) IBOutlet UILabel *cityLb;//城市展示
//天气图片
@property (weak, nonatomic) IBOutlet UIImageView *weatherImage;
//温度
@property (weak, nonatomic) IBOutlet UILabel *temperatureLb;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomHeight;


//@property (strong, nonatomic)SDCycleScrollView *cycleScrollView;//banner
//@property (nonatomic, copy)NSArray *imagearr;

@property (nonatomic, strong)NSMutableArray *models;
@property (nonatomic, assign)NSInteger page;
@property (nonatomic, strong)NodataView *nodataV;
@property (nonatomic, strong)GLHomeModel *model;
@property (nonatomic, strong)LBTodayTimeLimitModel *modelActivity;

@end

static NSString *horseGroupTableViewCell = @"LBHorseGroupTableViewCell";
static NSString *homeActivityTableViewCell = @"LBHomeActivityTableViewCell";

@implementation LBHomeViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [EasyShowLodingView hidenLoding];
    
    self.navigationController.navigationBar.hidden = YES;

}

-(void)updateViewConstraints{
    [super updateViewConstraints];
    self.navigationH.constant = SafeAreaTopHeight;
    self.searchView.layer.cornerRadius = 15;
    self.bottomHeight.constant = SafeAreaBottomReallyHeight;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self locatemap];//定位
    //同步城市选择
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshCityData) name:@"LBHomeViewController" object:nil];
     [self.tableview registerNib:[UINib nibWithNibName:homeActivityTableViewCell bundle:nil] forCellReuseIdentifier:homeActivityTableViewCell];
    
    adjustsScrollViewInsets_NO(self.tableview, self);
    self.tableview.tableHeaderView = self.classfyHeaderV;
    WeakSelf;
    self.tradeArr = @[@{@"trade_name":@"海淘商城",@"thumb":@"Home-haitaoshangcheng"},
                      @{@"trade_name":@"微商清仓",@"thumb":@"Home-weishangqingcang"},
                      @{@"trade_name":@"厂家直销",@"thumb":@"Home-ziyingshangcheng"},
                      @{@"trade_name":@"自营商城",@"thumb":@"Home-ziying"},
                      @{@"trade_name":@"吃喝玩乐",@"thumb":@"Home-chihewanle"},
                      @{@"trade_name":@"限时抢购",@"thumb":@"Home-miaosha"},
                      @{@"trade_name":@"今日好运来",@"thumb":@"Home-yiyuangou-1"},
                      @{@"trade_name":@"充值中心",@"thumb":@"Home-chongzhi"}];
    
    [self.classfyHeaderV initdatasorece:self.tradeArr];
    self.tableview.tableFooterView.height = 10;
    self.activityImage.hidden = YES;
    [LBDefineRefrsh defineRefresh:self.tableview headerrefresh:^{
        [weakSelf postRequest:YES];
         [weakSelf postRequestActivity];
         [_locationManager startUpdatingLocation];//定位
    }];
    
    self.page = 1;
    [self postRequest:YES];
    [self postRequestActivity];
}

#pragma mark -  请求数据

- (void)postRequest:(BOOL)isRefresh{
    
    if (isRefresh) {
        self.page = 1;
    }else{
        self.page ++;
    }
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    dic[@"app_handler"] = @"SEARCH";
    
    [EasyShowLodingView showLodingText:@"正在加载数据"];
    
    [NetworkManager requestPOSTWithURLStr:kShop_index_URL paramDic:dic finish:^(id responseObject) {
        
        [LBDefineRefrsh dismissRefresh:self.tableview];
        
        [EasyShowLodingView hidenLoding];
        
        if (isRefresh) {
            self.model = nil;
        }
        
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE){
            if([(NSDictionary *)responseObject[@"data"] count] != 0){
                
                self.model = [GLHomeModel mj_objectWithKeyValues:responseObject[@"data"]];
                
                NSMutableArray *arrM = [NSMutableArray array];
                
                for (GLHome_bannerModel *model in self.model.banner) {
                    [arrM addObject:model.banner_pic];
                }

                self.classfyHeaderV.imageArr = arrM;
                [self.classfyHeaderV reloadScorlvoewimages:arrM];
                
            }
        }else{
            [EasyShowTextView showErrorText:responseObject[@"message"]];
        }
        
        [self.tableview reloadData];
        
    } enError:^(NSError *error) {
        
        [LBDefineRefrsh dismissRefresh:self.tableview];
        [EasyShowLodingView hidenLoding];
        [self.tableview reloadData];
        [EasyShowTextView showErrorText:error.localizedDescription];
        
    }];
}

//请求活动数据
-(void)postRequestActivity{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"app_handler"] = @"SEARCH";
    dic[@"type"] = @(1);
    dic[@"uid"] = [UserModel defaultUser].uid;
    
    [NetworkManager requestPOSTWithURLStr:ChallengeChallenge_list paramDic:dic finish:^(id responseObject) {
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE) {
            
            self.modelActivity = [LBTodayTimeLimitModel mj_objectWithKeyValues:responseObject[@"data"]];
            if (self.modelActivity.buying.data.count <= 0) {
                self.tableview.tableFooterView.height = UIScreenWidth * bottomScale + 20 ;
                self.activityImage.hidden = NO;
            }else{
                self.tableview.tableFooterView.height = 10;
                self.activityImage.hidden = YES;
            }
            [self.tableview reloadData];
            
        }else{
            self.tableview.tableFooterView.height = UIScreenWidth * bottomScale + 20 ;
            self.activityImage.hidden = NO;
        }
        
    } enError:^(NSError *error) {
        self.tableview.tableFooterView.height = UIScreenWidth * bottomScale + 20 ;
        self.activityImage.hidden = NO;
        
    }];
}

- (void)locatemap{
    
    if ([CLLocationManager locationServicesEnabled]) {
        _locationManager = [[CLLocationManager alloc]init];
        _locationManager.delegate = self;
        [_locationManager requestAlwaysAuthorization];
        [_locationManager requestWhenInUseAuthorization];
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        _locationManager.distanceFilter = 5.0;
        [_locationManager startUpdatingLocation];
    }
}
#pragma mark - 定位失败
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"请在设置中打开定位重新定位" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"重新定位" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        NSURL *settingURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
//        [[UIApplication sharedApplication]openURL:settingURL];
         [_locationManager startUpdatingLocation];//定位
        [EasyShowLodingView hidenLoding];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [EasyShowLodingView hidenLoding];
    }];
    [alert addAction:cancel];
    [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:nil];
}
#pragma mark - 定位成功
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    
    [_locationManager stopUpdatingLocation];
    CLLocation *currentLocation = [locations lastObject];
    CLGeocoder *geoCoder = [[CLGeocoder alloc]init];
    //当前的经纬度
    [LBSaveLocationInfoModel defaultUser].strLatitude = [NSString stringWithFormat:@"%f",currentLocation.coordinate.latitude];
    [LBSaveLocationInfoModel defaultUser].strLongitude = [NSString stringWithFormat:@"%f",currentLocation.coordinate.longitude];

    //这里的代码是为了判断didUpdateLocations调用了几次 有可能会出现多次调用 为了避免不必要的麻烦 在这里加个if判断 如果大于1.0就return
    NSTimeInterval locationAge = -[currentLocation.timestamp timeIntervalSinceNow];
    if (locationAge > 1.0){//如果调用已经一次，不再执行
        return;
    }
    //地理反编码 可以根据坐标(经纬度)确定位置信息(街道 门牌等)
    [geoCoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (placemarks.count >0) {
            CLPlacemark *placeMark = placemarks[0];
            [LBSaveLocationInfoModel defaultUser].currentCity = placeMark.locality;
            self.cityLb.text = [LBSaveLocationInfoModel defaultUser].currentCity;
            if (![LBSaveLocationInfoModel defaultUser].currentCity) {
                [EasyShowTextView showInfoText:@"无法定位到当前城市"];
            }
            [self getWeatherInfo];
            //看需求定义一个全局变量来接收赋值
        }else if (error == nil && placemarks.count){

        }else if (error){
            
        }
    }];
}

-(void)getWeatherInfo{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"app_handler"] = @"SEARCH";
    dic[@"lng"] = [LBSaveLocationInfoModel defaultUser].strLongitude;
    dic[@"lat"] = [LBSaveLocationInfoModel defaultUser].strLatitude;
   
    [NetworkManager requestPOSTWithURLStr:kAccessget_sky_air paramDic:dic finish:^(id responseObject) {
        
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE) {
            self.temperatureLb.text = [NSString stringWithFormat:@"%@℃",responseObject[@"data"][@"temp"]];
            [self.weatherImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",@"https://app.helloyogo.com",responseObject[@"data"][@"icon"]]] placeholderImage:[UIImage imageNamed:@"weather"]];
            
        }else{
    
        }
    } enError:^(NSError *error) {

    }];
    
}

#pragma mark - LBHorseGroupTableViewCellDelegate
-(void)toDetail:(NSInteger)index infoIndex:(NSInteger)infoIndex{
    if (index == 0) {
        GLHome_newsModel *model = self.model.news[infoIndex];
        self.hidesBottomBarWhenPushed = YES;
        LLWebViewController *vc = [[LLWebViewController alloc]initWithUrl:[NSString stringWithFormat:@"%@%@%@%@",URL_Base,DataNew_data,@"/news_id/",model.news_id]];
        vc.titilestr = @"公告详情";
        [self.navigationController pushViewController:vc animated:YES];
        self.hidesBottomBarWhenPushed = NO;
    }
}

#pragma mark - 点击轮播图回调
- (void)tapgestureImage:(NSInteger)index{
 
}
-(void)tapgesture:(NSInteger)tag{
    switch (tag) {
        case 0:
        {
            self.hidesBottomBarWhenPushed = YES;
            LBTmallProductListViewController *vc = [[LBTmallProductListViewController alloc]init];
            vc.catename = @"海淘商城";
            vc.jumpType = 1;
            vc.s_type = @"";
            [self.navigationController pushViewController:vc animated:YES];
            self.hidesBottomBarWhenPushed = NO;
        }
            break;
        case 1:
        {
            self.hidesBottomBarWhenPushed = YES;
            LBTmallProductListViewController *vc = [[LBTmallProductListViewController alloc]init];
            vc.catename = @"微商清仓";
            vc.jumpType = 1;
            vc.s_type = @"4";
            [self.navigationController pushViewController:vc animated:YES];
            self.hidesBottomBarWhenPushed = NO;
        }
            break;
        case 2:
        {
            self.hidesBottomBarWhenPushed = YES;
            LBTmallProductListViewController *vc = [[LBTmallProductListViewController alloc]init];
            vc.catename = @"厂家直销";
            vc.jumpType = 1;
            vc.s_type = @"1";
            [self.navigationController pushViewController:vc animated:YES];
            self.hidesBottomBarWhenPushed = NO;
        }
            break;
        case 3:
        {
            self.hidesBottomBarWhenPushed = YES;
            LBTmallProductListViewController *vc = [[LBTmallProductListViewController alloc]init];
            vc.catename = @"自营商城";
            vc.jumpType = 1;
            vc.s_type = @"5";
            [self.navigationController pushViewController:vc animated:YES];
            self.hidesBottomBarWhenPushed = NO;
        }
            break;
        case 4:
        {
            self.hidesBottomBarWhenPushed = YES;
            LBEat_StoreClassifyViewController *vc = [[LBEat_StoreClassifyViewController alloc]init];
            vc.cate_name = @"吃喝玩乐";
            [self.navigationController pushViewController:vc animated:YES];
            self.hidesBottomBarWhenPushed = NO;
        }
            break;
        case 5:
        {
            self.hidesBottomBarWhenPushed = YES;
            LBTimeLimitBuyingViewController *vc = [[LBTimeLimitBuyingViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
            self.hidesBottomBarWhenPushed = NO;
        }
            break;
        case 6:
        {
            self.hidesBottomBarWhenPushed = YES;
            LBHomeViewActivityViewController *vc = [[LBHomeViewActivityViewController alloc]init];
            vc.titileStr = @"今日好运来";
            [self.navigationController pushViewController:vc animated:YES];
            self.hidesBottomBarWhenPushed = NO;
        }
            break;
        case 7:
        {
            if ( [UserModel defaultUser].loginstatus == NO) {
                [EasyShowTextView showText:@"请先登录"];
                return;
            }
            self.hidesBottomBarWhenPushed = YES;
            LBVoucherCenterViewController *vc = [[LBVoucherCenterViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
            self.hidesBottomBarWhenPushed = NO;
            break;
        }
        default:
            break;
    }
}
#pragma mark - 跳转消息

- (IBAction)jumpMessage:(UIButton *)sender {
    if ([UserModel defaultUser].loginstatus == NO) {
        [EasyShowTextView showInfoText:@"请先登录"];
        return;
    }
    self.hidesBottomBarWhenPushed = YES;
    GLMine_MessageController *vc = [[GLMine_MessageController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}

#pragma mark - 重写----设置有groupTableView有几个分区
-(NSInteger)numberOfSectionsInTableView:(UITableView*)tableView {
    if (self.modelActivity && self.modelActivity.buying.data.count > 0) {
         return 2;
    }
    return 1; //返回值是多少既有几个分区
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //分别设置每个分组上面显示的单元格个数
    if (section == 0) {
        return 2;
    }else if (section == 1){
        return 1;
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return bannerHeiget;
    }else if (indexPath.section == 1){
        return 130;
    }
    return 0;
}
#pragma mark - 重写----设置每个分组单元格中显示的内容
-(UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section == 0) {
        LBHorseGroupTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:horseGroupTableViewCell];
        // 判断cell是否存在
        if (!cell) {
            cell = [[LBHorseGroupTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:horseGroupTableViewCell];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        if (indexPath.row == 0) {
            cell.newsModels = self.model.news;
            cell.imagev.image = [UIImage imageNamed:@"得瑟狗-头条"];
        }else if(indexPath.row == 1){
            cell.orderModels = self.model.orders;
            cell.imagev.image = [UIImage imageNamed:@"得瑟狗-今日订单"];
        }
        cell.index = indexPath.row;
        cell.delegate = self;
        
        return cell;
    }else if (indexPath.section == 1){
        LBHomeActivityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:homeActivityTableViewCell forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = self.modelActivity.buying.data[indexPath.row];
        WeakSelf;
        cell.rightnowBuy = ^(NSString *good_id) {
            weakSelf.hidesBottomBarWhenPushed = YES;
            LBSnapUpDetailViewController *vc = [[LBSnapUpDetailViewController alloc]init];
            vc.goods_id = good_id;
            [weakSelf.navigationController pushViewController:vc animated:YES];
            weakSelf.hidesBottomBarWhenPushed = NO;
        };
        cell.refreshData = ^{
            [weakSelf postRequestActivity];
        };
        return cell;
    }
   
    return [[UITableViewCell alloc]init];
}

-(UIView*)tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section {
    
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    headerLabel.backgroundColor = [UIColor groupTableViewBackgroundColor];

    return headerLabel;
    
}

-(CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section {
    return 10.0f;
}
-(CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0001f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        self.hidesBottomBarWhenPushed = YES;
        LBTimeLimitBuyingViewController *vc = [[LBTimeLimitBuyingViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
        self.hidesBottomBarWhenPushed = NO;
    }
}
//跳搜素
- (IBAction)tapgestureSearch:(UITapGestureRecognizer *)sender {
    self.hidesBottomBarWhenPushed = YES;
    LBTmallHotsearchViewController *vc =[[LBTmallHotsearchViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}
//扫码
- (IBAction)jumpScan:(UIButton *)sender {
    if ([UserModel defaultUser].loginstatus == NO) {
        [EasyShowTextView showInfoText:@"请先登录"];
        return;
    }
    //设置扫码区域参数
    LBXScanViewStyle *style = [[LBXScanViewStyle alloc]init];
    style.centerUpOffset = 60;
    style.xScanRetangleOffset = 30;
    
    if ([UIScreen mainScreen].bounds.size.height <= 480 )
    {
        //3.5inch 显示的扫码缩小
        style.centerUpOffset = 40;
        style.xScanRetangleOffset = 20;
    }
    
    style.alpa_notRecoginitonArea = 0.6;
    
    style.photoframeAngleStyle = LBXScanViewPhotoframeAngleStyle_Inner;
    style.photoframeLineW = 2.0;
    style.photoframeAngleW = 16;
    style.photoframeAngleH = 16;
    
    style.isNeedShowRetangle = NO;
    
    style.anmiationStyle = LBXScanViewAnimationStyle_NetGrid;
    
    //使用的支付宝里面网格图片
    UIImage *imgFullNet = [UIImage imageNamed:@"CodeScan.bundle/qrcode_scan_full_net"];
    
    style.animationImage = imgFullNet;
    
    [self openScanVCWithStyle:style];
}

- (void)openScanVCWithStyle:(LBXScanViewStyle*)style
{
    self.hidesBottomBarWhenPushed = YES;
    SubLBXScanViewController *vc = [SubLBXScanViewController new];
    vc.style = style;
    //vc.isOpenInterestRect = YES;
    __weak typeof(self) weakself = self;
    vc.retureCode = ^(NSString *codeStr){
        //跳转
        [weakself getStoreInfo:codeStr];//返回信息
        
    };
    [self.navigationController pushViewController:vc animated:YES];
    self.hidesBottomBarWhenPushed = NO;
    
}

-(void)getStoreInfo:(NSString*)str{
    
    NSDictionary *dic = str.mj_JSONObject;
    
    if (![dic.allKeys containsObject:@"shopuid"] || ![dic.allKeys containsObject:@"money"] || ![dic.allKeys containsObject:@"rlmoney"]) {
        [EasyShowTextView showErrorText:@"请扫正确的二维码"];
        return;
    }
    
    self.hidesBottomBarWhenPushed = YES;
    LBFaceToFace_PayController *vc = [LBFaceToFace_PayController new];
    vc.money  = [NSString stringWithFormat:@"%@",dic[@"money"]];
    vc.rlmoney  = [NSString stringWithFormat:@"%@",dic[@"rlmoney"]];//返利
    vc.shopuid  = [NSString stringWithFormat:@"%@",dic[@"shopuid"]];
    [self.navigationController pushViewController:vc animated:YES];
     self.hidesBottomBarWhenPushed = NO;
    
}
//选择城市列表
- (IBAction)chooseCityGesture:(UITapGestureRecognizer *)sender {
    
    GYZChooseCityController *cityPickerVC = [[GYZChooseCityController alloc] init];
    [cityPickerVC setDelegate:self];
    
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:[[UINavigationController alloc] initWithRootViewController:cityPickerVC] animated:YES completion:^{
        
    }];
}

//选择城市
- (void) cityPickerController:(GYZChooseCityController *)chooseCityController
                didSelectCity:(GYZCity *)city{
    
    self.cityLb.text = city.cityName;
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
            [self getWeatherInfo];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"LBEatAndDrinkViewController" object:nil];
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
    [self getWeatherInfo];
}
//取消
- (void) cityPickerControllerDidCancel:(GYZChooseCityController *)chooseCityController{
    
    [[UIApplication sharedApplication].keyWindow.rootViewController dismissViewControllerAnimated:YES completion:^{
        
    }];
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat   offset = scrollView.contentOffset.y;
    if (offset < 0) {
        self.navigationView.hidden = YES;
    }else{
        self.navigationView.hidden = NO;
    }
    
}
///** 点击图片回调 */
//- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
//
////    [self.delegete tapgestureImage:index];
//
//}

#pragma mark - 懒加载

-(GLNearby_ClassifyHeaderView*)classfyHeaderV{
    
    if (!_classfyHeaderV) {
        _classfyHeaderV = [[GLNearby_ClassifyHeaderView alloc]initWithFrame:CGRectMake(0, 0, UIScreenWidth, 155 + UIScreenWidth * bannerScale) withDataArr:self.tradeArr];
        _classfyHeaderV.autoresizingMask = UIViewAutoresizingNone;
        _classfyHeaderV.delegete = self;
//        _classfyHeaderV.cycleScrollView = self.cycleScrollView;
    }
    return _classfyHeaderV;
}
-(NSArray*)tradeArr{
    
    if (!_tradeArr) {
        _tradeArr = [NSArray array];
    }
    return _tradeArr;
}

- (NSMutableArray *)models{
    if (!_models) {
        _models = [NSMutableArray array];
    }
    return _models;
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
