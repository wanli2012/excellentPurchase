//
//  LBEat_Activity_TgasTableViewCell.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/1/17.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "LBEat_Activity_TgasTableViewCell.h"

@interface LBEat_Activity_TgasTableViewCell()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labelW;

@end

@implementation LBEat_Activity_TgasTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.labelW.constant = EatCellH + 20;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];


}

@end
