//
//  LBDolphinRecoderAlreadyCell.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/3/20.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "LBDolphinRecoderAlreadyCell.h"

@interface LBDolphinRecoderAlreadyCell()

@property (weak, nonatomic) IBOutlet UIImageView *imagv;
@property (weak, nonatomic) IBOutlet UILabel *numberslb;
@property (weak, nonatomic) IBOutlet UILabel *titlelb;
@property (weak, nonatomic) IBOutlet UILabel *allpeoplelb;
@property (weak, nonatomic) IBOutlet UILabel *sypeoplelb;
@property (weak, nonatomic) IBOutlet UILabel *mypeoplelb;
@property (weak, nonatomic) IBOutlet UILabel *rwardPeoplelb;
@property (weak, nonatomic) IBOutlet UILabel *luckyNumbers;
@property (weak, nonatomic) IBOutlet UILabel *peoplejionlb;
@property (weak, nonatomic) IBOutlet UIImageView *rewardimage;


@end

@implementation LBDolphinRecoderAlreadyCell

- (void)awakeFromNib {
    [super awakeFromNib];

}

//查看我的号码
- (IBAction)checkMyNumbers:(UIButton *)sender {
    if (self.jumpMynumbers) {
        self.jumpMynumbers(_model);
    }
}

-(void)setModel:(LBDolphinRecodermodel *)model{
    _model = model;
    [self.imagv sd_setImageWithURL:[NSURL URLWithString:_model.indiana_goods_thumb] placeholderImage:[UIImage imageNamed:PlaceHolder]];
    self.numberslb.text = [NSString stringWithFormat:@"期号: %@",_model.indiana_number];
    self.titlelb.text = _model.indiana_goods_name;
    self.allpeoplelb.text = [NSString stringWithFormat:@"总需: %@人/次",_model.indiana_reward_count];
    self.sypeoplelb.text = [NSString stringWithFormat:@"剩余: %@人/次",_model.sy_count];
    self.mypeoplelb.text = [NSString stringWithFormat:@"我参与: %@人/次",_model.u_count];
    self.rwardPeoplelb.text = [NSString stringWithFormat:@"获奖者: %@",_model.user_name];
    self.luckyNumbers.text = [NSString stringWithFormat:@"幸运号码: %@",_model.lucky_number];
    self.peoplejionlb.text = [NSString stringWithFormat:@"本次参与: %d",[_model.indiana_reward_count intValue] -  [_model.sy_count intValue] ];
    
    if ([_model.indiana_status integerValue] == 3) {
        self.rewardimage.hidden = NO;
        if ([_model.indiana_uid isEqualToString:[UserModel defaultUser].uid]) {//中奖
            self.rewardimage.image = [UIImage imageNamed:@"夺宝中奖"];
        }else{
            self.rewardimage.image = [UIImage imageNamed:@"夺宝未中奖"];
        }
    }else{
        self.rewardimage.hidden = YES;
    }
}

@end
