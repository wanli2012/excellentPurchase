//
//  GLMine_Branch_AchievementCell.m
//  excellentPurchase
//
//  Created by 龚磊 on 2018/1/25.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "GLMine_Branch_AchievementCell.h"

@interface GLMine_Branch_AchievementCell()

@property (weak, nonatomic) IBOutlet UILabel *orderNumLabel;//订单号
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;//日期
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;//价格
@property (weak, nonatomic) IBOutlet UILabel *lastLabel;//备注 或 提单时间 的值
@property (weak, nonatomic) IBOutlet UILabel *lastNameLabel;//备注 或 提单时间
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *priceLabelTop;//价格总价顶部约束
@property (weak, nonatomic) IBOutlet UILabel *rl_priceLabel;//让利金额 值
@property (weak, nonatomic) IBOutlet UILabel *rl_priceNameLabel;//让利金额 名字

@property (weak, nonatomic) IBOutlet UILabel *firstLabel;//第一个label
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;//联系电话
@property (weak, nonatomic) IBOutlet UIView *phoneView;


@end

@implementation GLMine_Branch_AchievementCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(contract)];
    [self.phoneView addGestureRecognizer:tap];
    
}

- (void)contract{
    
    NSMutableString* str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",self.model.phone];

    if (@available(iOS 10.0, *)) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str] options:@{} completionHandler:nil];
    } else {
         [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    }
    

}

- (void)setModel:(GLMine_Branch_AchievementModel *)model{
    _model = model;
    
    if (model.type == 1) {//1:线上业绩  0:线下业绩
        self.firstLabel.text = @"下单时间:";
        self.orderNumLabel.text = model.order_num;
        self.dateLabel.text = [formattime formateTimeOfDate4:model.ord_suretime];
        self.lastNameLabel.text = @"买家备注";
        self.lastLabel.text = model.ord_remark;
        self.priceLabel.text = [NSString stringWithFormat:@"¥%@",model.price];
        
        self.bottomView.hidden = YES;
        self.priceLabelTop.constant = 15;
        self.rl_priceLabel.hidden = YES;
        self.rl_priceNameLabel.hidden = YES;
        
    }else{
        
        self.orderNumLabel.text = model.line_order_num;
        self.firstLabel.text = @"用户ID:";
        self.dateLabel.text = model.user_name;
        self.priceLabel.text = [NSString stringWithFormat:@"¥%@",model.line_money];
        self.lastNameLabel.text = @"下单时间";
        self.lastLabel.text = [formattime formateTimeOfDate4:model.line_addtime];
        
        
        self.rl_priceNameLabel.text = @"奖励金额";
        self.rl_priceLabel.text = [NSString stringWithFormat:@"¥%@",model.line_rl_money];
        
        self.phoneLabel.text = [NSString stringWithFormat:@"联系ta:%@",model.phone];
        
        self.bottomView.hidden = NO;
        self.priceLabelTop.constant = 5;
        self.rl_priceLabel.hidden = NO;
        self.rl_priceNameLabel.hidden = NO;
    }
   
}

@end
