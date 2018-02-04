//
//  GLMine_Branch_OfflineCell.m
//  excellentPurchase
//
//  Created by 龚磊 on 2018/1/25.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "GLMine_Branch_OfflineCell.h"

@interface GLMine_Branch_OfflineCell()

@property (weak, nonatomic) IBOutlet UIImageView *picImageV;//图片
@property (weak, nonatomic) IBOutlet UILabel *orderNumLabel;//订单号
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;//日期
@property (weak, nonatomic) IBOutlet UILabel *IDNumberLabel;//ID号
@property (weak, nonatomic) IBOutlet UILabel *consumeLabel;//消费金额
@property (weak, nonatomic) IBOutlet UILabel *noProfitLabel;//让利金额

@property (weak, nonatomic) IBOutlet UIImageView *signImageV;//是否可以点击标志

@end

@implementation GLMine_Branch_OfflineCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(GLMine_Branch_OfflineOrderModel *)model{
    _model = model;
    
    [self.picImageV sd_setImageWithURL:[NSURL URLWithString:model.line_dkpz_pic] placeholderImage:[UIImage imageNamed:PlaceHolder]];
    self.orderNumLabel.text = model.line_order_num;
    self.dateLabel.text = model.time;
    self.IDNumberLabel.text = model.user_name;
    self.consumeLabel.text = [NSString stringWithFormat:@"¥%@",model.line_money];
    self.noProfitLabel.text = [NSString stringWithFormat:@"¥%@",model.line_rl_money];
    
    if (model.type == 0) {////0失败 1成功 2未审核 状态类型
        self.signImageV.hidden = NO;
    }else{
        self.signImageV.hidden = YES;
    }
    
    
}

@end
