//
//  GLMine_ManagementController.m
//  excellentPurchase
//
//  Created by 龚磊 on 2018/1/23.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "GLMine_ManagementController.h"
#import "GLMine_Manage_BranchController.h"//分店管理
#import "GLMine_Branch_QueryAchievementController.h"//业绩查询
#import "GLMine_Branch_OnlineOrderController.h"//线上订单
#import "GLMine_Branch_OfflineOrderController.h"//线下订单
#import "GLMine_Seller_SetMoneyController.h"//收款二维码
#import "LBFinishMainViewController.h"
#import "LBMerChatFaceToFaceViewController.h"//面对面订单
#import "GLMine_Branch_Offline_PlaceOrderController.h"//线下下单

#import "GLMine_ManagementCell.h"

@interface GLMine_ManagementController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewWidth;
@property (weak, nonatomic) IBOutlet UIView *todayView;//当天
@property (weak, nonatomic) IBOutlet UIView *monthView;//当月

@property (weak, nonatomic) IBOutlet UILabel *todayTotalLabel;//当天营业总额
@property (weak, nonatomic) IBOutlet UILabel *today_OnlineLabel;//当天线上营业总额
@property (weak, nonatomic) IBOutlet UILabel *today_OfflineLabel;//当天线下营业总额
@property (weak, nonatomic) IBOutlet UILabel *monthTotalLabel;//当月营业总额
@property (weak, nonatomic) IBOutlet UILabel *month_OnlineLabel;//当月线上营业总额
@property (weak, nonatomic) IBOutlet UILabel *month_OfflineLabel;//当月线下营业总额
@property (weak, nonatomic) IBOutlet UIImageView *picImageV;//头像
@property (weak, nonatomic) IBOutlet UILabel *trueNameLabel;//真实姓名
@property (weak, nonatomic) IBOutlet UILabel *IDNumberLabel;//ID号

@property (nonatomic, strong)NSDictionary *dataDic;//数据源
@property (weak, nonatomic) IBOutlet UIButton *branchManageBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewHeight;
@property (weak, nonatomic) IBOutlet UILabel *orderLabel;//线下提单label

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *reasonViewHeight;
@property (weak, nonatomic) IBOutlet UIView *reasonView;//原因View

@property (nonatomic, copy)NSArray *imageArr;
@property (nonatomic, copy)NSArray *titleArr;

@end

@implementation GLMine_ManagementController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"商家管理";
    self.contentViewWidth.constant = UIScreenWidth * 2 - 120.0/750.0 * UIScreenWidth;
    self.contentViewHeight.constant = 800;
    
    self.todayView.layer.shadowColor = [UIColor blackColor].CGColor;//shadowColor阴影颜色
    self.todayView.layer.shadowOffset = CGSizeMake(0,0);//
    self.todayView.layer.shadowOpacity = 0.2;//阴影透明度，默认0
    self.todayView.layer.shadowRadius = 6;//阴影半径，默认3
    
    self.monthView.layer.shadowColor = [UIColor blackColor].CGColor;//shadowColor阴影颜色
    self.monthView.layer.shadowOffset = CGSizeMake(0,0);
    self.monthView.layer.shadowOpacity = 0.2;//阴影透明度，默认0
    self.monthView.layer.shadowRadius = 6;//阴影半径，默认3

    [self postRequest];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"GLMine_ManagementCell" bundle:nil] forCellWithReuseIdentifier:@"GLMine_ManagementCell"];
}

/**
 请求数据
 */
- (void)postRequest{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"app_handler"] = @"SEARCH";
    dict[@"uid"] = [UserModel defaultUser].uid;
    dict[@"token"] = [UserModel defaultUser].token;
    
    [EasyShowLodingView showLoding];
    [NetworkManager requestPOSTWithURLStr:kstore_find paramDic:dict finish:^(id responseObject) {
        
        [EasyShowLodingView hidenLoding];
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE) {
            
            self.dataDic = responseObject[@"data"];
            
            [self assignment];//赋值
            
        }else{
            
            [EasyShowTextView showErrorText:responseObject[@"message"]];
        }
        
    } enError:^(NSError *error) {
        
        [EasyShowLodingView hidenLoding];
        [EasyShowTextView showErrorText:error.localizedDescription];
    }];
}

/**
 赋值
 */
- (void)assignment{
    
    [self.picImageV sd_setImageWithURL:[NSURL URLWithString:self.dataDic[@"pic"]] placeholderImage:[UIImage imageNamed:PlaceHolder]];
    
    NSString *truename = [self judgeStringIsNull:self.dataDic[@"truename"] andDefault:NO];
    NSString *user_name = [self judgeStringIsNull:self.dataDic[@"user_name"] andDefault:NO];
    NSString *store_today_money = [self judgeStringIsNull:self.dataDic[@"store_today_money"] andDefault:YES];
    NSString *store_up_money = [self judgeStringIsNull:self.dataDic[@"store_up_money"] andDefault:YES];
    NSString *store_earth_money = [self judgeStringIsNull:self.dataDic[@"store_earth_money"] andDefault:YES];
    NSString *data_month_up = [self judgeStringIsNull:self.dataDic[@"data_month_up"] andDefault:YES];
    NSString *data_month_earth = [self judgeStringIsNull:self.dataDic[@"data_month_earth"] andDefault:YES];
    NSString *data_month = [self judgeStringIsNull:self.dataDic[@"data_month"] andDefault:YES];
    
    if (truename.length == 0) {
        self.trueNameLabel.text = @"真实姓名:未设置";
    }else{
        self.trueNameLabel.text = truename;
    }
    
    self.IDNumberLabel.text = user_name;
    self.todayTotalLabel.text = [NSString stringWithFormat:@"¥ %@",store_today_money];
    self.today_OnlineLabel.text = [NSString stringWithFormat:@"¥ %@",store_up_money];
    self.today_OfflineLabel.text = [NSString stringWithFormat:@"¥ %@",store_earth_money];
    self.monthTotalLabel.text = [NSString stringWithFormat:@"¥ %@",data_month];
    self.month_OnlineLabel.text = [NSString stringWithFormat:@"¥ %@",data_month_up];
    self.month_OfflineLabel.text = [NSString stringWithFormat:@"¥ %@",data_month_earth];
    
    if([self.dataDic[@"store_main"] integerValue] == 2){//商铺默认2 1主店 2分店
        self.branchManageBtn.hidden = YES;
        self.contentViewHeight.constant = 550;
    }else{
        self.branchManageBtn.hidden = NO;
        self.contentViewHeight.constant = 620;
    }
    
    if([self.dataDic[@"store_auditing"] integerValue] == 1){//商铺审核状态默认1 1未审核 2审核不通过 3审核通过
        self.orderLabel.text = @"审核中";
    }else if([self.dataDic[@"store_auditing"] integerValue] == 2){
        self.orderLabel.text = @"重新提交";
    }else if([self.dataDic[@"store_auditing"] integerValue] == 3){
        self.orderLabel.text = @"线下提单";
    }
    
}

//判空 给数字设置默认值
- (NSString *)judgeStringIsNull:(id )sender andDefault:(BOOL)isNeedDefault{
    
    NSString *str = [NSString stringWithFormat:@"%@",sender];
    
    if ([NSString StringIsNullOrEmpty:str]) {
        
        if (isNeedDefault) {
            return @"0.00";
        }else{
            return @"";
        }
    }else{
        return str;
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = NO;
}

#pragma mark - 线下提单
- (IBAction)markOrderOffline:(id)sender {
    
    self.hidesBottomBarWhenPushed = YES;
    GLMine_Branch_Offline_PlaceOrderController *makeOrderVC = [[GLMine_Branch_Offline_PlaceOrderController alloc] init];
    makeOrderVC.type = 1;////1:线下下单 2:线下订单失败 重新下单
    [self.navigationController pushViewController:makeOrderVC animated:YES];
    
}

#pragma mark - 六块主功能
/**
 线上订单
 */
- (IBAction)orderOnline:(id)sender {
    
    self.hidesBottomBarWhenPushed = YES;
    GLMine_Branch_OnlineOrderController *vc = [[GLMine_Branch_OnlineOrderController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

/**
 线下订单
 */
- (IBAction)orderOffline:(id)sender {
    self.hidesBottomBarWhenPushed = YES;
    GLMine_Branch_OfflineOrderController *vc = [[GLMine_Branch_OfflineOrderController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

/**
 业绩查询
  */
- (IBAction)queryAchievement:(id)sender {

    self.hidesBottomBarWhenPushed = YES;
    GLMine_Branch_QueryAchievementController *vc = [[GLMine_Branch_QueryAchievementController alloc] init];
    vc.typeIndex = 1;//1:主点的业绩查询 2:分店的业绩查询
    [self.navigationController pushViewController:vc animated:YES];
}

/**
 店铺装修
  */
- (IBAction)storeDecorate:(id)sender {

    self.hidesBottomBarWhenPushed = YES;
    LBFinishMainViewController * vc = [[LBFinishMainViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

/**
 分店管理
  */
- (IBAction)branchManage:(id)sender {

    self.hidesBottomBarWhenPushed = YES;
    GLMine_Manage_BranchController *vc = [[GLMine_Manage_BranchController alloc] init];
    
    [self.navigationController pushViewController:vc animated:YES];
}

/**
 收款二维码
  */
- (IBAction)incomeCode:(id)sender {
    
    self.hidesBottomBarWhenPushed = YES;
    GLMine_Seller_SetMoneyController *vc = [[GLMine_Seller_SetMoneyController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

//面对面订单
- (IBAction)faceToFaceOrders:(UIButton *)sender {
    self.hidesBottomBarWhenPushed = YES;
    LBMerChatFaceToFaceViewController *vc = [[LBMerChatFaceToFaceViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    
}

#pragma mark - UICollectionviewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 8;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    GLMine_ManagementCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"GLMine_ManagementCell" forIndexPath:indexPath];
    
    if(indexPath.row > 3){
        cell.lineView.hidden = YES;
    }
    
    cell.picImageV.image = [UIImage imageNamed:self.imageArr[indexPath.row]];
    cell.nameLabel.text = self.titleArr[indexPath.row];
    
    return cell;
}
//定义每个UICollectionViewCell 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((self.view.width - 30)/4, 105);
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(10, 15, 20, 15);
}
//每个section中不同的行之间的行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

//每个item之间的间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}


#pragma mark - 懒加载
- (NSArray *)imageArr{
    if (!_imageArr) {
        _imageArr = @[@"线上订单_商家管理",@"线下订单_商家管理",@"业绩查询_商家管理",@"线下提单_商家管理",@"分店管理_商家管理",@"店铺装修_商家管理",@"面对面订单_商家管理",@"收款二维码_商家管理"];
    }
    return _imageArr;
}
- (NSArray *)titleArr{
    if (!_titleArr) {
        _titleArr = @[@"线上订单",@"线下订单",@"业绩查询",@"线下提单",@"分店管理",@"店铺装修",@"面对面订单家",@"收款二维码"];
    }
    return _titleArr;
}
@end
