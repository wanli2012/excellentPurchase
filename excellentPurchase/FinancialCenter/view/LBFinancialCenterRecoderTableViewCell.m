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

@property (weak, nonatomic) IBOutlet UILabel *nameLabel1;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel2;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel3;


@end

@implementation LBFinancialCenterRecoderTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
   
}

- (void)setModel:(GLFinancialCenterModel *)model{
    _model = model;
    
    if (model.cellType == 2) {
        self.nameLabel1.text = @"出售优购币";
        self.nameLabel2.text = @"当日市值";
        self.nameLabel3.text = @"售出总价";
    }else if(model.cellType == 3) {
        self.nameLabel1.text = @"兑换积分";
        self.nameLabel2.text = @"当日比例";
        self.nameLabel3.text = @"已兑换优购币";
    }
    
    self.sellLabel.text = [NSString stringWithFormat:@"%@",model.sell_num];
    self.valueDay.text = [NSString stringWithFormat:@"¥%@", model.ratio];
    self.dateLabel.text = model.addtime;
    self.statusLabel.text = model.back_status;
    self.totalPriceLabel.text = [NSString stringWithFormat:@"¥%@",model.really_num];
    
}

@end
