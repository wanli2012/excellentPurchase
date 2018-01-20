//
//  GLMine_Message_PropertyCell.m
//  excellentPurchase
//
//  Created by 龚磊 on 2018/1/20.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "GLMine_Message_PropertyCell.h"

@interface GLMine_Message_PropertyCell()

@property (weak, nonatomic) IBOutlet UILabel *typeLabel;//类型
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;//日期
@property (weak, nonatomic) IBOutlet UILabel *orderLabel;//订单号
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;//数额
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;//细节


@end

@implementation GLMine_Message_PropertyCell

- (void)awakeFromNib {
    [super awakeFromNib];

}

- (void)setModel:(GLMine_Message_PropertyModel *)model{
    _model = model;
    
    self.typeLabel.text = model.changeType;
    self.dateLabel.text = model.date;
    self.orderLabel.text = [NSString stringWithFormat:@"订单号:%@",model.orderNum];
    self.amountLabel.text = [NSString stringWithFormat:@"+%@",model.amount];
    self.detailLabel.text = [NSString stringWithFormat:@"您购买的%@",model.goodsName];
    
}

@end
