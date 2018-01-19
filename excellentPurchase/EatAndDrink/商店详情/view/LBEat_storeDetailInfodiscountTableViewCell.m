//
//  LBEat_storeDetailInfodiscountTableViewCell.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/1/18.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "LBEat_storeDetailInfodiscountTableViewCell.h"

@interface LBEat_storeDetailInfodiscountTableViewCell()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *discountLb;

@end

@implementation LBEat_storeDetailInfodiscountTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.discountLb.constant = UIScreenWidth - 100;
}


@end
