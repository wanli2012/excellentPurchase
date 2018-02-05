//
//  LBMineOrdersFooterReasonViewCell.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/2/5.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "LBMineOrdersFooterReasonViewCell.h"

@implementation LBMineOrdersFooterReasonViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setModel:(LBMineOrderObligationmodel *)model{
    _model = model;
    
    self.describeLb.attributedText = [self addoriginstr:[NSString stringWithFormat:@"共%@件商品，合计：¥%@ (含运费¥%@)",_model.goods_num,_model.order_price,_model.send_price] specilstr:@[_model.order_price]];
    self.reasonlb.text = [NSString stringWithFormat:@"失败原因%@",_model.ord_cancel_reason];
    
}

-(NSMutableAttributedString*)addoriginstr:(NSString*)originstr specilstr:(NSArray*)specilstrArr{
    
    NSMutableAttributedString *noteStr = [[NSMutableAttributedString alloc] initWithString:originstr];
    for (int i = 0; i < specilstrArr.count; i++) {
        NSRange rang = [originstr rangeOfString:specilstrArr[i]];
        [noteStr addAttributes:@{NSForegroundColorAttributeName:MAIN_COLOR} range:rang];
        [noteStr addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20]} range:rang];
    }
    
    return noteStr;
    
}
@end
