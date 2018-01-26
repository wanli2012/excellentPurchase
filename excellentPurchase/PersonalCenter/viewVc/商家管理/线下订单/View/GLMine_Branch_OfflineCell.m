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
    
    [self.picImageV sd_setImageWithURL:[NSURL URLWithString:model.pic] placeholderImage:[UIImage imageNamed:PlaceHolder]];
    self.orderNumLabel.text = model.orderNum;
    self.dateLabel.text = model.date;
    self.IDNumberLabel.text = model.IDNum;
    self.consumeLabel.text = [NSString stringWithFormat:@"¥%@",model.consume];
    self.noProfitLabel.text = [NSString stringWithFormat:@"¥%@",model.noPorfit];
    
    if (model.type == 2) {
        self.signImageV.hidden = NO;
    }else{
        self.signImageV.hidden = YES;
    }
}

@end
