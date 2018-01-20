//
//  GLMine_Message_TrendsCell.m
//  excellentPurchase
//
//  Created by 龚磊 on 2018/1/20.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "GLMine_Message_TrendsCell.h"

@interface GLMine_Message_TrendsCell()

@property (weak, nonatomic) IBOutlet UILabel *typeLabel;//类型
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;//日期
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;//内容

@end

@implementation GLMine_Message_TrendsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setModel:(GLMine_Message_TrendsModel *)model{
    _model = model;
    self.typeLabel.text = model.typeName;
    self.dateLabel.text = model.date;
    self.contentLabel.text = model.content;
}
@end
