//
//  GLMine_TeamAchievementCell.m
//  excellentPurchase
//
//  Created by 龚磊 on 2018/1/17.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "GLMine_TeamAchievementCell.h"

@interface GLMine_TeamAchievementCell()

@property (weak, nonatomic) IBOutlet UIImageView *picImageV;//头像
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;//姓名
@property (weak, nonatomic) IBOutlet UILabel *IDLabel;//ID
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;//身份类型
@property (weak, nonatomic) IBOutlet UILabel *consumeLabel;//消费总额

@end

@implementation GLMine_TeamAchievementCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setModel:(GLMine_TeamAchievementModel *)model{
    _model = model;
    
    [self.picImageV sd_setImageWithURL:[NSURL URLWithString:model.picName] placeholderImage:[UIImage imageNamed:PlaceHolder]];
    self.nameLabel.text = model.name;
    self.IDLabel.text = model.ID;
    self.consumeLabel.text = model.consume;
    
    switch ([model.type integerValue]) {
        case 0:
        {
            self.typeLabel.text = @"创客";
        }
            break;
        case 1:
        {
            self.typeLabel.text = @"高级创客";
        }
            break;
        case 2:
        {
            self.typeLabel.text = @"会员";
        }
            break;
            
        default:
            break;
    }
    
}
@end
