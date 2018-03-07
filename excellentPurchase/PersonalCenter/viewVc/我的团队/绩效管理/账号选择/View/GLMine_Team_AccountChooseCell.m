//
//  GLMine_Team_AccountChooseCell.m
//  excellentPurchase
//
//  Created by 龚磊 on 2018/1/18.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "GLMine_Team_AccountChooseCell.h"

@interface GLMine_Team_AccountChooseCell()

@property (weak, nonatomic) IBOutlet UILabel *accountLabel;
@property (weak, nonatomic) IBOutlet UILabel *IDLabel;
@property (weak, nonatomic) IBOutlet UIImageView *signImageV;

@end

@implementation GLMine_Team_AccountChooseCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(GLMine_Team_AccountChooseModel *)model{
    _model = model;
    
    self.accountLabel.text = model.truename;
    if ([NSString StringIsNullOrEmpty:model.truename]) {
        self.accountLabel.text = model.nickname;
    }
    self.IDLabel.text = model.user_name;
    if (model.isSelected) {
        self.signImageV.image = [UIImage imageNamed:@"MyTeam_Select-y2"];
    }else{
        self.signImageV.image = [UIImage imageNamed:@"MyTeam_select-n2"];
    }
}

@end
