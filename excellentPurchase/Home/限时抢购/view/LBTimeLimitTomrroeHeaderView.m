//
//  LBTimeLimitTomrroeHeaderView.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/4/13.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "LBTimeLimitTomrroeHeaderView.h"
#import "LBTimeLimitView.h"

@interface LBTimeLimitTomrroeHeaderView()

@property (strong , nonatomic)LBTimeLimitView *timeLimitView;

@property(nonatomic,strong)NSString *time;
@property(nonatomic,strong)NSString *buyingsecond;

@property(nonatomic,strong)NSString *timeone;
@property(nonatomic,strong)NSString *buyingsecondone;

@property(nonatomic,strong)NSString *timetwo;
@property(nonatomic,strong)NSString *buyingsecondtwo;

@property(nonatomic,assign)NSInteger section;

@end

@implementation LBTimeLimitTomrroeHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithReuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.contentView.backgroundColor=[UIColor whiteColor];
        [self initsubsview];//_init表示初始化方法
    }
    
    return self;
}

-(void)initsubsview{
    
    LBTimeLimitView *view = [[NSBundle mainBundle]loadNibNamed:@"LBTimeLimitHeaderView" owner:nil options:nil].firstObject;
    view.autoresizingMask = UIViewAutoresizingNone;
    [self addSubview:view];
    
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.trailing.equalTo(self).offset(0);
        make.leading.equalTo(self).offset(0);
        make.top.equalTo(self).offset(0);
        make.bottom.equalTo(self).offset(0);
    }];
    
    self.timeLimitView = view;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationCenterEvent:)
                                                 name:TimeCellNotificationone
                                               object:nil];
    
}

- (void)notificationCenterEvent:(NSNotification*)noti{
    
    
    if (self.isDisplay) {
        self.time = [NSString stringWithFormat:@"%ld",[self.time integerValue] - 1];
        self.buyingsecond = [NSString stringWithFormat:@"%ld",[self.buyingsecond integerValue] + 1];
        [self setSecond:self.time row:self.section buyingsecond:self.buyingsecond];
    }
    
}

-(void)setSecond:(NSString *)second row:(NSInteger)section buyingsecond:(NSString *)buyingsecond{
    
    self.section = section;
    self.time = second;
    self.buyingsecond = buyingsecond;
    if (_status == 1) {
        self.timeLimitView.image.image = [UIImage imageNamed:@"home-qianggou"];
        self.timeLimitView.timelb.textColor = LBHexadecimalColor(0xff6666);
        self.timeLimitView.statusLb.text = @"距结束";
        
        NSTimeInterval interval    =[buyingsecond doubleValue];
        NSDate *date               = [NSDate dateWithTimeIntervalSince1970:interval];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"HH:mm"];
        NSString *dateString       = [formatter stringFromDate: date];
        self.timeLimitView.timelb.text = [NSString stringWithFormat:@"%@正在疯抢",dateString];
    }else{
        self.timeLimitView.image.image = [UIImage imageNamed:@"home-time"];
        self.timeLimitView.timelb.textColor = LBHexadecimalColor(0x5C02FF);
        self.timeLimitView.timelb.text = [NSString stringWithFormat:@"%@等待疯抢",_waitmodel.start];
        self.timeLimitView.statusLb.text = @"距开始";
    }
    
    [self timeFormatted:[second intValue]];
    
}

- (void)timeFormatted:(int)totalSeconds
{
    
    int seconds = totalSeconds % 60;
    int minutes = (totalSeconds / 60) % 60;
    int hours = totalSeconds / 3600;
    
    if (hours <= 0 && minutes <=0 && seconds <= 0) {
        [self.timeLimitView.hourBt setTitle:[NSString stringWithFormat:@"00"] forState:UIControlStateNormal];
        [self.timeLimitView.minuteBt setTitle:[NSString stringWithFormat:@"00"] forState:UIControlStateNormal];
        [self.timeLimitView.secondBt setTitle:[NSString stringWithFormat:@"00"] forState:UIControlStateNormal];
        return;
    }
    [self.timeLimitView.hourBt setTitle:[NSString stringWithFormat:@"%02d",hours] forState:UIControlStateNormal];
    [self.timeLimitView.minuteBt setTitle:[NSString stringWithFormat:@"%02d", minutes] forState:UIControlStateNormal];
    [self.timeLimitView.secondBt setTitle:[NSString stringWithFormat:@"%02d",seconds] forState:UIControlStateNormal];
    
}


@end

