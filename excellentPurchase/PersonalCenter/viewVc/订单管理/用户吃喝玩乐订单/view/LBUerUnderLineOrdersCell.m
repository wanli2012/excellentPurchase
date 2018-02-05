//
//  LBUerUnderLineOrdersCell.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/2/4.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "LBUerUnderLineOrdersCell.h"

@interface LBUerUnderLineOrdersCell()
@property (weak, nonatomic) IBOutlet UILabel *orderNum;
@property (weak, nonatomic) IBOutlet UILabel *timelb;
@property (weak, nonatomic) IBOutlet UILabel *pricelb;
@property (weak, nonatomic) IBOutlet UILabel *marklb;
@property (weak, nonatomic) IBOutlet UILabel *couponlb;

@end

@implementation LBUerUnderLineOrdersCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setModel:(LBUerUnderLineOrderModel *)model{
    _model = model;
    self.orderNum.text = [NSString stringWithFormat:@"订单号：%@",_model.face_order_num];
    self.pricelb.text = [NSString stringWithFormat:@"¥%@",_model.face_money];
    self.timelb.text = [NSString stringWithFormat:@"%@",[formattime formateTimeOfDate3:_model.face_addtime]];
    self.marklb.text = [NSString stringWithFormat:@"%@",_model.face_back_mark];
    self.couponlb.text = [NSString stringWithFormat:@"¥%@",_model.face_back_coupons];
    
}

@end
