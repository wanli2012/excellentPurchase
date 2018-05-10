//
//  LBTaoTaoProductInofoTableViewCell.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/1/15.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "LBTaoTaoProductInofoTableViewCell.h"

@interface LBTaoTaoProductInofoTableViewCell ()

@property (weak, nonatomic) IBOutlet UIView *specilView;
@property (weak, nonatomic) IBOutlet UIView *shareView;
@property (weak, nonatomic) IBOutlet UIView *rateView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rateViewH;


@property (weak, nonatomic) IBOutlet UILabel *namelb;
@property (weak, nonatomic) IBOutlet UILabel *pricelb;
@property (weak, nonatomic) IBOutlet UILabel *expressLb;//快递
@property (weak, nonatomic) IBOutlet UILabel *monthSale;//月售
@property (weak, nonatomic) IBOutlet UILabel *allsale;//已成交
@property (weak, nonatomic) IBOutlet UILabel *ratelb;
@property (weak, nonatomic) IBOutlet UILabel *specification;

@end

@implementation LBTaoTaoProductInofoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    UITapGestureRecognizer *tapgesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(chooseSpecification:)];
    [self.specilView addGestureRecognizer:tapgesture];
    UITapGestureRecognizer *sharetapgesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(shareInfo:)];
    [self.shareView addGestureRecognizer:sharetapgesture];
}

-(void)setModel:(LBTmallProductDetailModel *)model{
    _model = model;
    self.namelb.text = [NSString stringWithFormat:@"%@",_model.goods_name];
    self.pricelb.text = [NSString stringWithFormat:@"¥%@",_model.discount];
    self.expressLb.text = [NSString stringWithFormat:@"快递：¥%@",_model.send_price];
    self.monthSale.text = [NSString stringWithFormat:@"月售%@笔",_model.month_salenum];
    self.allsale.text = [NSString stringWithFormat:@"已成交%@笔",_model.salenum];
    
    if ([_model.bonuspoints floatValue] <= 0 && [_model.reword_coupons floatValue] <= 0 ) {
        self.rateView.hidden = YES;
        self.rateViewH.constant = 0;
    }else{
        self.rateView.hidden = NO;
        self.rateViewH.constant = 50;
        if ([_model.bonuspoints floatValue] > 0 && [_model.reword_coupons floatValue] > 0) {
            self.ratelb.attributedText = [self addoriginstr:[NSString stringWithFormat:@"商品成交后可奖励%@积分，%@购物券",_model.bonuspoints,_model.reword_coupons] specilstr:@[_model.bonuspoints,_model.reword_coupons]];
        }else  if ([_model.bonuspoints floatValue] <= 0 && [_model.reword_coupons floatValue] > 0) {
            self.ratelb.attributedText = [self addoriginstr:[NSString stringWithFormat:@"商品成交后可奖励%@购物券",_model.reword_coupons] specilstr:@[_model.reword_coupons]];
        }else  if ([_model.bonuspoints floatValue] > 0 && [_model.reword_coupons floatValue] <= 0) {
            self.ratelb.attributedText = [self addoriginstr:[NSString stringWithFormat:@"商品成交后可奖励%@积分",_model.bonuspoints] specilstr:@[_model.bonuspoints]];
        }
    }
    
    
}
//选择规格
- (void)chooseSpecification:(UITapGestureRecognizer *)sender {
    [self.delegate chooseSpecification];
}
//分享
- (void)shareInfo:(UITapGestureRecognizer *)sender {
    [self.delegate shareInfo];
}

-(NSMutableAttributedString*)addoriginstr:(NSString*)originstr specilstr:(NSArray*)specilstrArr{
    
    NSMutableAttributedString *noteStr = [[NSMutableAttributedString alloc] initWithString:originstr];
    for (int i = 0; i < specilstrArr.count; i++) {
        NSRange rang = [originstr rangeOfString:specilstrArr[i]];
        [noteStr addAttributes:@{NSForegroundColorAttributeName:MAIN_COLOR} range:rang];
        [noteStr addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} range:rang];
    }
    
    return noteStr;
    
}
@end
