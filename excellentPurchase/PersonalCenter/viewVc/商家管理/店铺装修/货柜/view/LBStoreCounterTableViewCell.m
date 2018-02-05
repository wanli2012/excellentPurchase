//
//  LBStoreCounterTableViewCell.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/1/25.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "LBStoreCounterTableViewCell.h"

@interface LBStoreCounterTableViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *picImageV;//图片
@property (weak, nonatomic) IBOutlet UILabel *goodsNameLabel;//商品
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;//价格
@property (weak, nonatomic) IBOutlet UILabel *stockLabel;//库存
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;//状态

@property (weak, nonatomic) IBOutlet UIButton *offShelfBtn;//下架
@property (weak, nonatomic) IBOutlet UIButton *editBtn;//编辑

@end

@implementation LBStoreCounterTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];

    
}
//下架
- (IBAction)soldOutEvent:(UIButton *)sender {
    
    [self.delegete saleOutProduct:self.rowindex];
}
//编辑
- (IBAction)editInfoEvnet:(UIButton *)sender {
    
    [self.delegete EditProduct:self.rowindex];
}

- (void)setModel:(GLStoreCounter_goodsModel *)model{
    _model = model;
    
    [self.picImageV sd_setImageWithURL:[NSURL URLWithString:model.thumb] placeholderImage:[UIImage imageNamed:PlaceHolder]];
    self.goodsNameLabel.text = model.goods_name;
    self.priceLabel.text = [NSString stringWithFormat:@"价格:¥%@",model.discount];
    self.stockLabel.text = [NSString stringWithFormat:@"库存:%@件",model.goods_num];
    
    if([model.status integerValue] == 1){////商品上下架状态 1上架，2下架
        self.statusLabel.text = [NSString stringWithFormat:@"状态:上架中"];
        [self.offShelfBtn setTitle:@"下架" forState:UIControlStateNormal];
        [self.offShelfBtn setTitleColor:MAIN_COLOR forState:UIControlStateNormal];
        self.offShelfBtn.layer.borderColor = MAIN_COLOR.CGColor;
        self.editBtn.hidden = NO;
        self.editBtn.enabled = YES;
        
    }else{
        self.statusLabel.text = [NSString stringWithFormat:@"状态:下架"];
        [self.offShelfBtn setTitle:@"已下架" forState:UIControlStateNormal];
        [self.offShelfBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        self.offShelfBtn.layer.borderColor = [UIColor darkGrayColor].CGColor;
        self.editBtn.hidden = YES;
        self.editBtn.enabled = NO;
    }
}

@end
