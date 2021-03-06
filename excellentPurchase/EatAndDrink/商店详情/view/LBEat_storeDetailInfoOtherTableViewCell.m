//
//  LBEat_storeDetailInfoOtherTableViewCell.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/1/18.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "LBEat_storeDetailInfoOtherTableViewCell.h"

@interface LBEat_storeDetailInfoOtherTableViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *imagev;
@property (weak, nonatomic) IBOutlet UILabel *storeName;
@property (weak, nonatomic) IBOutlet UILabel *storeInfo;
@property (weak, nonatomic) IBOutlet UILabel *priceLb;
@property (weak, nonatomic) IBOutlet UILabel *oldPrice;

@property (weak, nonatomic) IBOutlet UIView *linev;

@end

@implementation LBEat_storeDetailInfoOtherTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
  
}

-(void)setModel:(LBEat_StoreDetailOtherDataModel *)model{
    _model = model;
    [self.imagev sd_setImageWithURL:[NSURL URLWithString:_model.thumb] placeholderImage:nil];
    self.storeName.text = [NSString stringWithFormat:@"%@",_model.goods_name];
    self.storeInfo.text = [NSString stringWithFormat:@"%@",_model.goods_info];
    self.priceLb.text = [NSString stringWithFormat:@"¥%@",_model.discount];
    self.linev.hidden = YES;
}

-(void)setPmodel:(LBEatProductDetailOtherModel *)pmodel{
    _pmodel = pmodel;
    self.oldPrice.hidden = NO;
    self.storeName.text = [NSString stringWithFormat:@"%@",_pmodel.goods_name];
    self.storeInfo.text = [NSString stringWithFormat:@"%@",_pmodel.goods_info];
    self.priceLb.text = [NSString stringWithFormat:@"¥%@",_pmodel.discount];
    self.oldPrice.text = [NSString stringWithFormat:@"¥%@",_pmodel.goods_price];
    [self.imagev sd_setImageWithURL:[NSURL URLWithString:_pmodel.thumb] placeholderImage:nil];
}

@end
