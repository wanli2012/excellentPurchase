//
//  LBStoreCounterTableViewCell.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/1/25.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "LBStoreCounterTableViewCell.h"

@implementation LBStoreCounterTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];

    
}
//下架
- (IBAction)soldOutEvent:(UIButton *)sender {
    
    [self.delegete saleOutProduct:self.rowindex];
}
//编辑
- (IBAction)editInfoEvnet:(UIButton *)sender {
    
    [self.delegete EditProduct:self.rowindex];
}


@end
