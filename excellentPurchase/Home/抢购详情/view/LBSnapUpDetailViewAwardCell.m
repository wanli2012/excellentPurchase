//
//  LBSnapUpDetailViewAwardCell.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/3/22.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "LBSnapUpDetailViewAwardCell.h"

@implementation LBSnapUpDetailViewAwardCell

- (void)awakeFromNib {
    [super awakeFromNib];

}

-(void)setModel:(LBTmallProductDetailModel *)model{
    _model = model;
    
        if ([_model.bonuspoints floatValue] > 0 && [_model.reword_coupons floatValue] > 0) {
            self.awardLb.attributedText = [self addoriginstr:[NSString stringWithFormat:@"商品成交后可奖励%@积分，%@购物券",_model.bonuspoints,_model.reword_coupons] specilstr:@[_model.bonuspoints,_model.reword_coupons]];
        }else  if ([_model.bonuspoints floatValue] <= 0 && [_model.reword_coupons floatValue] > 0) {
            self.awardLb.attributedText = [self addoriginstr:[NSString stringWithFormat:@"商品成交后可奖励%@购物券",_model.reword_coupons] specilstr:@[_model.reword_coupons]];
        }else  if ([_model.bonuspoints floatValue] > 0 && [_model.reword_coupons floatValue] <= 0) {
            self.awardLb.attributedText = [self addoriginstr:[NSString stringWithFormat:@"商品成交后可奖励%@积分",_model.bonuspoints] specilstr:@[_model.bonuspoints]];
        }

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
