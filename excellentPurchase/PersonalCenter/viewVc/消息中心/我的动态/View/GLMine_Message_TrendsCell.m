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
    
    self.dateLabel.text = [formattime formateTimeOfDate4:model.addtime];
    self.contentLabel.text = model.msg;
    
    //1 关注 2商品评论 3商铺评论
    switch ([model.type integerValue]) {
        case 1:
        {
            self.typeLabel.text = @"关注";
        }
            break;
        case 2:
        {
             self.typeLabel.text = @"商品评论";
        }
            break;
        case 3:
        {
             self.typeLabel.text = @"商铺评论";
        }
            break;
            
        default:
            break;
    }
}
- (void)setSystemModel:(GLMine_Message_SystemModel *)systemModel{
    _systemModel = systemModel;
    
    self.dateLabel.text = [formattime formateTimeOfDate4:systemModel.addtime];
    self.contentLabel.text = systemModel.content;
    self.typeLabel.text = systemModel.title;
   
}

@end
