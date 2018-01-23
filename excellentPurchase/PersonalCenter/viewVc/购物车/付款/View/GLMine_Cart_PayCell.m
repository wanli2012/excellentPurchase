//
//  GLMine_Cart_PayCell.m
//  excellentPurchase
//
//  Created by 龚磊 on 2018/1/23.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "GLMine_Cart_PayCell.h"

@interface GLMine_Cart_PayCell ()

@property (weak, nonatomic) IBOutlet UIImageView *picImageV;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UIImageView *signImageV;

@end

@implementation GLMine_Cart_PayCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setModel:(GLMine_Cart_PayModel *)model{
    _model = model;
    
    self.picImageV.image = [UIImage imageNamed:model.picName];
    self.titleLabel.text = model.title;
    self.detailLabel.text = model.detail;
    
    if (model.isSelected) {
        self.signImageV.image = [UIImage imageNamed:@"pay-select-y"];
    }else{
        self.signImageV.image = [UIImage imageNamed:@"pay-select-n"];
    }
}

@end
