//
//  GLMine_Branch_DetailController.m
//  excellentPurchase
//
//  Created by 龚磊 on 2018/1/24.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "GLMine_Branch_DetailController.h"
#import "GLMine_Branch_AccountManageController.h"//账号管理
#import "GLMine_Branch_QueryAchievementController.h"//业绩查询

@interface GLMine_Branch_DetailController ()

@property (nonatomic, strong)NSDictionary *dicData;

@property (weak, nonatomic) IBOutlet UIImageView *picImageV;//图片
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;//店铺名
@property (weak, nonatomic) IBOutlet UILabel *IDNumberLabel;//ID号
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;//收益类型
@property (weak, nonatomic) IBOutlet UILabel *month_incomeLabel;//当月销售额
@property (weak, nonatomic) IBOutlet UILabel *total_incomeLabel;//累计销售额

@end

@implementation GLMine_Branch_DetailController

- (void)viewDidLoad {
    [super viewDidLoad];
   
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
    dict[@"sid"] = self.sid;//商铺id
    
    [EasyShowLodingView showLoding];
    [NetworkManager requestPOSTWithURLStr:kstore_branch_find paramDic:dict finish:^(id responseObject) {
        
        [EasyShowLodingView hidenLoding];
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE) {
            
            self.dicData = responseObject[@"data"];
            
            [self assignment];
            
        }else{
            
            [EasyShowTextView showErrorText:responseObject[@"message"]];
        }
        
    } enError:^(NSError *error) {
        
        [EasyShowLodingView hidenLoding];
        [EasyShowTextView showErrorText:error.localizedDescription];
    }];
}

/**赋值*/
- (void)assignment{
 
    [self.picImageV sd_setImageWithURL:[NSURL URLWithString:self.dicData[@"thumb"]] placeholderImage:[UIImage imageNamed:PlaceHolder]];
    self.nameLabel.text = [self judgeStringIsNull:self.dicData[@"sname"] andDefault:NO];
    self.IDNumberLabel.text = [self judgeStringIsNull:self.dicData[@"uname"] andDefault:NO];
    
    if ([self.dicData[@"type"] integerValue] == 1) {
        self.typeLabel.text = @"收益自营"; //收益类型 1收益自营 2其它店铺收益
    }else{
        self.typeLabel.text = @"其他店铺收益"; //收益类型 1收益自营 2其它店铺收益
    }
    
    self.month_incomeLabel.text = [NSString stringWithFormat:@"¥ %@",[self judgeStringIsNull:self.dicData[@"fullmoon"] andDefault:YES]];
    self.total_incomeLabel.text = [NSString stringWithFormat:@"¥ %@",[self judgeStringIsNull:self.dicData[@"goodsmoney"] andDefault:YES]];
    
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


/**账号管理*/
- (IBAction)accountManage:(id)sender {
    
    self.hidesBottomBarWhenPushed = YES;
    GLMine_Branch_AccountManageController *manageVC = [[GLMine_Branch_AccountManageController alloc] init];
    [self.navigationController pushViewController:manageVC animated:YES];
    
}

/**
 淘淘店
 */
- (IBAction)branchDetail:(id)sender {
    NSLog(@" 淘淘店");
}

/**
 吃喝玩乐店
 */
- (IBAction)eatAndDrink:(id)sender {
    NSLog(@" 吃喝玩乐店");
}

/**
 历史记录
 */
- (IBAction)historyAchievement:(id)sender {
    self.hidesBottomBarWhenPushed = YES;
    GLMine_Branch_QueryAchievementController *VC= [[GLMine_Branch_QueryAchievementController alloc] init];
    [self.navigationController pushViewController:VC animated:YES];
}

/**
 冻结账号
 */
- (IBAction)frezzAccount:(id)sender {
    NSLog(@"冻结账号");
}


@end
