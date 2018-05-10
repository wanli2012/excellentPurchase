//
//  LBHomeOneDolphinDetailHeaderView.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/3/12.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "LBHomeOneDolphinDetailHeaderView.h"
#import "LBDolphinDetailOneHeaderView.h"
#import "LBDolphinDetailThreeHeaderView.h"
#import "CountDown.h"

@interface LBHomeOneDolphinDetailHeaderView()<SDCycleScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *bannerView;
@property (weak, nonatomic) IBOutlet UIButton *picWordBt;
@property (strong, nonatomic)LBDolphinDetailOneHeaderView *dolphinDetailOneHeaderView;
@property (strong, nonatomic)LBDolphinDetailThreeHeaderView *dolphinDetailThreeHeaderView;
@property (nonatomic, strong) CountDown *countDown;

@end

@implementation LBHomeOneDolphinDetailHeaderView

-(void)awakeFromNib{
    [super awakeFromNib];
    [self initInterface];
    
}

-(void)setModel:(LBHomeOneDolphinDetailmodel *)model{
    _model = model;
    //1 正在夺宝(未开奖) 2 开奖中(倒计时) 3 已开奖(结束)
    self.cycleScrollView.imageURLStringsGroup = _model.indiana_goods_thumb;
    if ([_model.indiana_status integerValue] == 1) {
        self.dolphinDetailThreeHeaderView.hidden = NO;
        
        if ([UserModel defaultUser].loginstatus == NO) {
            self.dolphinDetailThreeHeaderView.alertLb.text = @"请登录你的帐号";
        }else{
            if ([_model.start.buy_count integerValue] == 0) {
                 self.dolphinDetailThreeHeaderView.alertLb.text = @"您暂时还没有参与夺宝哦";
                self.dolphinDetailThreeHeaderView.NotJoinView.hidden = NO;
                self.dolphinDetailThreeHeaderView.jionView.hidden = YES;
            }else{
                self.dolphinDetailThreeHeaderView.NotJoinView.hidden = YES;
                self.dolphinDetailThreeHeaderView.jionView.hidden = NO;
            }
        }
        
        
        
    }else  if ([_model.indiana_status integerValue] == 2) {
        self.dolphinDetailOneHeaderView.hidden = NO;
        self.dolphinDetailOneHeaderView.baseview.hidden = YES;
        self.dolphinDetailOneHeaderView.otherView.hidden = NO;
        if ([UserModel defaultUser].loginstatus == NO) {
            self.dolphinDetailOneHeaderView.alertlb.text = @"请登录你的帐号";
            self.dolphinDetailOneHeaderView.jionview.hidden = YES;
        }else{
            if ([_model.start.buy_count integerValue] == 0) {
                self.dolphinDetailOneHeaderView.alertlb.text = @"您暂时还没有参与夺宝哦";
                self.dolphinDetailOneHeaderView.jionview.hidden = YES;
            }else{
               self.dolphinDetailOneHeaderView.jionview.hidden = NO;
            }
        }
        
    }else  if ([_model.indiana_status integerValue] == 3) {
         self.dolphinDetailOneHeaderView.hidden = NO;
        self.dolphinDetailOneHeaderView.baseview.hidden = NO;
        self.dolphinDetailOneHeaderView.otherView.hidden = YES;
        
    }
    
    self.dolphinDetailOneHeaderView.goodname.text = _model.indiana_goods_name;
    [self.dolphinDetailOneHeaderView.rewardimage sd_setImageWithURL:[NSURL URLWithString:_model.finished.pic] placeholderImage:[UIImage imageNamed:PlaceHolder]];
    self.dolphinDetailOneHeaderView.rewadname.text = [NSString stringWithFormat:@"获奖者: %@",_model.finished.reward_nick_name];
    self.dolphinDetailOneHeaderView.rewardid.text = [NSString stringWithFormat:@"(%@)",_model.finished.reward_user_name];
    self.dolphinDetailOneHeaderView.rewardnumbers.text = [NSString stringWithFormat:@"期号: %@",_model.indiana_number];
    self.dolphinDetailOneHeaderView.rewardcount.text = [NSString stringWithFormat:@"本期参与: %@人/次",_model.finished.reward_buy_count];
    self.dolphinDetailOneHeaderView.rewardlucky.text = [NSString stringWithFormat:@"幸运号码: %@",_model.finished.reward_lucky_number];
    self.dolphinDetailOneHeaderView.rewardtine.text = [NSString stringWithFormat:@"揭晓时间: %@", [formattime formateTime:_model.finished.reward_time]];
    self.dolphinDetailOneHeaderView.numbers.text = [NSString stringWithFormat:@"期数: %@",_model.indiana_number];
    self.dolphinDetailOneHeaderView.mycount.text = [NSString stringWithFormat:@"您参与了: %@人/次",_model.wait_reward.buy_count];
    NSString *numbers = [_model.wait_reward.lucky_number componentsJoinedByString:@" "];
    self.dolphinDetailOneHeaderView.mynumbers.text = [NSString stringWithFormat:@"夺宝号码: %@",numbers];
    WeakSelf;
    [self.countDown countDownWithPER_SECBlock:^{
        _model.wait_reward.reward_time = [NSString stringWithFormat:@"%d",[_model.wait_reward.reward_time intValue] - 1];
        [weakSelf timeFormatted:[_model.wait_reward.reward_time intValue]];
    }];
    
    self.dolphinDetailThreeHeaderView.numbers.text = [NSString stringWithFormat:@"期数: %@",_model.indiana_number];
    self.dolphinDetailThreeHeaderView.peoplelb.text = [NSString stringWithFormat:@"总需人数: %@人/次 . 还需: %@人/次",_model.indiana_reward_count,_model.indiana_remainder_count];
    self.dolphinDetailThreeHeaderView.mycount.text = [NSString stringWithFormat:@"您参与了: %@人/次",_model.wait_reward.buy_count];
    NSString *numbers1 = [_model.wait_reward.lucky_number componentsJoinedByString:@" "];
    self.dolphinDetailThreeHeaderView.mynubers.text = [NSString stringWithFormat:@"夺宝号码: %@",numbers1];
     self.dolphinDetailThreeHeaderView.goodname.text = _model.indiana_goods_name;
    CGFloat progress = ([_model.indiana_reward_count intValue] - [_model.indiana_remainder_count intValue]) / [_model.indiana_reward_count floatValue] ;
     self.dolphinDetailThreeHeaderView.progresslb.text = [NSString stringWithFormat:@"夺宝进度: %.0f%%",(progress * 100)];
    self.dolphinDetailThreeHeaderView.zdProgressView.progress = progress;
     self.dolphinDetailThreeHeaderView.zdProgressView.text = [NSString stringWithFormat:@"夺宝进度: %.0f%%",(progress * 100)];
    
}


-(void)initInterface{
    [self.picWordBt setTitle:[NSString stringWithFormat:@"图文\n详情"] forState:UIControlStateNormal];
    self.picWordBt.titleLabel.lineBreakMode = 0;
    [self.bannerView insertSubview:self.cycleScrollView belowSubview:self.picWordBt];

    [self.cycleScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self).offset(0);
        make.leading.equalTo(self).offset(0);
        make.top.equalTo(self).offset(0);
        make.height.equalTo(@(UIScreenWidth));
    }];
    
    [self addSubview:self.dolphinDetailThreeHeaderView];
    [self.dolphinDetailThreeHeaderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self).offset(0);
        make.leading.equalTo(self).offset(0);
        make.top.equalTo(self.cycleScrollView.mas_bottom).offset(0);
        make.height.equalTo(@155);
    }];
    
    [self addSubview:self.dolphinDetailOneHeaderView];
    [self.dolphinDetailOneHeaderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self).offset(0);
        make.leading.equalTo(self).offset(0);
        make.top.equalTo(self.cycleScrollView.mas_bottom).offset(0);
        make.height.equalTo(@155);
    }];
    
     self.dolphinDetailThreeHeaderView.hidden = YES;
     self.dolphinDetailOneHeaderView.hidden = YES;
}

//查看图文混排
- (IBAction)pictureWordEvent:(UIButton *)sender {
    
    [self.delegete checkPictureWord];
    
}

- (void)timeFormatted:(int)totalSeconds
{
    
    int seconds = totalSeconds % 60;
    int minutes = (totalSeconds / 60) % 60;
    int hours = totalSeconds / 3600;
    
    if (hours <= 0 && minutes <=0 && seconds <= 0) {
        [self.dolphinDetailOneHeaderView.hoursbt setTitle:[NSString stringWithFormat:@"00"] forState:UIControlStateNormal];
        [self.dolphinDetailOneHeaderView.minetebt setTitle:[NSString stringWithFormat:@"00"] forState:UIControlStateNormal];
        [self.dolphinDetailOneHeaderView.secondbt setTitle:[NSString stringWithFormat:@"00"] forState:UIControlStateNormal];
        return;
    }
    [self.dolphinDetailOneHeaderView.hoursbt setTitle:[NSString stringWithFormat:@"%02d",hours] forState:UIControlStateNormal];
    [self.dolphinDetailOneHeaderView.minetebt setTitle:[NSString stringWithFormat:@"%02d", minutes] forState:UIControlStateNormal];
    [self.dolphinDetailOneHeaderView.secondbt setTitle:[NSString stringWithFormat:@"%02d",seconds] forState:UIControlStateNormal];
    
    
}
//分享
-(void)shareEvent{
    [self.delegete sharegoodsinfo];
}
//计算
-(void)calculateevent{
    [self.delegete calculateEvent];
}


-(SDCycleScrollView*)cycleScrollView{
    
    if (!_cycleScrollView) {
        _cycleScrollView = [[SDCycleScrollView alloc]init];//当一张都没有的时候的 占位图
        //每一张图的占位图
        _cycleScrollView.delegate = self;
        _cycleScrollView.placeholderImage = [UIImage imageNamed:@"shangpinxiangqing"];
        _cycleScrollView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
        _cycleScrollView.autoScrollTimeInterval = 2;// 自动滚动时间间隔
        _cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;// 翻页 右下角
        _cycleScrollView.titleLabelBackgroundColor = [UIColor groupTableViewBackgroundColor];// 图片对应的标题的 背景色。（因为没有设标题）
        _cycleScrollView.backgroundColor = [UIColor whiteColor];
        _cycleScrollView.pageControlDotSize = CGSizeMake(10, 10);
        _cycleScrollView.localizationImageNamesGroup = @[@" ",@" "];
        _cycleScrollView.showPageControl = NO;
    }
    
    return _cycleScrollView;
    
}

-(LBDolphinDetailOneHeaderView*)dolphinDetailOneHeaderView{
    if (!_dolphinDetailOneHeaderView) {
        _dolphinDetailOneHeaderView = [[NSBundle mainBundle]loadNibNamed:@"LBDolphinDetailOneHeaderView" owner:nil options:nil].firstObject;
        UITapGestureRecognizer *sharegesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(shareEvent)];
        [_dolphinDetailOneHeaderView.shareView addGestureRecognizer:sharegesture];
        
        [_dolphinDetailOneHeaderView.calculateBt addTarget:self action:@selector(calculateevent) forControlEvents:UIControlEventTouchUpInside];
        [_dolphinDetailOneHeaderView.calculateonebt addTarget:self action:@selector(calculateevent) forControlEvents:UIControlEventTouchUpInside];
    }
    return _dolphinDetailOneHeaderView;
}

-(LBDolphinDetailThreeHeaderView*)dolphinDetailThreeHeaderView{
    if (!_dolphinDetailThreeHeaderView) {
        _dolphinDetailThreeHeaderView = [[NSBundle mainBundle]loadNibNamed:@"LBDolphinDetailThreeHeaderView" owner:nil options:nil].firstObject;
        UITapGestureRecognizer *sharegesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(shareEvent)];
        [_dolphinDetailThreeHeaderView.shareview addGestureRecognizer:sharegesture];
        UITapGestureRecognizer *sharegesture1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(shareEvent)];
        [_dolphinDetailThreeHeaderView.shareoneview addGestureRecognizer:sharegesture1];
    }
    return _dolphinDetailThreeHeaderView;
}
-(CountDown*)countDown{
    if (!_countDown) {
        _countDown = [[CountDown alloc]init];
    }
    return _countDown;
}
-(void)dealloc{
    [self.countDown destoryTimer];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    
}
@end
