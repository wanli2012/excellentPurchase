//
//  GLMine_Message_InteractCell.m
//  excellentPurchase
//
//  Created by 龚磊 on 2018/1/20.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "GLMine_Message_InteractCell.h"

@interface GLMine_Message_InteractCell()

@property (weak, nonatomic) IBOutlet UIImageView *picImageV;//头像
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;//名字
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;//内容
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;//日期

@end

@implementation GLMine_Message_InteractCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(GLMine_Message_InteractModel *)model{
    _model = model;
    [self.picImageV sd_setImageWithURL:[NSURL URLWithString:model.picName] placeholderImage:[UIImage imageNamed:PlaceHolder]];
    self.nameLabel.text = model.name;
    self.contentLabel.text = model.content;
    self.dateLabel.text = model.date;
}
@end
