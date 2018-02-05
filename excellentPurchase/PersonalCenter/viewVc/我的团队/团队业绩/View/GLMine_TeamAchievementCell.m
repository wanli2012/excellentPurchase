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

- (void)setModel:(GLMine_TeamUnderLing_data_upModel *)model{
    _model = model;
    
    [self.picImageV sd_setImageWithURL:[NSURL URLWithString:model.pic] placeholderImage:[UIImage imageNamed:PlaceHolder]];
    self.nameLabel.text = model.truename;
    self.IDLabel.text = model.user_name;
    self.consumeLabel.text = model.performance;
    self.typeLabel.text = model.group_name;
    
}

//- (void)setUnderModel:(GLMine_TeamUnderLing_data_upModel *)underModel{
//    _underModel = underModel;
//
//    [self.picImageV sd_setImageWithURL:[NSURL URLWithString:underModel.pic] placeholderImage:[UIImage imageNamed:PlaceHolder]];
//    self.nameLabel.text = underModel.truename;
//    self.IDLabel.text = underModel.user_name;
//    self.consumeLabel.text = underModel.performance;
//    self.typeLabel.text = underModel.group_name;
//}

@end
