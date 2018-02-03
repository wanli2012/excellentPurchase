//
//  LBStoreCounterMaincell.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/1/25.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "LBStoreCounterMaincell.h"

@interface LBStoreCounterMaincell()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;

@end

@implementation LBStoreCounterMaincell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(GLStoreCounterListModel *)model{
    _model = model;
    
    self.nameLabel.text = model.conname;
    self.countLabel.text = [NSString stringWithFormat:@"共%@件商品",model.point];
    
}
@end
