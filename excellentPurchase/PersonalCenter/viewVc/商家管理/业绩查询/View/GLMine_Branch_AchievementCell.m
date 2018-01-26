//
//  GLMine_Branch_AchievementCell.m
//  excellentPurchase
//
//  Created by 龚磊 on 2018/1/25.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "GLMine_Branch_AchievementCell.h"

@interface GLMine_Branch_AchievementCell()

@property (weak, nonatomic) IBOutlet UILabel *orderNumLabel;//订单号
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;//日期
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;//价格
@property (weak, nonatomic) IBOutlet UILabel *lastLabel;//备注 或 提单时间 的值
@property (weak, nonatomic) IBOutlet UILabel *lastNameLabel;//备注 或 提单时间

@end

@implementation GLMine_Branch_AchievementCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    
}
- (void)setModel:(GLMine_Branch_AchievementModel *)model{
    _model = model;
    
    self.orderNumLabel.text = model.orderNum;
    self.dateLabel.text = model.date;
    self.priceLabel.text = [NSString stringWithFormat:@"¥%@",model.price];
    
    if (model.type == 1) {//1:线上业绩  0:线下业绩
        self.lastNameLabel.text = @"买家备注";
        self.lastLabel.text = model.submitDate;
    }else{
        self.lastNameLabel.text = @"提单时间";
        self.lastLabel.text = model.remark;
        
    }
}

@end
