//
//  LBShowProductListCollectionViewCell.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/1/13.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "LBShowProductListCollectionViewCell.h"

@implementation LBShowProductListCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    NSMutableAttributedString *attri =    [[NSMutableAttributedString alloc] initWithString:@"(完善订单信息，兑换礼品 ，请联系农商友现场服务人员,请联系农商友现场服务人员)"];
    NSTextAttachment *attch = [[NSTextAttachment alloc] init];
    
    attch.image = [UIImage imageNamed:@"discountcoupon"];
    
    attch.bounds = CGRectMake(0, -4, 60, 18);
    
    NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:attch];
    
    [attri insertAttributedString:string atIndex:0];
    
    self.productName.attributedText = attri;
}

@end
