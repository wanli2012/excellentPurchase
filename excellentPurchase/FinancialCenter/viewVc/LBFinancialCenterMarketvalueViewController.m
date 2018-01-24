//
//  LBFinancialCenterMarketvalueViewController.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/1/20.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "LBFinancialCenterMarketvalueViewController.h"
#import "LBFinancialCenterTableViewCell.h"

@interface LBFinancialCenterMarketvalueViewController ()

@end

static NSString *donationTableViewCell = @"LBFinancialCenterTableViewCell";

@implementation LBFinancialCenterMarketvalueViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    adjustsScrollViewInsets_NO(self.scrollView, self);
    //注册cell
    [self.tableView registerNib:[UINib nibWithNibName:donationTableViewCell bundle:nil] forCellReuseIdentifier:donationTableViewCell];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 12;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LBFinancialCenterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:donationTableViewCell forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

@end
