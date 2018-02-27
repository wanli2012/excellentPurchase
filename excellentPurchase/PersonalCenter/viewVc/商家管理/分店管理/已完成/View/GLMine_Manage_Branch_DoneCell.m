//
//  GLMine_Manage_Branch_DoneCell.m
//  excellentPurchase
//
//  Created by 龚磊 on 2018/1/24.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "GLMine_Manage_Branch_DoneCell.h"

@interface GLMine_Manage_Branch_DoneCell()

@property (weak, nonatomic) IBOutlet UILabel *storeNameLabel;//店铺名
@property (weak, nonatomic) IBOutlet UIImageView *picImageV;//图片
@property (weak, nonatomic) IBOutlet UILabel *accountLabel;//账号
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;//类型
@property (weak, nonatomic) IBOutlet UILabel *monthMoneyLabel;//当月销售额
@property (weak, nonatomic) IBOutlet UILabel *totalMoneyLabel;//总销售额

@end

@implementation GLMine_Manage_Branch_DoneCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(GLMine_Manage_Branch_DoneModel *)model{
    _model = model;
    
    self.storeNameLabel.text = [NSString stringWithFormat:@"店铺名:%@", model.sname];
    [self.picImageV sd_setImageWithURL:[NSURL URLWithString:model.thumb] placeholderImage:[UIImage imageNamed:PlaceHolder]];
    self.accountLabel.text =[NSString stringWithFormat:@"账号:%@",model.uname];
    self.typeLabel.text = [NSString stringWithFormat:@"类型:%@",model.type];
    self.monthMoneyLabel.text = [NSString stringWithFormat:@"¥ %@",model.fullmoon];
    self.totalMoneyLabel.text = [NSString stringWithFormat:@"¥ %@",model.goodsmoney];
    
}

@end
