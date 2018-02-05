//
//  LBMineOrderDetailproductsTableViewCell.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/1/22.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "LBMineOrderDetailproductsTableViewCell.h"

@interface LBMineOrderDetailproductsTableViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *imagev;
@property (weak, nonatomic) IBOutlet UILabel *namelb;
@property (weak, nonatomic) IBOutlet UILabel *specLb;
@property (weak, nonatomic) IBOutlet UILabel *discountlb;
@property (weak, nonatomic) IBOutlet UILabel *numlb;

@end

@implementation LBMineOrderDetailproductsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setModel:(LBMineSureOrdersGoodInfoModel *)model{
    _model = model;
    [self.imagev sd_setImageWithURL:[NSURL URLWithString:_model.thumb] placeholderImage:nil];
    self.namelb.text = [NSString stringWithFormat:@"%@",_model.goods_name];
    self.specLb.text = [NSString stringWithFormat:@"规格：%@",_model.title];
    self.discountlb.text = [NSString stringWithFormat:@"¥ %@",_model.marketprice];
    self.numlb.text = [NSString stringWithFormat:@"x%@",_model.goods_num];
}

- (void)setGoodsModel:(GLMine_Branch_Order_goodsModel *)goodsModel{
    _goodsModel = goodsModel;
    [self.imagev sd_setImageWithURL:[NSURL URLWithString:goodsModel.thumb] placeholderImage:nil];
    self.namelb.text = [NSString stringWithFormat:@"%@",goodsModel.goods_name];
    self.specLb.text = [NSString stringWithFormat:@"规格：%@",goodsModel.ord_spec_info];
    self.discountlb.text = [NSString stringWithFormat:@"¥ %@",goodsModel.ord_goods_price];
    self.numlb.text = [NSString stringWithFormat:@"x%@",goodsModel.ord_goods_num];
}
@end
