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
    
    self.storeNameLabel.text = model.storeName;
    [self.picImageV sd_setImageWithURL:[NSURL URLWithString:model.picName] placeholderImage:[UIImage imageNamed:PlaceHolder]];
    self.accountLabel.text = model.account;
    self.typeLabel.text = model.type;
    self.monthMoneyLabel.text = [NSString stringWithFormat:@"¥ %@",model.month_Money];
    self.totalMoneyLabel.text = [NSString stringWithFormat:@"¥ %@",model.total_Money];
    
}

@end
