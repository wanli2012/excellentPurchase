//
//  LBFinancialCenterExchangeRecodervc.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/1/20.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "LBFinancialCenterExchangeRecodervc.h"
#import "LBFinancialCenterRecoderTableViewCell.h"

static NSString *financialCenterRecoderTableViewCell = @"LBFinancialCenterRecoderTableViewCell";

@implementation LBFinancialCenterExchangeRecodervc

- (void)viewDidLoad {
    [super viewDidLoad];
//    adjustsScrollViewInsets_NO(self.scrollView, self);
     [self.tableView registerNib:[UINib nibWithNibName:financialCenterRecoderTableViewCell bundle:nil] forCellReuseIdentifier:financialCenterRecoderTableViewCell];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LBFinancialCenterRecoderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:financialCenterRecoderTableViewCell forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

@end
