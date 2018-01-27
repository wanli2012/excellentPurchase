//
//  LBAccountSecurityViewController.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/1/12.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "LBAccountSecurityViewController.h"
#import "LBSetUpTableViewCell.h"
#import "LBChangePasswordViewController.h"
#import "LBChangeSecondaryPasswordVc.h"
#import "LBResetOldPhoneViewController.h"
#import "LBBankCardListViewController.h"

@interface LBAccountSecurityViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableview;
/**
 数据
 */
@property (strong, nonatomic) NSArray *dataArr;

@end

static NSString *setUpTableViewCell = @"LBSetUpTableViewCell";

@implementation LBAccountSecurityViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"安全管理";
    self.navigationController.navigationBar.hidden = NO;
    //注册cell
    [self.tableview registerNib:[UINib nibWithNibName:setUpTableViewCell bundle:nil] forCellReuseIdentifier:setUpTableViewCell];
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    LBSetUpTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:setUpTableViewCell forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.titleLb.text = self.dataArr[indexPath.row];
    
    cell.headimage.hidden = YES;
    cell.arrowImage.hidden = NO;
    cell.cacheLB.hidden = YES;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([self.dataArr[indexPath.row] isEqualToString:@"修改密码"]) {
        self.hidesBottomBarWhenPushed = YES;
        LBChangePasswordViewController *vc =[[LBChangePasswordViewController alloc]init];
         vc.naviStr = @"修改密码";
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([self.dataArr[indexPath.row] isEqualToString:@"修改二级密码"]){
        self.hidesBottomBarWhenPushed = YES;
        LBChangeSecondaryPasswordVc *vc =[[LBChangeSecondaryPasswordVc alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([self.dataArr[indexPath.row] isEqualToString:@"修改手机号"]){
        self.hidesBottomBarWhenPushed = YES;
        LBResetOldPhoneViewController *vc =[[LBResetOldPhoneViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([self.dataArr[indexPath.row] isEqualToString:@"修改绑定银行卡"]){
        self.hidesBottomBarWhenPushed = YES;
        LBBankCardListViewController *vc =[[LBBankCardListViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
        
    }
}


-(NSArray*)dataArr{
    if (!_dataArr) {
        _dataArr = [NSArray arrayWithObjects:@"修改密码",@"修改二级密码",@"修改手机号",@"修改绑定银行卡", nil];
    }
    return _dataArr;
}

@end
