//
//  GLMine_MyWalletController.m
//  excellentPurchase
//
//  Created by 龚磊 on 2018/1/25.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "GLMine_MyWalletController.h"
#import "LBSetUpTableViewCell.h"

#import "LBDonationViewController.h"//转赠
#import "LBVoucherCenterViewController.h"//充值中心
#import "GLMine_MyWallet_CashController.h"//提现

@interface GLMine_MyWalletController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong)UITableView *tableView;

@property (nonatomic, strong)NSMutableArray *userVcArr;//会员控制器数组

@end

@implementation GLMine_MyWalletController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"我的钱包";
    
    [self.view addSubview:self.tableView];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"LBSetUpTableViewCell" bundle:nil] forCellReuseIdentifier:@"LBSetUpTableViewCell"];
    
//    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    
}

#pragma mark -UITableviewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if([[UserModel defaultUser].group_id integerValue] == GROUP_SHOP){
        return 3;
    }else{
        return 2;
    }

}

-(UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    LBSetUpTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LBSetUpTableViewCell"];
    cell.selectionStyle = 0;
    cell.headimage.hidden = YES;
    cell.cacheLB.hidden = YES;
    
    if (indexPath.row == 0) {
        cell.titleLb.text = @"转赠";
    }else if(indexPath.row == 1){
        cell.titleLb.text = @"充值中心";
    }else{
        cell.titleLb.text = @"提现";
    }

    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *vcstr = self.userVcArr[indexPath.row];
    
    if([vcstr isEqualToString:@"LBDonationViewController"] || [vcstr isEqualToString:@"GLMine_MyWallet_CashController"]){//我的团队
        
        if([[UserModel defaultUser].rzstatus integerValue] == 0){////用户 认证状态 0没有认证 1:申请实名认证 2审核通过3失败
            [EasyShowTextView showInfoText:@"请先实名认证"];
            return;
        }else if([[UserModel defaultUser].rzstatus integerValue] == 1){
            [EasyShowTextView showInfoText:@"实名认证审核中"];
            return;
        }else if([[UserModel defaultUser].rzstatus integerValue] == 3){
            [EasyShowTextView showInfoText:@"实名认证失败"];
            return;
        }
    }

    Class classvc = NSClassFromString(vcstr);
    UIViewController *vc = [[classvc alloc]init];
    
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];

}

#pragma mark - 懒加载
-(NSMutableArray*)userVcArr{
    
    if (!_userVcArr) {
        if([[UserModel defaultUser].group_id integerValue] == GROUP_SHOP){
            
            _userVcArr=[NSMutableArray arrayWithObjects:
                        @"LBDonationViewController",
                        @"LBVoucherCenterViewController",
                        @"GLMine_MyWallet_CashController",nil];
        }else{
            _userVcArr=[NSMutableArray arrayWithObjects:
                        @"LBDonationViewController",
                        @"LBVoucherCenterViewController",nil];
        }
    }
    
    return _userVcArr;
}

- (UITableView *)tableView{
    
    if (!_tableView) {
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, UIScreenWidth, UIScreenHeight) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.scrollEnabled = NO;
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
    }
    return _tableView;
}

@end
