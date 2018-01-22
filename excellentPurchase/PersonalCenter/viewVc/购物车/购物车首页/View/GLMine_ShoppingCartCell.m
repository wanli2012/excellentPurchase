//
//  GLMine_ShoppingCartCell.m
//  excellentPurchase
//
//  Created by 龚磊 on 2018/1/22.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "GLMine_ShoppingCartCell.h"

@interface GLMine_ShoppingCartCell()

@property (weak, nonatomic) IBOutlet UIView *selectView;//选中点击范围view
@property (weak, nonatomic) IBOutlet UIImageView *selectedImageV;//是否选中标
@property (weak, nonatomic) IBOutlet UIImageView *picImageV;//商品数量
@property (weak, nonatomic) IBOutlet UILabel *goodsNameLabel;//商品名
@property (weak, nonatomic) IBOutlet UILabel *specLabel;//规格
@property (weak, nonatomic) IBOutlet UILabel *rebateLabel;//返的积分 和 购物券
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;//价格
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;//购买数量
@property (weak, nonatomic) IBOutlet UITextField *amountTF;//编辑数量
@property (weak, nonatomic) IBOutlet UIView *numberChangeView;//数量加减

@end

@implementation GLMine_ShoppingCartCell

- (void)awakeFromNib {
    [super awakeFromNib];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectClick)];
    [self.selectView addGestureRecognizer:tap];
}

//选中  取消
- (void)selectClick{
    if ([self.delegate respondsToSelector:@selector(changeStatus:)]) {
        [self.delegate changeStatus:self.index];
    }
}

- (void)setModel:(GLMine_ShoppingCartModel *)model{
    _model = model;
    
    if(model.isSelected){
        self.selectedImageV.image = [UIImage imageNamed:@"pay-select-y"];
    }else{
        self.selectedImageV.image = [UIImage imageNamed:@"pay-select-n"];
    }
    
    [self.picImageV sd_setImageWithURL:[NSURL URLWithString:model.pic] placeholderImage:[UIImage imageNamed:PlaceHolder]];
    self.goodsNameLabel.text = model.goodsName;
    self.specLabel.text = [NSString stringWithFormat:@"规格:%@",model.spec];
    self.priceLabel.text = [NSString stringWithFormat:@"¥ %@",model.price];
    self.rebateLabel.text = [NSString stringWithFormat:@"%@积分; %@购物券",model.jifen,model.coupon];
    
    self.amountTF.text = model.amount;
    
    if (model.isDone) {
        self.priceLabel.hidden = NO;
        self.amountLabel.hidden = NO;
        self.numberChangeView.hidden = YES;
    }else{
        self.priceLabel.hidden = YES;
        self.amountLabel.hidden = YES;
        self.numberChangeView.hidden = NO;
    }
    
}
@end
