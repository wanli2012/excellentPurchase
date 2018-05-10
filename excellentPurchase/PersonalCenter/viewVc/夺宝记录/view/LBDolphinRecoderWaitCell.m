//
//  LBDolphinRecoderWaitCell.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/3/20.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "LBDolphinRecoderWaitCell.h"

@interface LBDolphinRecoderWaitCell()

@property (weak, nonatomic) IBOutlet UIImageView *imagv;
@property (weak, nonatomic) IBOutlet UILabel *numberslb;
@property (weak, nonatomic) IBOutlet UILabel *titlelb;
@property (weak, nonatomic) IBOutlet UILabel *allpeoplelb;
@property (weak, nonatomic) IBOutlet UILabel *mypeoplelb;

@end

@implementation LBDolphinRecoderWaitCell

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
    self.mypeoplelb.text = [NSString stringWithFormat:@"我参与: %@人/次",_model.u_count];
    
}
@end
