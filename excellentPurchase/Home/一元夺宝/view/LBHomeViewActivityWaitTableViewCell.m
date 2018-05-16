//
//  LBHomeViewActivityWaitTableViewCell.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/3/8.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "LBHomeViewActivityWaitTableViewCell.h"

@interface LBHomeViewActivityWaitTableViewCell()

@property (weak, nonatomic) IBOutlet UIView *timeviewone;
@property (weak, nonatomic) IBOutlet UIButton *houronebt;
@property (weak, nonatomic) IBOutlet UIButton *minuteonebt;
@property (weak, nonatomic) IBOutlet UIButton *secondonebt;

@property (weak, nonatomic) IBOutlet UIView *timeviewtwo;
@property (weak, nonatomic) IBOutlet UIButton *hourtwobt;
@property (weak, nonatomic) IBOutlet UIButton *minutetwobt;
@property (weak, nonatomic) IBOutlet UIButton *secondtwobt;

@property(nonatomic,strong)NSString *time;
@property(nonatomic,strong)NSString *buyingsecond;
@property(nonatomic,assign)NSInteger section;

@property(nonatomic,strong)NSString *timeone;
@property(nonatomic,strong)NSString *buyingsecondone;
@property(nonatomic,assign)NSInteger sectionone;

@property (weak, nonatomic) IBOutlet UIImageView *imagev;
@property (weak, nonatomic) IBOutlet UILabel *titlelb;


@end

@implementation LBHomeViewActivityWaitTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationCenterEvent:)
                                                 name:OneDolphinTimeCellNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationCenterEventone:)
                                                 name:OneDolphinCellNotificationone
                                               object:nil];
}

- (void)notificationCenterEvent:(NSNotification*)noti{
    
    if (self.isDisplay) {
        self.time = [NSString stringWithFormat:@"%zd",[self.time integerValue] - 1];
        self.buyingsecond = [NSString stringWithFormat:@"%zd",[self.buyingsecond integerValue] + 1];
        [self setSecond:self.time row:self.section buyingsecond:self.buyingsecond];
    }
    
}

- (void)notificationCenterEventone:(NSNotification*)noti{
    
    if (self.isDisplayone) {
        self.timeone = [NSString stringWithFormat:@"%zd",[self.timeone integerValue] - 1];
        self.buyingsecondone = [NSString stringWithFormat:@"%zd",[self.buyingsecondone integerValue] + 1];
        [self setSecondone:self.timeone row:self.sectionone buyingsecond:self.buyingsecondone];
    }
    
}

-(void)setSecond:(NSString *)second row:(NSInteger)section buyingsecond:(NSString *)buyingsecond{
    
    self.section = section;
    self.time = second;
    self.buyingsecond = buyingsecond;
    [self timeFormatted:[second intValue]];
    
}

-(void)setSecondone:(NSString *)second row:(NSInteger)section buyingsecond:(NSString *)buyingsecond{
    
    self.sectionone = section;
    self.timeone = second;
    self.buyingsecondone = buyingsecond;
    [self timeFormatted:[second intValue]];
    
}

- (void)timeFormatted:(int)totalSeconds
{
    
    int seconds = totalSeconds % 60;
    int minutes = (totalSeconds / 60) % 60;
    int hours = totalSeconds / 3600;
    
    if (self.timeType == 1){//全部
        if (hours <= 0 && minutes <=0 && seconds <= 0) {
            [self.houronebt setTitle:[NSString stringWithFormat:@"00"] forState:UIControlStateNormal];
            [self.minuteonebt setTitle:[NSString stringWithFormat:@"00"] forState:UIControlStateNormal];
            [self.secondonebt setTitle:[NSString stringWithFormat:@"00"] forState:UIControlStateNormal];
            return;
        }
        [self.houronebt setTitle:[NSString stringWithFormat:@"%02d",hours] forState:UIControlStateNormal];
        [self.minuteonebt setTitle:[NSString stringWithFormat:@"%02d", minutes] forState:UIControlStateNormal];
        [self.secondonebt setTitle:[NSString stringWithFormat:@"%02d",seconds] forState:UIControlStateNormal];
    }else if (self.timeType == 2){//待开奖
        if (hours <= 0 && minutes <=0 && seconds <= 0) {
            [self.hourtwobt setTitle:[NSString stringWithFormat:@"00"] forState:UIControlStateNormal];
            [self.minutetwobt setTitle:[NSString stringWithFormat:@"00"] forState:UIControlStateNormal];
            [self.secondtwobt setTitle:[NSString stringWithFormat:@"00"] forState:UIControlStateNormal];
            return;
        }
        [self.hourtwobt setTitle:[NSString stringWithFormat:@"%02d",hours] forState:UIControlStateNormal];
        [self.minutetwobt setTitle:[NSString stringWithFormat:@"%02d", minutes] forState:UIControlStateNormal];
        [self.secondtwobt setTitle:[NSString stringWithFormat:@"%02d",seconds] forState:UIControlStateNormal];
    }
    
}



-(void)setModel:(LBHomeViewActivityListModel *)model{
    _model = model;
    
    if (self.timeType == 1) {
        self.timeviewone.hidden = NO;
        self.timeviewtwo.hidden = YES;
    }else if (self.timeType == 2){
        self.timeviewone.hidden = YES;
        self.timeviewtwo.hidden = NO;
    }
    [_imagev sd_setImageWithURL:[NSURL URLWithString:_model.indiana_goods_thumb] placeholderImage:[UIImage imageNamed:PlaceHolder]];
    _titlelb.text = _model.indiana_goods_name;
    
}
@end
