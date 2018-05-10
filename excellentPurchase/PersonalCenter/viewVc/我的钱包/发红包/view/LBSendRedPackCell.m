//
//  LBSendRedPackCell.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/4/26.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "LBSendRedPackCell.h"

@interface LBSendRedPackCell()

@property (weak, nonatomic) IBOutlet UILabel *IDNumberLabel;//id号
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;//日期
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;//类型
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;//数额

@end

@implementation LBSendRedPackCell

- (void)awakeFromNib {
    [super awakeFromNib];

    
}

-(void)setModelSend:(LBSendRedPackmodel *)modelSend{
    _modelSend = modelSend;
    self.IDNumberLabel.text = _modelSend.cname;
    if ([_modelSend.addtime integerValue] <= 0) {
        self.dateLabel.text = @"未知时间";
    }else{
        self.dateLabel.text = [formattime formateTime:_modelSend.addtime];
    }
    
    if ([_modelSend.type integerValue] == 1) {
        self.typeLabel.text = @"福宝";
    }else{
        self.typeLabel.text = @"积分";
    }
    
    self.moneyLabel.text = [NSString stringWithFormat:@"-%@",_modelSend.redmoney];
    
}

-(void)setModelRecive:(LBSendRedPackmodel *)modelRecive{
    _modelRecive = modelRecive;
    
    self.IDNumberLabel.text = _modelRecive.cname;
    if ([_modelSend.addtime integerValue] <= 0) {
        self.dateLabel.text = @"未知时间";
    }else{
        self.dateLabel.text = [formattime formateTime:_modelSend.addtime];
    }
    
    if ([_modelRecive.type integerValue] == 1) {
        self.typeLabel.text = @"福宝";
    }else{
        self.typeLabel.text = @"积分";
    }
    
    self.moneyLabel.text = [NSString stringWithFormat:@"+%@",_modelRecive.redmoney];
    
    
}
@end
