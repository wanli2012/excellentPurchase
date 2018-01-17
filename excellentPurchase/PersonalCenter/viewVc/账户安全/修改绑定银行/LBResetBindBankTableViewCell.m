//
//  LBResetBindBankTableViewCell.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/1/12.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "LBResetBindBankTableViewCell.h"

@implementation LBResetBindBankTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];

}
- (IBAction)relieveBankCardEvent:(UIButton *)sender {
    [self.delegate relieveBindBankCard:self.indexpath];
}


@end
