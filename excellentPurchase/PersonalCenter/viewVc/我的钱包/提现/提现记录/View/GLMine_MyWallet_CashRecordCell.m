//
//  GLMine_MyWallet_CashRecordCell.m
//  excellentPurchase
//
//  Created by 龚磊 on 2018/1/26.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "GLMine_MyWallet_CashRecordCell.h"

@interface GLMine_MyWallet_CashRecordCell()

@property (weak, nonatomic) IBOutlet UILabel *bankNameLabel;//提现银行名
@property (weak, nonatomic) IBOutlet UILabel *cardNumberLabel;//卡号
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;//日期
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;//数额
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;//状态

@end

@implementation GLMine_MyWallet_CashRecordCell

- (void)awakeFromNib {
    [super awakeFromNib];
   
}

- (void)setModel:(GLMine_MyWallet_CashRecordModel *)model{
    _model = model;
    
    self.bankNameLabel.text = [NSString stringWithFormat:@"提现:%@",model.bank_name];
    self.cardNumberLabel.text = model.banknumber;
    self.dateLabel.text = [formattime formateTimeOfDate4:model.addtime];
    self.moneyLabel.text = model.money;
    
    switch ([model.type integerValue]) {//提现状态 1提现中 2提现失败 3提现成功
        case 1:
        {
            self.statusLabel.text = @"(提现中)";
            self.statusLabel.textColor = YYSRGBColor(51, 148, 51, 1);
        }
            break;
        case 2:
        {
            self.statusLabel.text = @"(失败:查看原因)";
            self.statusLabel.textColor = [UIColor redColor];
        }
            break;
        case 3:
        {
            self.statusLabel.text = @"(提现成功)";
            self.statusLabel.textColor = YYSRGBColor(51, 148, 51, 1);
        }
            break;
            
        default:
            break;
    }
}


@end
