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
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    
}

#pragma mark -UITableviewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 3;
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
    
    //    cell.model = self.models[indexPath.row];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 60;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *vcstr = self.userVcArr[indexPath.row];
    Class classvc = NSClassFromString(vcstr);
    UIViewController *vc = [[classvc alloc]init];
    
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];

}


#pragma mark - 懒加载

-(NSMutableArray*)userVcArr{
    
    if (!_userVcArr) {
        _userVcArr=[NSMutableArray arrayWithObjects:
                    @"LBDonationViewController",
                    @"LBVoucherCenterViewController",
                    @"GLMine_MyWallet_CashController",nil];
        
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
