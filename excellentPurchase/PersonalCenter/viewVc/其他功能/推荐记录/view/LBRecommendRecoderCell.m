//
//  LBRecommendRecoderCell.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/2/2.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "LBRecommendRecoderCell.h"

@interface LBRecommendRecoderCell()
@property (weak, nonatomic) IBOutlet UIImageView *imagev;
@property (weak, nonatomic) IBOutlet UILabel *trueNme;
@property (weak, nonatomic) IBOutlet UILabel *userId;

@end

@implementation LBRecommendRecoderCell

- (void)awakeFromNib {
    [super awakeFromNib];

}

-(void)setModel:(LBRecommendRecoderModel *)model{
    _model = model;
    
    [self.imagev sd_setImageWithURL:[NSURL URLWithString:_model.pic] placeholderImage:nil];
    self.trueNme.text = [NSString stringWithFormat:@"%@",_model.truename];
    self.userId.text = [NSString stringWithFormat:@"%@",_model.user_name];
}

@end
