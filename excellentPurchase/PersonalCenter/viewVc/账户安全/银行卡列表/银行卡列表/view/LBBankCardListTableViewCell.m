//
//  LBBankCardListTableViewCell.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/1/12.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "LBBankCardListTableViewCell.h"

@interface LBBankCardListTableViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *iconImageV;//银行图标
@property (weak, nonatomic) IBOutlet UILabel *bankNameLabel;//银行名
@property (weak, nonatomic) IBOutlet UILabel *cardNumberLabel;//银行卡号

@end

@implementation LBBankCardListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    
}
- (void)setModel:(GLMine_CardModel *)model{
    _model = model;
    
    self.iconImageV.image = [UIImage imageNamed:@"工商银行图标"];
    self.bankNameLabel.text = model.bank_name;
    self.cardNumberLabel.text = model.banknumber;
}

@end
