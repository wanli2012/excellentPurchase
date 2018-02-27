//
//  GLMine_Manage_Branch_ApplyCell.m
//  excellentPurchase
//
//  Created by 龚磊 on 2018/1/24.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "GLMine_Manage_Branch_ApplyCell.h"

@interface GLMine_Manage_Branch_ApplyCell()

@property (weak, nonatomic) IBOutlet UIImageView *picImageV;//图片
@property (weak, nonatomic) IBOutlet UILabel *storeNameLabel;//商店名
@property (weak, nonatomic) IBOutlet UILabel *accountLabel;//账号
@property (weak, nonatomic) IBOutlet UIButton *handleBtn;//操作按钮

@end

@implementation GLMine_Manage_Branch_ApplyCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(GLMine_Manage_Branch_DoneModel *)model{
    _model = model;
    
    [self.picImageV sd_setImageWithURL:[NSURL URLWithString:model.thumb] placeholderImage:[UIImage imageNamed:PlaceHolder]];
    self.storeNameLabel.text = model.sname;
    self.accountLabel.text = model.uname;
    
    if (model.controllerType == 1) {//1:申请中 0:已冻结
        [self.handleBtn setTitle:@"取消申请" forState:UIControlStateNormal];
    }else{
        [self.handleBtn setTitle:@"解冻账号" forState:UIControlStateNormal];
    }
    
}

///点击事件  解冻账号  取消申请
- (IBAction)handleClick:(id)sender {
    if (self.model.controllerType == 1) {//1:申请中 0:已冻结
        if ([self.delegate respondsToSelector:@selector(cancelApply:)]) {
            [self.delegate cancelApply:self.model.index];
        }
    }else{
        if ([self.delegate respondsToSelector:@selector(unfrezzAccount:)]) {
            [self.delegate unfrezzAccount:self.model.index];
        }
    }
    
}

@end
