//
//  LBEatProductDetailTableViewCell.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/1/30.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "LBEatProductDetailTableViewCell.h"
#import "XHStarRateView.h"

@interface LBEatProductDetailTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *productName;
@property (weak, nonatomic) IBOutlet UILabel *adressLb;
@property (weak, nonatomic) IBOutlet UILabel *infoLb;
@property (weak, nonatomic) IBOutlet UILabel *priceLb;

@end


@implementation LBEatProductDetailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];

    
    
}
- (IBAction)takeTelephone:(UIButton *)sender {
    
    if ([NSString StringIsNullOrEmpty:_model.store_phone] == NO) {
        NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",_model.store_phone];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
        
    }else{
        [EasyShowTextView showText:@"没有该商家电话"];
    }
    
}

-(void)setModel:(LBEatProductDetailModel *)model{
    _model = model;
    self.priceLb.attributedText = [self addoriginstr:[NSString stringWithFormat:@"¥%@",_model.discount] specilstr:@[_model.discount]];
    self.productName.text = [NSString stringWithFormat:@"%@",_model.goods_name];
    self.infoLb.text = [NSString stringWithFormat:@"%@",_model.goods_info];
    self.adressLb.text = [NSString stringWithFormat:@"%@",_model.store_address];
}

-(NSMutableAttributedString*)addoriginstr:(NSString*)originstr specilstr:(NSArray*)specilstrArr{
    
    NSMutableAttributedString *noteStr = [[NSMutableAttributedString alloc] initWithString:originstr];
    for (int i = 0; i < specilstrArr.count; i++) {
        NSRange rang = [originstr rangeOfString:specilstrArr[i]];
        [noteStr addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} range:rang];
    }
    
    return noteStr;
    
}
@end
