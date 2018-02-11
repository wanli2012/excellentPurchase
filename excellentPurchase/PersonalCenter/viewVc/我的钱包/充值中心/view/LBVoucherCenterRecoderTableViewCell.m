//
//  LBVoucherCenterRecoderTableViewCell.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/1/11.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "LBVoucherCenterRecoderTableViewCell.h"

@interface LBVoucherCenterRecoderTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *rechargeTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *accountLabel;

@end

@implementation LBVoucherCenterRecoderTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setModel:(GLVoucherRecordModel *)model{
    _model = model;
    
    if([model.type integerValue] == 1){//充值方式 1微信 2支付宝
        self.rechargeTypeLabel.text = @"微信充值";
    }else{
        self.rechargeTypeLabel.text = @"支付宝充值";
    }
    
    self.dateLabel.text = [formattime formateTimeOfDate4:model.addtime];
    self.moneyLabel.text = model.money;
    if (model.cname.length == 0) {
        self.accountLabel.text = [NSString stringWithFormat:@"账号:%@",model.name];
    }else{
        self.accountLabel.text = [NSString stringWithFormat:@"账号:%@",model.cname];
    }
    
}

@end
