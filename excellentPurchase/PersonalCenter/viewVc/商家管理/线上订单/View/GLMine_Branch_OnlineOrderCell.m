//
//  GLMine_Branch_OnlineOrderCell.m
//  excellentPurchase
//
//  Created by 龚磊 on 2018/1/25.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "GLMine_Branch_OnlineOrderCell.h"

@interface GLMine_Branch_OnlineOrderCell()

@property (weak, nonatomic) IBOutlet UIImageView *picImageV;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;

@end

@implementation GLMine_Branch_OnlineOrderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(GLMine_Branch_Order_goodsModel *)model{
    _model = model;
    
    [self.picImageV sd_setImageWithURL:[NSURL URLWithString:model.thumb] placeholderImage:[UIImage imageNamed:PlaceHolder]];
    self.nameLabel.text = model.goods_name;
    self.priceLabel.text = model.ord_goods_price;
    self.numberLabel.text = model.ord_goods_num;
    
}

@end
