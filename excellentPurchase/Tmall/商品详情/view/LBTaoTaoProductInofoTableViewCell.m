//
//  LBTaoTaoProductInofoTableViewCell.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/1/15.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "LBTaoTaoProductInofoTableViewCell.h"

@interface LBTaoTaoProductInofoTableViewCell ()

@property (weak, nonatomic) IBOutlet UIView *specilView;

@end

@implementation LBTaoTaoProductInofoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    UITapGestureRecognizer *tapgesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(chooseSpecification:)];
    [self.specilView addGestureRecognizer:tapgesture];
}
//选择规格
- (IBAction)chooseSpecification:(UITapGestureRecognizer *)sender {
    [self.delegate chooseSpecification];
}

@end
