//
//  LBSnapUpDetailViewTableViewCell.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/3/22.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "LBSnapUpDetailViewTableViewCell.h"
#import "CountDown.h"


@interface LBSnapUpDetailViewTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *salePricelb;
@property (weak, nonatomic) IBOutlet UILabel *oldprice;
@property (weak, nonatomic) IBOutlet UILabel *surplusnum;
@property (weak, nonatomic) IBOutlet UILabel *staustime;
@property (weak, nonatomic) IBOutlet UIButton *hourBt;
@property (weak, nonatomic) IBOutlet UIButton *minuteBt;
@property (weak, nonatomic) IBOutlet UIButton *secondBt;
@property (weak, nonatomic) IBOutlet UILabel *contentlb;
@property (weak, nonatomic) IBOutlet UIView *shareView;
@property (weak, nonatomic) IBOutlet UILabel *expresslb;
@property (weak, nonatomic) IBOutlet UILabel *monthLb;
@property (weak, nonatomic) IBOutlet UILabel *ClinchLb;
@property (strong, nonatomic)  CountDown *countDown;
@property (strong, nonatomic)  NSString *timeSp;

@end

@implementation LBSnapUpDetailViewTableViewCell
-(void)dealloc{
    [self.countDown destoryTimer];
}
- (void)awakeFromNib {
    [super awakeFromNib];
    self.countDown = [[CountDown alloc] init];
    UITapGestureRecognizer *tapgesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapgestureShare)];
    [self.shareView addGestureRecognizer:tapgesture];
}

-(void)tapgestureShare{
    if (self.shareShoInfo) {
        self.shareShoInfo();
    }
}

-(void)setModel:(LBTmallProductDetailModel *)model{
    _model = model;
    if (_model == nil) {
        return;
    }
    self.salePricelb.text = [NSString stringWithFormat:@"¥%@",((LBTmallProductDetailgoodsSpecModel*)_model.goods_spec[0]).costprice];
    self.oldprice.text = [NSString stringWithFormat:@"¥%@",((LBTmallProductDetailgoodsSpecModel*)_model.goods_spec[0]).marketprice];
    self.surplusnum.text = [NSString stringWithFormat:@"仅剩: %@件",_model.active.remain_allow_count];
    self.contentlb.text = [NSString stringWithFormat:@"%@",_model.goods_name];
    self.expresslb.text = [NSString stringWithFormat:@"快递：¥%@",_model.send_price];
    self.monthLb.text = [NSString stringWithFormat:@"月售%@笔",_model.month_salenum];
    self.ClinchLb.text = [NSString stringWithFormat:@"已成交%@笔",_model.salenum];
    
    if ([_model.active.active_status integerValue] == 0 || [_model.active.active_status integerValue] == 3 || [_model.active.active_status integerValue] == 4) {
        self.staustime.text = @"活动结束:";
        [self.hourBt setTitle:@"00" forState:UIControlStateNormal];
        [self.minuteBt setTitle:@"00" forState:UIControlStateNormal];
        [self.secondBt setTitle:@"00" forState:UIControlStateNormal];
        return;
    }
    
    if ([_model.active.active_status integerValue] == 1) {
        self.staustime.text = @"距离结束:";
        self.timeSp = _model.active.active_end_time;
    }else if ([_model.active.active_status integerValue] == 2){
        self.staustime.text = @"距离开始:";
        self.timeSp = _model.active.active_start_time;
    }

    __weak __typeof(self) weakSelf= self;
    [self.countDown countDownWithPER_SECBlock:^{
        weakSelf.timeSp = [NSString stringWithFormat:@"%d",[weakSelf.timeSp intValue] - 1];
        [weakSelf timeFormatted:[weakSelf.timeSp intValue] ];
    }];
    
}

- (void)timeFormatted:(int)totalSeconds
{
    
    int seconds = totalSeconds % 60;
    int minutes = (totalSeconds / 60) % 60;
    int hours = totalSeconds / 3600;
    
    if (hours <= 0 && minutes <=0 && seconds <= 0) {
        [self.hourBt setTitle:@"00" forState:UIControlStateNormal];
        [self.minuteBt setTitle:@"00" forState:UIControlStateNormal];
        [self.secondBt setTitle:@"00" forState:UIControlStateNormal];
        return;
    }
    [self.hourBt setTitle:[NSString stringWithFormat:@"%02d",hours] forState:UIControlStateNormal];
    [self.minuteBt setTitle:[NSString stringWithFormat:@"%02d", minutes] forState:UIControlStateNormal];
    [self.secondBt setTitle:[NSString stringWithFormat:@"%02d",seconds] forState:UIControlStateNormal];
    
}


@end
