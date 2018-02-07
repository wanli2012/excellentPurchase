//
//  LBRecommendRecoderDetailCell.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/2/2.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "LBRecommendRecoderDetailCell.h"
#import "formattime.h"

@implementation LBRecommendRecoderDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setModel:(LBRecommendRecoderListModel *)model{
    _model = model;
    self.timelb.text = [NSString stringWithFormat:@"%@",[formattime formateTime:_model.reg_addtime]];
    self.contentlb.text = [NSString stringWithFormat:@"%@",_model.reg_content];
}

@end
