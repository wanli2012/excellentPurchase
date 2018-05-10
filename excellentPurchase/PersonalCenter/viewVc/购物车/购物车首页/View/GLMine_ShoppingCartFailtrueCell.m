//
//  GLMine_ShoppingCartFailtrueCell.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/3/26.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "GLMine_ShoppingCartFailtrueCell.h"

@interface GLMine_ShoppingCartFailtrueCell()
@property (weak, nonatomic) IBOutlet UIImageView *imagev;
@property (weak, nonatomic) IBOutlet UILabel *namelb;
@property (weak, nonatomic) IBOutlet UILabel *propertylb;
@property (weak, nonatomic) IBOutlet UILabel *pricelb;
@property (weak, nonatomic) IBOutlet UILabel *statusLb;

@end

@implementation GLMine_ShoppingCartFailtrueCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(GLMine_ShoppingPropertyCartModel *)model{
    _model = model;
    [self.imagev sd_setImageWithURL:[NSURL URLWithString:model.thumb] placeholderImage:[UIImage imageNamed:PlaceHolder]];
    self.namelb.text = _model.goods_name;
    self.propertylb.text = [NSString stringWithFormat:@"规格:%@",_model.title];
    self.pricelb.text = [NSString stringWithFormat:@"¥:%@",_model.marketprice];
    
    if ([_model.stock integerValue] == 0) {
        self.statusLb.text = @"库存不足";
    }
    
    if ([_model.status integerValue] == 2) {
        self.statusLb.text = @"商品下架";
    }
    
}
@end
