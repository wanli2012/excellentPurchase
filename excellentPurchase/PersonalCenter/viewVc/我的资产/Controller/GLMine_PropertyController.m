//
//  GLMine_PropertyController.m
//  excellentPurchase
//
//  Created by 龚磊 on 2018/1/23.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "GLMine_PropertyController.h"
#import "GLMine_PropertyCell.h"

@interface GLMine_PropertyController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, copy)NSArray *titlesArr;
@property (nonatomic, copy)NSArray *valuesArr;
@property (weak, nonatomic) IBOutlet UILabel *totalSumLabel;//总收益

@end

@implementation GLMine_PropertyController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"我的资产";
    
    self.totalSumLabel.text = [UserModel defaultUser].money_sum;

    self.titlesArr = @[@"积分",@"余额",@"购物券",@"福宝",@"福宝单价",@"平台昨日营业额总量",@"平台新增积分总量",@"平台昨日福宝转化"];
    self.valuesArr = @[[UserModel defaultUser].mark,//用户积分
                       [UserModel defaultUser].balance,//用户余额
                       [UserModel defaultUser].shopping_voucher,//用户购物券
                       [UserModel defaultUser].keti_bean,//用户福宝
                       [UserModel defaultUser].currency,//福宝单价
                       [UserModel defaultUser].Total_money,//平台昨日营业额总量
                       [UserModel defaultUser].Total_mark,//平台昨日新增积分总量
                       [UserModel defaultUser].Total_currency,//平台昨日福宝新增
                       ];
    [self.tableView registerNib:[UINib nibWithNibName:@"GLMine_PropertyCell" bundle:nil] forCellReuseIdentifier:@"GLMine_PropertyCell"];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

#pragma mark - UITableViewDelegate UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.titlesArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GLMine_PropertyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GLMine_PropertyCell" forIndexPath:indexPath];
    cell.titleLabel.text = self.titlesArr[indexPath.row];
    cell.valueLabel.text = self.valuesArr[indexPath.row];
//    cell.model = self.models[indexPath.row];
    cell.selectionStyle = 0;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

@end
