//
//  LBAddOrEditProductChoosecell.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/1/25.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "LBAddOrEditProductChoosecell.h"

@interface LBAddOrEditProductChoosecell()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end


@implementation LBAddOrEditProductChoosecell

- (void)awakeFromNib {
    [super awakeFromNib];

}

- (void)setModel:(LBEatTwoClassifyModel *)model{
    _model = model;
    self.titleLabel.text = model.catename;
}


@end
