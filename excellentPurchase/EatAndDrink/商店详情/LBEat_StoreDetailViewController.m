//
//  LBEat_StoreDetailViewController.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/1/18.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "LBEat_StoreDetailViewController.h"
#import "JYCarousel.h"
#import "JYImageCache.h"
#import "LBEat_storeDetailInfoOtherTableViewCell.h"
#import "LBEat_storeDetailInfodiscountTableViewCell.h"
#import "LBEat_storeDetailInfomationHeaderView.h"
#import "LBEat_storeDetailInfomationTableViewCell.h"
#import "LBEat_StoreCommentsViewController.h"
#import "LBEat_StoreDetailDataModel.h"
#import "LBXScanView.h"
#import "LBXScanResult.h"
#import "LBXScanWrapper.h"
#import "SubLBXScanViewController.h"
#import "LBEatProductDetailViewController.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <MapKit/MapKit.h>
#import "LBFaceToFace_PayController.h"

static NSString *eat_storeDetailInfodiscountTableViewCell = @"LBEat_storeDetailInfodiscountTableViewCell";
static NSString *eat_storeDetailInfoOtherTableViewCell = @"LBEat_storeDetailInfoOtherTableViewCell";
static NSString *eat_storeDetailInfomationTableViewCell = @"LBEat_storeDetailInfomationTableViewCell";

@interface LBEat_StoreDetailViewController ()<UITableViewDelegate,UITableViewDataSource,LBEat_storeDetailInfomationdelegete>

@property (strong , nonatomic)UIButton *collectionButton;
@property (strong , nonatomic)UIButton *messageButton;

/**
 头部轮播
 */
@property (nonatomic, strong) JYCarousel *carouselView;
@property (weak, nonatomic) IBOutlet UITableView *tableview;

@property (nonatomic, strong) LBEat_StoreDetailDataModel *model;

@end

@implementation LBEat_StoreDetailViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = self.titilestr;
    
    [self addRightItems];
    
    [self.tableview registerNib:[UINib nibWithNibName:eat_storeDetailInfodiscountTableViewCell bundle:nil] forCellReuseIdentifier:eat_storeDetailInfodiscountTableViewCell];
    [self.tableview registerNib:[UINib nibWithNibName:eat_storeDetailInfoOtherTableViewCell bundle:nil] forCellReuseIdentifier:eat_storeDetailInfoOtherTableViewCell];
    [self.tableview registerNib:[UINib nibWithNibName:eat_storeDetailInfomationTableViewCell bundle:nil] forCellReuseIdentifier:eat_storeDetailInfomationTableViewCell];

    [self loadData];//加载数据
    [self setupNpdata];//设置无数据的时候展示
}

-(void)setupNpdata{
    WeakSelf;
    self.tableview.tableFooterView = [UIView new];
    
    self.tableview.ly_emptyView = [LYEmptyView emptyViewWithImageStr:@"nodata_pic"
                                                            titleStr:@"暂无数据，点击重新加载"
                                                           detailStr:@""];
    self.tableview.ly_emptyView.imageSize = CGSizeMake(100, 100);
    self.tableview.ly_emptyView.titleLabTextColor = YYSRGBColor(109, 109, 109, 1);
    self.tableview.ly_emptyView.titleLabFont = [UIFont fontWithName:@"MDT_1_95969" size:15];
    self.tableview.ly_emptyView.detailLabFont = [UIFont fontWithName:@"MDT_1_95969" size:13];
    
    
    //emptyView内容上的点击事件监听
    [self.tableview.ly_emptyView setTapContentViewBlock:^{
        [weakSelf loadData];
    }];
}

-(void)loadData{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"app_handler"] = @"SEARCH";
    dic[@"store_id"] = self.store_id;
    if ([UserModel defaultUser].loginstatus == YES) {
        dic[@"uid"] = [UserModel defaultUser].uid;
    }
    
    [EasyShowLodingView showLodingText:@"正在加载"];
    [NetworkManager requestPOSTWithURLStr:HappyShopData paramDic:dic finish:^(id responseObject) {

        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE) {
        
            _model =  [LBEat_StoreDetailDataModel mj_objectWithKeyValues:responseObject[@"data"]];
            if ([_model.is_collect integerValue] == 0) {
                _collectionButton.selected = NO;
            }else{
                _collectionButton.selected = YES;
            }
            [self addCarouselView1];//加载头部视图
            [self.tableview reloadData];
        }else{
            
            [EasyShowTextView showErrorText:responseObject[@"message"]];
        }
        
        [EasyShowLodingView hidenLoding];
    } enError:^(NSError *error) {
        [EasyShowLodingView hidenLoding];
    }];
    
}

/**
 点击评论
 */
-(void)tapgesturecomments{
    self.hidesBottomBarWhenPushed = YES;
    LBEat_StoreCommentsViewController *vc = [[LBEat_StoreCommentsViewController alloc]init];
    vc.store_id = self.model.store_id;
    [self.navigationController pushViewController:vc animated:YES];
    
}
-(void)gotoStoreAdress{
    CGFloat lat = [self.model.lat floatValue];
    CGFloat lng = [self.model.lng floatValue];
    
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"baidumap://"]])// -- 使用 canOpenURL 判断需要在info.plist 的 LSApplicationQueriesSchemes 添加 baidumap 。
    {
        NSString *urlString = [[NSString stringWithFormat:@"baidumap://map/direction?origin={{我的位置}}&destination=latlng:%f,%f | name:%@&mode=driving&coord_type=bd0911",lat, lng,self.model.store_address] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
        
    }else{
        //使用自带地图导航
        CLLocationCoordinate2D destCoordinate;
        // 将数据传到反地址编码模型
        destCoordinate = AMapCoordinateConvert(CLLocationCoordinate2DMake(lat,lng), AMapCoordinateTypeBaidu);
        
        MKMapItem *currentLocation =[MKMapItem mapItemForCurrentLocation];
        
        MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:destCoordinate addressDictionary:nil]];
        toLocation.name = self.model.store_address;
        
        [MKMapItem openMapsWithItems:@[currentLocation,toLocation] launchOptions:@{MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving,MKLaunchOptionsShowsTrafficKey:[NSNumber numberWithBool:YES]}];
    }
}
#pragma mark - 到店支付
-(void)ComeStorePay{
    
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
    
}

#pragma mark - 重写----设置有groupTableView有几个分区
-(NSInteger)numberOfSectionsInTableView:(UITableView*)tableView {
    if (self.model) {
        return 2;
    }
    return 0; //返回值是多少既有几个分区
}
#pragma mark - 重写----设置每个分区有几个单元格
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //分别设置每个分组上面显示的单元格个数
    if (section == 0) {
        return 1;
    }else if (section == 1){
         return self.model.other.count;
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        tableView.estimatedRowHeight = 100;
        tableView.rowHeight = UITableViewAutomaticDimension;
        return UITableViewAutomaticDimension;
    }else if (indexPath.section == 1){
        tableView.estimatedRowHeight = 60;
        tableView.rowHeight = UITableViewAutomaticDimension;
        return UITableViewAutomaticDimension;
    }
    return 0;
    
}

#pragma mark - 重写----设置每个分组单元格中显示的内容
-(UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        LBEat_storeDetailInfomationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:eat_storeDetailInfomationTableViewCell forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        cell.model = self.model;
        return cell;
    }else if (indexPath.section == 1){
        LBEat_storeDetailInfoOtherTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:eat_storeDetailInfoOtherTableViewCell forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = self.model.other[indexPath.row];
        return cell;
    }
    return [[UITableViewCell alloc]init];
    
}

#pragma mark - 重写----设置自定义的标题和标注

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (section != 0) {
        LBEat_storeDetailInfomationHeaderView *headerLabel = [[NSBundle mainBundle]loadNibNamed:@"LBEat_storeDetailInfomationHeaderView" owner:self options:nil].firstObject;
        
        return headerLabel;
    }
    
    return nil;
}

#pragma mark - 重写----设置标题和标注的高度
-(CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0.0001f;
    }
    return 50.0f;
}
-(CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0001f;
}
#pragma mark - 重写----设置哪个单元格被选中的方法
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
   
    if (indexPath.section == 1) {
        self.hidesBottomBarWhenPushed = YES;
        LBEatProductDetailViewController *vc = [[LBEatProductDetailViewController alloc]init];
        LBEat_StoreDetailOtherDataModel *model = self.model.other[indexPath.row];
        vc.goods_id = model.goods_id;
         vc.goods_name = model.goods_name;
        [self.navigationController pushViewController:vc animated:YES];
    }
}


-(void)addRightItems{
    
    _collectionButton=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    _collectionButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;//左对齐
    [_collectionButton setImage:[UIImage imageNamed:@"taotao-collect-n"] forState:UIControlStateNormal];
    [_collectionButton setImage:[UIImage imageNamed:@"taotao-collect-y"] forState:UIControlStateSelected];
//    [button setImageEdgeInsets:UIEdgeInsetsMake(10, -5, 10, 65)];
    _collectionButton.backgroundColor=[UIColor clearColor];
    [_collectionButton addTarget:self action:@selector(collectionButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    
    _messageButton=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    _messageButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;//左对齐
    [_messageButton setImage:[UIImage imageNamed:@"eat-chat"] forState:UIControlStateNormal];
    //    [button setImageEdgeInsets:UIEdgeInsetsMake(10, -5, 10, 65)];
    _messageButton.backgroundColor=[UIColor clearColor];
    [_messageButton addTarget:self action:@selector(messageButtonEvent) forControlEvents:UIControlEventTouchUpInside];
   
     UIBarButtonItem *ba1=[[UIBarButtonItem alloc]initWithCustomView:_collectionButton];
     UIBarButtonItem *ba2=[[UIBarButtonItem alloc]initWithCustomView:_messageButton];
    
    self.navigationItem.rightBarButtonItems = @[ba2,ba1];
    
}

/**
 收藏
 */
-(void)collectionButtonEvent:(UIButton*)sender{
    
    if (self.model) {
        if (sender.selected == YES) {//收藏过 ，该取消收藏
            [self userCancelCollection];
        }else{//取消该藏过
            [self userCollection];
        }
    }
    
}
//取消收藏
-(void)userCancelCollection{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"app_handler"] = @"DELETE";
    dic[@"collect_id"] = self.model.is_collect;
    dic[@"uid"] = [UserModel defaultUser].uid;
    dic[@"token"] = [UserModel defaultUser].token;
    dic[@"type"] = @"3"; //1收藏商品 2海淘商城店铺 3吃喝玩乐店铺
    
    [NetworkManager requestPOSTWithURLStr:SeaShoppingNot_collect paramDic:dic finish:^(id responseObject) {
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE) {
            self.model.is_collect=0;
            self.collectionButton.selected = NO;
        }else{
            
            [EasyShowTextView showErrorText:responseObject[@"message"]];
        }
        
    } enError:^(NSError *error) {
        [EasyShowTextView showErrorText:error.localizedDescription];
    }];
}
//收藏
-(void)userCollection{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"app_handler"] = @"ADD";
    dic[@"link_id"] = self.model.store_id;
    dic[@"uid"] = [UserModel defaultUser].uid;
    dic[@"token"] = [UserModel defaultUser].token;
    dic[@"type"] = @"3"; //1收藏商品 2海淘商城店铺 3吃喝玩乐店铺
    
    [NetworkManager requestPOSTWithURLStr:SeaShoppingUser_collect paramDic:dic finish:^(id responseObject) {
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE) {
            self.model.is_collect = [NSString stringWithFormat:@"%@",responseObject[@"data"]];
            self.collectionButton.selected = YES;
        }else{
            
            [EasyShowTextView showErrorText:responseObject[@"message"]];
        }
        
    } enError:^(NSError *error) {
        [EasyShowTextView showErrorText:error.localizedDescription];
    }];
}

/**
 消息
 */
-(void)messageButtonEvent{
    
    
}

- (void)addCarouselView1{
    
    //block方式创建
    __weak typeof(self) weakSelf = self;
    NSMutableArray *imageArray = [[NSMutableArray alloc] initWithArray: _model.store_pic];
    if (!_carouselView) {
        _carouselView= [[JYCarousel alloc] initWithFrame:CGRectMake(0, 0, UIScreenWidth, UIScreenWidth) configBlock:^JYConfiguration *(JYConfiguration *carouselConfig) {
            carouselConfig.pageContollType = LabelPageControl;
            carouselConfig.interValTime = 3;
            return carouselConfig;
        } clickBlock:^(NSInteger index) {

        }];
        self.tableview.tableHeaderView = _carouselView;
    }
    //开始轮播
    [_carouselView startCarouselWithArray:imageArray];
    
}

@end
