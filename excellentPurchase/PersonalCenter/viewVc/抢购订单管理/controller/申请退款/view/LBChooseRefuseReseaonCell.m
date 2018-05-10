//
//  LBChooseRefuseReseaonCell.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/4/23.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "LBChooseRefuseReseaonCell.h"

@interface LBChooseRefuseReseaonCell()
@property (weak, nonatomic) IBOutlet UILabel *titilelb;
@property (weak, nonatomic) IBOutlet UIButton *selectbt;

@end

@implementation LBChooseRefuseReseaonCell

- (void)awakeFromNib {
    [super awakeFromNib];

    
}

-(void)setModel:(LBChooseRefuseReseaonModel *)model{
    _model = model;
    
    self.titilelb.text = _model.content;
    self.selectbt.selected = _model.isselect;
    
}

@end
