//
//  GLMine_Team_AchieveManageCell.m
//  excellentPurchase
//
//  Created by 龚磊 on 2018/1/17.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "GLMine_Team_AchieveManageCell.h"

@interface GLMine_Team_AchieveManageCell ()

@property (weak, nonatomic) IBOutlet UIImageView *picImageV;//图片
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;//名字
@property (weak, nonatomic) IBOutlet UILabel *IDNumberLabel;//ID号

//属性1 celltype = 1 值为:布置绩效 celltype = 2 时 值为:身份
@property (weak, nonatomic) IBOutlet UILabel *attributeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;//属性1的值

//属性2 celltype = 1 值为:已完成 celltype = 2 时 值为:手机号
@property (weak, nonatomic) IBOutlet UILabel *attributeNameLabel2;
@property (weak, nonatomic) IBOutlet UILabel *valueLabel2;//属性2的值


@property (weak, nonatomic) IBOutlet UILabel *groupTypeLabel;//身份类型Label
@property (weak, nonatomic) IBOutlet UIView *typeView;//身份类型View
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;//日期

@end

@implementation GLMine_Team_AchieveManageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setModel:(GLMine_Team_AchieveManageModel *)model{
    _model = model;
   
        self.typeView.hidden = NO;
        self.dateLabel.hidden = YES;
        
        self.attributeNameLabel.text = @"布置绩效";
        self.attributeNameLabel2.text = @"已完成";
        
        self.valueLabel.text = model.setType;
        self.valueLabel2.text = model.done_Achieve;

    
    [self.picImageV sd_setImageWithURL:[NSURL URLWithString:model.picName] placeholderImage:[UIImage imageNamed:PlaceHolder]];
//    self.nameLabel.text = model.name;
    self.IDNumberLabel.text = model.IDNumber;
    
    self.dateLabel.text = model.date;
    self.groupTypeLabel.text = model.group_id;
    
}

- (void)setMemberModel:(GLMine_Team_MemberModel *)memberModel{
    _memberModel = memberModel;
    self.typeView.hidden = YES;
    self.dateLabel.hidden = NO;
    
    self.attributeNameLabel.text = @"身份";
    self.attributeNameLabel2.text = @"手机号";
    
    self.valueLabel.text = memberModel.group_name;
    self.valueLabel2.text = memberModel.phone;
    
    [self.picImageV sd_setImageWithURL:[NSURL URLWithString:memberModel.pic] placeholderImage:[UIImage imageNamed:PlaceHolder]];
//    self.nameLabel.text = memberModel.truename;
    self.IDNumberLabel.text = memberModel.user_name;
    
    self.dateLabel.text = [formattime formateTimeOfDate4:memberModel.regtime];

    
}


@end
