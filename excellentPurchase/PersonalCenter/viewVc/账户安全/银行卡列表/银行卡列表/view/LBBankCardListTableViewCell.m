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
@property (weak, nonatomic) IBOutlet UIImageView *bgImageV;//背景

@end

@implementation LBBankCardListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    
}
- (void)setModel:(GLMine_CardModel *)model{
    _model = model;
    
    self.bankNameLabel.text = model.bank_name;
    self.cardNumberLabel.text = model.banknumber;
//    self.iconImageV.image = [UIImage imageNamed:@"工商银行图标"];e
    
    //银行标识 1 中国农业银行 2 中国工商银行 3 中国建设银行 4 中国邮政银行 5 中国人民银行 6 中国民生银行 7 中国招商银行 8 中国银行 9 平安银行 10 交通银行 11 中信银行 12 兴业银行
    
    switch ([model.bank_icon integerValue]) {
        case 1:
        {
            self.iconImageV.image = [UIImage imageNamed:@"中国农业银行"];
            self.bgImageV.image = [UIImage imageNamed:@"中国农业银行_bg"];
        }
            break;
        case 2:
        {
            self.iconImageV.image = [UIImage imageNamed:@"中国工商银行"];
            self.bgImageV.image = [UIImage imageNamed:@"中国工商银行_bg"];
        }
            break;
        case 3:
        {
            self.iconImageV.image = [UIImage imageNamed:@"中国建设银行"];
            self.bgImageV.image = [UIImage imageNamed:@"中国建设银行_bg"];
        }
            break;
        case 4:
        {
            self.iconImageV.image = [UIImage imageNamed:@"中国邮政银行"];
            self.bgImageV.image = [UIImage imageNamed:@"中国邮政银行_bg"];
        }
            break;
        case 8:
        {
            self.iconImageV.image = [UIImage imageNamed:@"中国银行"];
            self.bgImageV.image = [UIImage imageNamed:@"中国银行_bg"];
        }
            break;
            
        default:
        {
            self.iconImageV.image = [UIImage imageNamed:@"其他银行"];
            self.bgImageV.image = [UIImage imageNamed:@"其他银行_bg"];
        }
            break;
    }
}

@end
