//
//  LBHomeViewActivityCollectionViewCell.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/3/8.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "LBHomeViewActivityCollectionViewCell.h"

@interface LBHomeViewActivityCollectionViewCell()

@property (weak, nonatomic) IBOutlet UIButton *hourBt;
@property (weak, nonatomic) IBOutlet UIButton *minuteBt;
@property (weak, nonatomic) IBOutlet UIButton *secondBt;
@property (weak, nonatomic) IBOutlet UIView *timeview;
@property (weak, nonatomic) IBOutlet UIImageView *imagev;
@property (weak, nonatomic) IBOutlet UILabel *titlielb;
@property (weak, nonatomic) IBOutlet UILabel *infolb;

@end

@implementation LBHomeViewActivityCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];

     [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(countDownoneDolphin) name:@"countDownoneDolphin" object:nil];
}

-(void)countDownoneDolphin{
    _model.time = [NSString stringWithFormat:@"%d",[_model.time intValue] - 1];
     [self timeFormatted:[_model.time intValue]];
}

-(void)setModel:(LBHomeViewActivityHistoryModel *)model{
    _model = model;
    [_imagev sd_setImageWithURL:[NSURL URLWithString:_model.indiana_goods_thumb] placeholderImage:[UIImage imageNamed:PlaceHolder]];
    
    if ([_model.indiana_status integerValue]==2) {//2 为等待开奖 3为已经开奖
        self.timeview.hidden = NO;
        self.infolb.hidden = YES;
        _titlielb.text = @"等待开奖";
        _titlielb.textColor = LBHexadecimalColor(0x5c03ff);
        [self timeFormatted:[_model.time intValue]];
    }else if ([_model.indiana_status integerValue]==3){
        self.timeview.hidden = YES;
        self.infolb.hidden = NO;
        self.infolb.text = [NSString stringWithFormat:@"幸运号码: %@",_model.indiana_order_lucky_number];
        _titlielb.text = _model.reward_info;
        _titlielb.textColor = MAIN_COLOR;
    }
    
}

- (void)timeFormatted:(int)totalSeconds
{
    
    int seconds = totalSeconds % 60;
    int minutes = (totalSeconds / 60) % 60;
    int hours = totalSeconds / 3600;
    
        if (hours <= 0 && minutes <=0 && seconds <= 0) {
            [self.hourBt setTitle:[NSString stringWithFormat:@"00"] forState:UIControlStateNormal];
            [self.minuteBt setTitle:[NSString stringWithFormat:@"00"] forState:UIControlStateNormal];
            [self.secondBt setTitle:[NSString stringWithFormat:@"00"] forState:UIControlStateNormal];
            return;
        }
        [self.hourBt setTitle:[NSString stringWithFormat:@"%02d",hours] forState:UIControlStateNormal];
        [self.minuteBt setTitle:[NSString stringWithFormat:@"%02d", minutes] forState:UIControlStateNormal];
        [self.secondBt setTitle:[NSString stringWithFormat:@"%02d",seconds] forState:UIControlStateNormal];
}

@end
