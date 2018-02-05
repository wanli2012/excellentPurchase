//
//  LBOrdersCompletTableViewCell.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/1/27.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "LBOrdersCompletTableViewCell.h"

@interface LBOrdersCompletTableViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *imagev;
@property (weak, nonatomic) IBOutlet UILabel *goodName;
@property (weak, nonatomic) IBOutlet UILabel *numlb;
@property (weak, nonatomic) IBOutlet UILabel *pricelb;

@end

@implementation LBOrdersCompletTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setModel:(LBMineOrderObligationGoodsmodel *)model{
    _model = model;
    [self.imagev sd_setImageWithURL:[NSURL URLWithString:_model.thumb] placeholderImage:nil];
    self.goodName.text = [NSString stringWithFormat:@"%@",_model.goods_name];
    self.numlb.text = [NSString stringWithFormat:@"x%@",_model.ord_goods_num];
    self.pricelb.text = [NSString stringWithFormat:@"¥%@",_model.ord_goods_price];
    
}

@end
