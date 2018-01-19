//
//  GLMine_Team_UnderlingAchieveCell.m
//  excellentPurchase
//
//  Created by 龚磊 on 2018/1/19.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "GLMine_Team_UnderlingAchieveCell.h"

@interface GLMine_Team_UnderlingAchieveCell()

@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@end

@implementation GLMine_Team_UnderlingAchieveCell

- (void)awakeFromNib {
    [super awakeFromNib];
  
}

- (void)setModel:(GLMine_Team_UnderlingAchieveModel *)model{
    _model = model;
    
    self.moneyLabel.text = model.money;
    self.dateLabel.text = model.date;
    
}
@end
