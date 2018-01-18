//
//  GLIdentifySelectCell.m
//  excellentPurchase
//
//  Created by 龚磊 on 2018/1/17.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "GLIdentifySelectCell.h"

@interface GLIdentifySelectCell()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation GLIdentifySelectCell

- (void)awakeFromNib {
    [super awakeFromNib];

}

- (void)setModel:(GLIdentifySelectModel *)model{
    _model = model;
    self.titleLabel.text = model.title;
    if (model.isSelected) {
        self.backgroundColor = YYSRGBColor(245, 245, 245, 1);
    }else{
        self.backgroundColor = [UIColor whiteColor];
    }
}




@end
