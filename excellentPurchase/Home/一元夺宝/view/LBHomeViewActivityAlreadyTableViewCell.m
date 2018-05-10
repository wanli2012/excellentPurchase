//
//  LBHomeViewActivityAlreadyTableViewCell.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/3/8.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "LBHomeViewActivityAlreadyTableViewCell.h"

@interface LBHomeViewActivityAlreadyTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *imagev;
@property (weak, nonatomic) IBOutlet UILabel *titlelb;
@property (weak, nonatomic) IBOutlet UILabel *numberlb;
@property (weak, nonatomic) IBOutlet UILabel *peoplelb;
@property (weak, nonatomic) IBOutlet UILabel *rewardlb;
@property (weak, nonatomic) IBOutlet UILabel *luckylb;

@end

@implementation LBHomeViewActivityAlreadyTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setModel:(LBHomeViewActivityListModel *)model{
    _model = model;
    [_imagev sd_setImageWithURL:[NSURL URLWithString:_model.indiana_goods_thumb] placeholderImage:[UIImage imageNamed:PlaceHolder]];
    _titlelb.text = _model.indiana_goods_name;
    _numberlb.text = [NSString stringWithFormat:@"期号:%@",_model.indiana_number];
    _peoplelb.text = [NSString stringWithFormat:@"参与人数:%@",_model.buy_count];
    _rewardlb.text = [NSString stringWithFormat:@"中奖人:%@",_model.nickname];
    _luckylb.text = [NSString stringWithFormat:@"幸运号码:%@",_model.indiana_order_lucky_number];
    
}
@end
