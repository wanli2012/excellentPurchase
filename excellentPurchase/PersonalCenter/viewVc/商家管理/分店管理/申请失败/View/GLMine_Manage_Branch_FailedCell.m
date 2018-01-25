//
//  GLMine_Manage_Branch_FailedCell.m
//  excellentPurchase
//
//  Created by 龚磊 on 2018/1/24.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "GLMine_Manage_Branch_FailedCell.h"

@interface GLMine_Manage_Branch_FailedCell ()

@property (weak, nonatomic) IBOutlet UIImageView *picImageV;//图片
@property (weak, nonatomic) IBOutlet UILabel *storeNameLabel;//商店名
@property (weak, nonatomic) IBOutlet UILabel *accountLabel;//账号
@property (weak, nonatomic) IBOutlet UILabel *reasonLabel;//失败原因

@end

@implementation GLMine_Manage_Branch_FailedCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(GLMine_Manage_Branch_DoneModel *)model{
    _model = model;
    
    [self.picImageV sd_setImageWithURL:[NSURL URLWithString:model.picName] placeholderImage:[UIImage imageNamed:PlaceHolder]];
    self.storeNameLabel.text = model.storeName;
    self.accountLabel.text = model.account;
    self.reasonLabel.text = model.reason;
    
}

///重新申请
- (IBAction)applyAgain:(id)sender {
    if ([self.delegate respondsToSelector:@selector(applyAgain:)]) {
        [self.delegate applyAgain:self.model.index];
    }
}

@end
