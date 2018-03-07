//
//  LBMerChatFaceToFaceCell.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/2/9.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "LBMerChatFaceToFaceCell.h"
#import "formattime.h"

@implementation LBMerChatFaceToFaceCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code

}

-(void)setModel:(LBMerChatFaceToFacemodel *)model{
    _model = model;
    [self.imagev sd_setImageWithURL:[NSURL URLWithString:_model.pic] placeholderImage:nil];
    if ([NSString StringIsNullOrEmpty:_model.nickname]) {
        self.userLb.attributedText = [self addoriginstr:[NSString stringWithFormat:@"无昵称 (%@)",_model.user_name] specilstr:@[@"无昵称"]];
        
    }else{
        self.userLb.attributedText = [self addoriginstr:[NSString stringWithFormat:@"%@ (%@)",_model.nickname,_model.user_name] specilstr:@[_model.nickname]];
    }
    
    self.timelb.text = [NSString stringWithFormat:@"支付时间: %@",[formattime formateTimeOfDate3:_model.face_addtime]];
    self.ratelb.text = [NSString stringWithFormat:@"奖励金额: %@",_model.face_rl_money];
     self.paylb.text = [NSString stringWithFormat:@"支付金额: %@",_model.face_money];
    switch ([_model.face_paytype integerValue]) {
        case 201:
            self.methodlb.text = [NSString stringWithFormat:@"支付方式:  支付宝支付"];
            break;
        case 202:
            self.methodlb.text = [NSString stringWithFormat:@"支付方式:  微信支付"];
            break;
        case 203:
            self.methodlb.text = [NSString stringWithFormat:@"支付方式:  余额支付"];
            break;
        case 204:
            self.methodlb.text = [NSString stringWithFormat:@"支付方式:  支付宝+购物券"];
            break;
        case 205:
            self.methodlb.text = [NSString stringWithFormat:@"支付方式:  微信+购物券"];
            break;
        case 206:
            self.methodlb.text = [NSString stringWithFormat:@"支付方式:  余额+购物券"];
            break;
            
        default:
            break;
    }
    
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
