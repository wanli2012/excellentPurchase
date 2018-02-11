//
//  GLMine_Team_StaffingCell.m
//  excellentPurchase
//
//  Created by 龚磊 on 2018/2/1.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "GLMine_Team_StaffingCell.h"
#import "ReactiveCocoa.h"

@interface GLMine_Team_StaffingCell()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;//名字
@property (weak, nonatomic) IBOutlet UILabel *signLabel;//剩余人数
@property (weak, nonatomic) IBOutlet UITextField *numberTF;//人数

@end

@implementation GLMine_Team_StaffingCell

- (void)awakeFromNib {
    [super awakeFromNib];
 
    WeakSelf;
    [[self.numberTF rac_textSignal]subscribeNext:^(NSString * x) {
        weakSelf.model.personNum = [x integerValue];
    }];
    
}

- (void)setModel:(GLMine_Team_OpenSet_subModel *)model{
    _model = model;
    
    self.titleLabel.text = model.name;
    self.signLabel.text = model.msg;
    
    if (model.personNum != 0) {
        self.numberTF.text = [NSString stringWithFormat:@"%zd",model.personNum];
    }
    
}

@end
