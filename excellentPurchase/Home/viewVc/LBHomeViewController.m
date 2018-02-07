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
#import "LBImmediateRushBuyCell.h"
#import "UIImage+GIF.h"
#import <CoreLocation/CoreLocation.h>
#import "LBSetUpViewController.h"
#import "LBHistoryHotSerachViewController.h"
#import "LBSaveLocationInfoModel.h"
#import "GYZChooseCityController.h"

#import "GLHomeModel.h"

@interface LBHomeViewController ()<UITableViewDelegate,UITableViewDataSource,CLLocationManagerDelegate,GYZChooseCityDelegate,LBHorseGroupTableViewCellDelegate,ClassifyHeaderViewdelegete>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *navigationH;//导航栏高度
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) IBOutlet UIView *navigationView;//自定义导航栏
@property (weak, nonatomic) IBOutlet UIView *searchView;//自定义搜索view
@property (strong, nonatomic)GLNearby_ClassifyHeaderView *classfyHeaderV;//自定义头部视图
@property (strong, nonatomic)NSArray *tradeArr;//分类数据数组
@property (weak, nonatomic) IBOutlet UIImageView *activityImage;//底部活动图片

@property (nonatomic,strong ) CLLocationManager *locationManager;//定位服务
@property (weak, nonatomic) IBOutlet UILabel *cityLb;//城市展示
//天气图片
@property (weak, nonatomic) IBOutlet UIImageView *weatherImage;
//温度
@property (weak, nonatomic) IBOutlet UILabel *temperatureLb;


//@property (strong, nonatomic)SDCycleScrollView *cycleScrollView;//banner
//@property (nonatomic, copy)NSArray *imagearr;

@property (nonatomic, strong)NSMutableArray *models;
@property (nonatomic, assign)NSInteger page;
@property (nonatomic, strong)NodataView *nodataV;
@property (nonatomic, strong)GLHomeModel *model;


@end

static NSString *horseGroupTableViewCell = @"LBHorseGroupTableViewCell";
static NSString *immediateRushBuyCell = @"LBImmediateRushBuyCell";

@implementation LBHomeViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    
    //kShop_index_URL
}

-(void)updateViewConstraints{
    [super updateViewConstraints];
    self.navigationH.constant = SafeAreaTopHeight;
    self.searchView.layer.cornerRadius = 15;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self locatemap];//定位
     [self.tableview registerNib:[UINib nibWithNibName:immediateRushBuyCell bundle:nil] forCellReuseIdentifier:immediateRushBuyCell];
    
    adjustsScrollViewInsets_NO(self.tableview, self);
    self.tableview.tableHeaderView = self.classfyHeaderV;
    
    self.tradeArr = @[@{@"trade_name":@"滔滔商城",@"thumb":@"fenlei"},
                      @{@"trade_name":@"滔滔商城",@"thumb":@"fenlei"},
                      @{@"trade_name":@"滔滔商城",@"thumb":@"fenlei"},
                      @{@"trade_name":@"滔滔商城",@"thumb":@"fenlei"},
                      @{@"trade_name":@"滔滔商城",@"thumb":@"fenlei"},
                      @{@"trade_name":@"滔滔商城",@"thumb":@"fenlei"},
                      @{@"trade_name":@"滔滔商城",@"thumb":@"fenlei"},
                      @{@"trade_name":@"滔滔商城",@"thumb":@"fenlei"}];
    
    [self.classfyHeaderV initdatasorece:self.tradeArr];
    //   底部视图高度
    self.tableview.tableFooterView.height = UIScreenWidth * bottomScale + 20 ;
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        // 处理耗时操作的代码块...
        NSString *path = [[NSBundle mainBundle] pathForResource:@"activity" ofType:@"gif"];
        NSData *data = [NSData dataWithContentsOfFile:path];
        UIImage *image = [UIImage sd_animatedGIFWithData:data];
        //通知主线程刷新
        dispatch_async(dispatch_get_main_queue(), ^{
            //回调或者说是通知主线程刷新，
            self.activityImage.image = image;
        });
        
    });
    
    [LBDefineRefrsh defineRefresh:self.tableview headerrefresh:^{
        [self postRequest:YES];
    }];
    
    self.page = 1;
    [self postRequest:YES];
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
        
//                self.classfyHeaderV.cycleScrollView.imageURLStringsGroup = arrM;
//                [self.classfyHeaderV.carouselView startCarouselWithArray:arrM];
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
         WeakSelf;
         [weakSelf locatemap];//定位
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
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
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain",@"text/html",@"application/json",nil];
    manager.requestSerializer.timeoutInterval=20;

 //NSString *urlStr1 = [NSString stringWithFormat:@"http://wthrcdn.etouch.cn/weather_mini?"];
//    NSMutableDictionary  *newDic = [NSMutableDictionary dictionary];
//    newDic[@"city"] = [LBSaveLocationInfoModel defaultUser].currentCity;
    
    NSString *url = [NSString stringWithFormat:@"https://api.thinkpage.cn/v3/weather/daily.json?key=osoydf7ademn8ybv&location=%@&language=zh-Hans&start=0&days=3",[LBSaveLocationInfoModel defaultUser].currentCity];
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    
    [manager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (responseObject) {
            self.temperatureLb.text = [NSString stringWithFormat:@"%@℃~%@℃",responseObject[@"results"][0][@"daily"][0][@"low"],responseObject[@"results"][0][@"daily"][0][@"high"]];
            [self addAnimationWithType:responseObject[@"results"][0][@"daily"][0][@"code_day"]];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
}

//添加动画
- (void)addAnimationWithType:(NSString *)weatherType{
    
   
    NSInteger type = [weatherType integerValue];
    if (type >= 0 && type < 4) { //晴天
        self.weatherImage.image = [UIImage imageNamed:@"天气38"];
    }
    else if (type >= 4 && type < 10) { //多云
       self.weatherImage.image = [UIImage imageNamed:@"天气8"];
    }
    else if (type >= 10 && type < 20) { //雨
      self.weatherImage.image = [UIImage imageNamed:@"组2拷贝@3x(1)"];
    }
    else if (type >= 20 && type < 26) { //雪
       self.weatherImage.image = [UIImage imageNamed:@"天气37"];
    }
    else if (type >= 26 && type < 30) { //沙尘暴
        self.weatherImage.image = [UIImage imageNamed:@"天气28"];
    }
    else if (type >= 30 && type < 32) { //雾霾
        self.weatherImage.image = [UIImage imageNamed:@"天气30"];
    }
    else if (type >= 32 && type < 37) { //风
       self.weatherImage.image = [UIImage imageNamed:@"天气32"];
        
    }
    else if (type == 37) { //冷
        self.weatherImage.image = [UIImage imageNamed:@"天气21"];
        
    }
    else if (type == 38) { //热
        self.weatherImage.image = [UIImage imageNamed:@"天气38"];
        
    }else{
 
    }
}

#pragma mark - LBHorseGroupTableViewCellDelegate
- (void)toDetail:(NSInteger)index infoIndex:(NSInteger)infoIndex{
    
    NSLog(@"---cellIndex = %zd-----infoIndex = %zd",index,infoIndex);
}

#pragma mark - 点击轮播图回调
- (void)tapgestureImage:(NSInteger)index{
    NSLog(@"----%zd",index);
}

#pragma mark - 重写----设置有groupTableView有几个分区
-(NSInteger)numberOfSectionsInTableView:(UITableView*)tableView {
    return 2; //返回值是多少既有几个分区
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
        return 130 * 2 + 1;
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
        }else if(indexPath.row == 1){
            cell.orderModels = self.model.orders;
        }
        cell.index = indexPath.row;
        cell.delegate = self;
        
        return cell;
    }else if (indexPath.section == 1){
        LBImmediateRushBuyCell *cell = [tableView dequeueReusableCellWithIdentifier:immediateRushBuyCell forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
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
    
    self.hidesBottomBarWhenPushed = YES;
    LBSetUpViewController *vc =[[LBSetUpViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
     self.hidesBottomBarWhenPushed = NO;
}

- (IBAction)tapgestureSearch:(UITapGestureRecognizer *)sender {
    self.hidesBottomBarWhenPushed = YES;
    LBHistoryHotSerachViewController *vc =[[LBHistoryHotSerachViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}
//选择城市列表
- (IBAction)chooseCityGesture:(UITapGestureRecognizer *)sender {
    
    GYZChooseCityController *cityPickerVC = [[GYZChooseCityController alloc] init];
    [cityPickerVC setDelegate:self];
    
    //    cityPickerVC.locationCityID = @"1400010000";
    //    cityPickerVC.commonCitys = [[NSMutableArray alloc] initWithArray: @[@"1400010000", @"100010000"]];        // 最近访问城市，如果不设置，将自动管理
    //    cityPickerVC.hotCitys = @[@"100010000", @"200010000", @"300210000", @"600010000", @"300110000"];
    
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:[[UINavigationController alloc] initWithRootViewController:cityPickerVC] animated:YES completion:^{
        
    }];
}
//选择城市
- (void) cityPickerController:(GYZChooseCityController *)chooseCityController
                didSelectCity:(GYZCity *)city{
    
    [[UIApplication sharedApplication].keyWindow.rootViewController dismissViewControllerAnimated:YES completion:^{
        
    }];
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

@end
