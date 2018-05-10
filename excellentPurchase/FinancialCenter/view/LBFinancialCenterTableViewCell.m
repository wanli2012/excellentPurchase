//
//  LBFinancialCenterTableViewCell.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/1/20.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "LBFinancialCenterTableViewCell.h"

@interface LBFinancialCenterTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;//时间
@property (weak, nonatomic) IBOutlet UILabel *radioLabel;//福宝市值
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;//进度条

@end

@implementation LBFinancialCenterTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setModel:(GLFinancialCenterModel *)model{
    _model = model;
    
    self.dateLabel.text = model.addtime;
    self.radioLabel.text = model.ratio;
    
    CGFloat radio;
    if ([model.ratio_max floatValue] == 0.0) {
        radio = 0;
    }else{
        radio = [model.ratio floatValue]/[model.ratio_max floatValue];
    }
    
    self.progressView.progress = radio;
    
}

@end
