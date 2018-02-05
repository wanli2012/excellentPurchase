//
//  LBMineOrderDetailpdiscountsTableViewCell.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/1/22.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "LBMineOrderDetailpdiscountsTableViewCell.h"

@implementation LBMineOrderDetailpdiscountsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setModel:(LBMyOrdersDetailModel *)model{
    _model = model;
    if ([_model.coupons floatValue] <= 0) {
        self.discountlb.text = [NSString stringWithFormat:@"¥0"];
    }else{
        self.discountlb.text = [NSString stringWithFormat:@"¥-%@",_model.coupons];
    }
    self.allpricelb.attributedText = [self addoriginstr:[NSString stringWithFormat:@"合计: ¥%.2f",[_model.money floatValue] - [_model.coupons floatValue]] specilstr:@[@"合计: "]];
}

-(NSMutableAttributedString*)addoriginstr:(NSString*)originstr specilstr:(NSArray*)specilstrArr{
    
    NSMutableAttributedString *noteStr = [[NSMutableAttributedString alloc] initWithString:originstr];
    for (int i = 0; i < specilstrArr.count; i++) {
        NSRange rang = [originstr rangeOfString:specilstrArr[i]];
        [noteStr addAttributes:@{NSForegroundColorAttributeName:LBHexadecimalColor(0x333333)} range:rang];
        [noteStr addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} range:rang];
    }
    return noteStr;
}

@end
