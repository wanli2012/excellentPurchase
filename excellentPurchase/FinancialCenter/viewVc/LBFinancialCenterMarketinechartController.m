//
//  LBFinancialCenterMarketinechartController.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/5/10.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "LBFinancialCenterMarketinechartController.h"
#import "LBFinancialCenterMarketinechartcell.h"

@interface LBFinancialCenterMarketinechartController ()<UITableViewDataSource,UITableViewDelegate>


@end

static NSString *financialCenterMarketinechartcell = @"LBFinancialCenterMarketinechartcell";

@implementation LBFinancialCenterMarketinechartController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.tableView registerNib:[UINib nibWithNibName:financialCenterMarketinechartcell bundle:nil] forCellReuseIdentifier:financialCenterMarketinechartcell];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return  UIScreenHeight - (196 + SafeAreaTopHeight + 60 + 50);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LBFinancialCenterMarketinechartcell *cell = [tableView dequeueReusableCellWithIdentifier:financialCenterMarketinechartcell forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
   
    
    return cell;
}


@end
