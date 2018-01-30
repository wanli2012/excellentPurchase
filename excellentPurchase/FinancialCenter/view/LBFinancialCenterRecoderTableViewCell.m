//
//  LBFinancialCenterRecoderTableViewCell.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/1/24.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "LBFinancialCenterRecoderTableViewCell.h"

@interface LBFinancialCenterRecoderTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *sellLabel;//出售优购币
@property (weak, nonatomic) IBOutlet UILabel *valueDay;//当日市值
@property (weak, nonatomic) IBOutlet UILabel *totalPriceLabel;//售出总价
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;//状态
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;//日期

@end

@implementation LBFinancialCenterRecoderTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
   
}

- (void)setModel:(GLFinancialCenterModel *)model{
    _model = model;
    
    self.sellLabel.text = [NSString stringWithFormat:@"%@",model.sell_num];
    self.valueDay.text = [NSString stringWithFormat:@"¥%@", model.ratio];
    self.dateLabel.text = model.addtime;
    self.statusLabel.text = model.back_status;
    self.totalPriceLabel.text = [NSString stringWithFormat:@"¥%@",model.really_num];
    
}
@end
