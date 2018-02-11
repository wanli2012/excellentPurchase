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

@interface GLMine_ManagementController ()

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

@end

@implementation GLMine_ManagementController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"商家管理";
    self.contentViewWidth.constant = UIScreenWidth * 2 - 120.0/750.0 * UIScreenWidth;
    
    self.todayView.layer.shadowColor = [UIColor blackColor].CGColor;//shadowColor阴影颜色
    self.todayView.layer.shadowOffset = CGSizeMake(0,0);//
    self.todayView.layer.shadowOpacity = 0.2;//阴影透明度，默认0
    self.todayView.layer.shadowRadius = 6;//阴影半径，默认3
    
    self.monthView.layer.shadowColor = [UIColor blackColor].CGColor;//shadowColor阴影颜色
    self.monthView.layer.shadowOffset = CGSizeMake(0,0);
    self.monthView.layer.shadowOpacity = 0.2;//阴影透明度，默认0
    self.monthView.layer.shadowRadius = 6;//阴影半径，默认3

    [self postRequest];
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


@end
