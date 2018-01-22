//
//  GLMine_Message_LogisticsCell.m
//  excellentPurchase
//
//  Created by 龚磊 on 2018/1/20.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "GLMine_Message_LogisticsCell.h"

@interface GLMine_Message_LogisticsCell()

@property (weak, nonatomic) IBOutlet UILabel *statuslabel;//订单状态
@property (weak, nonatomic) IBOutlet UIImageView *picImageV;//图片
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;//日期
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;//订单细节
@property (weak, nonatomic) IBOutlet UILabel *orderNumberLabel;//订单号

@end

@implementation GLMine_Message_LogisticsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(GLMine_Message_LogisticsModel *)model{
    _model = model;
    
    self.statuslabel.text = [NSString stringWithFormat:@"订单%@",model.status];
    [self.picImageV sd_setImageWithURL:[NSURL URLWithString:model.picName] placeholderImage:[UIImage imageNamed:PlaceHolder]];
    self.dateLabel.text = model.date;
    self.orderNumberLabel.text = [NSString stringWithFormat:@"订单号:%@",model.orderNumber];
    
    NSString *str1 = @"您购买的";
    NSInteger length1 = [str1 length];
    
    NSString *nameStr = [NSString stringWithFormat:@"[%@]",model.goodsName];
    NSInteger length2 = [nameStr length];
    
    NSString *str2 = [NSString stringWithFormat:@"%@%@已经到货,欢应您下次光临欢应您下次光临欢应您下次光临", str1, nameStr];
    NSMutableAttributedString *str3 = [[NSMutableAttributedString alloc] initWithString:str2]; //创建一个NSMutableAttributedString
    
    [str3 addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(length1, length2)]; //关键步骤，设置指定位置文字的颜色
    
//    [str3 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:24.0f] range:NSMakeRange(length1, length2)]; //关键步骤，设置指定位置文字的字号大小
    self.detailLabel.attributedText = str3;


}

@end
