//
//  LBHomeActivityTableViewCell.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/4/20.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "LBHomeActivityTableViewCell.h"
#import "ZDProgressView.h"
#import "UIButton+SetEdgeInsets.h"
#import "CountDown.h"

@interface LBHomeActivityTableViewCell()
/**秒杀图片*/
@property (weak, nonatomic) IBOutlet UIImageView *skillImage;
@property (weak, nonatomic) IBOutlet UIView *progressView;
@property (nonatomic,strong) ZDProgressView *zdProgressView;
/**立即抢购按钮*/
@property (weak, nonatomic) IBOutlet UIButton *buyBt;
@property (weak, nonatomic) IBOutlet UILabel *goodsNameLabel;//商品名字
@property (weak, nonatomic) IBOutlet UILabel *subNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *pricelb;
@property (weak, nonatomic) IBOutlet UIButton *hourBt;
@property (weak, nonatomic) IBOutlet UIButton *mineteBt;
@property (weak, nonatomic) IBOutlet UIButton *secondBt;
@property (nonatomic, strong) CountDown *countDown;
@property (strong, nonatomic)  NSString *timeSp;

@end

@implementation LBHomeActivityTableViewCell

-(void)dealloc{
    [self.countDown destoryTimer];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.zdProgressView = [[ZDProgressView alloc] initWithFrame:CGRectMake(0, 0, 90, 13)];
    self.zdProgressView.progress = 0;
    self.zdProgressView.textFont = [UIFont systemFontOfSize:12];
    self.zdProgressView.text = @"剩余0件";
    self.zdProgressView.noColor = LBHexadecimalColor(0xffedec);
    self.zdProgressView.prsColor = MAIN_COLOR;
    [self.progressView addSubview:self.zdProgressView];
    
    self.buyBt.layer.cornerRadius = 10;
    [self.buyBt horizontalCenterTitleAndImage:5];
    
    self.zdProgressView.oneLabel.frame = CGRectMake(5, 0, 85, 13);
    self.zdProgressView.twoLabel.frame = CGRectMake(5, 0, 85, 13);
    self.zdProgressView.oneLabel.textAlignment = NSTextAlignmentLeft;
    self.zdProgressView.twoLabel.textAlignment = NSTextAlignmentLeft;

}

-(void)setModel:(LBTodayBuyingListTimeLimitActiveModel *)model{
    _model = model;
    [self.skillImage sd_setImageWithURL:[NSURL URLWithString:_model.thumb] placeholderImage:[UIImage imageNamed:PlaceHolder]];
    self.goodsNameLabel.text = [NSString stringWithFormat:@"%@",_model.goods_name];
    self.pricelb.text = [NSString stringWithFormat:@"¥%@",_model.costprice];
    NSString * progress = [NSString stringWithFormat:@"%.1f",[_model.sale_count floatValue] / [_model.challenge_alowd_num floatValue]];
    self.zdProgressView.text = [NSString stringWithFormat:@"剩余%d件",[_model.challenge_alowd_num intValue] - [_model.sale_count intValue]];
    self.zdProgressView.progress = [progress floatValue];
    self.timelb.text = [NSString stringWithFormat:@"%@场 >>",_model.start_time_chinese];
    
    //设置倒计时
    WeakSelf;
    [self.countDown countDownWithPER_SECBlock:^{
        
        [weakSelf getNowTimeWithString:[weakSelf timeWithTimeIntervalString:_model.challenge_end_time] stuasstr:@""];
    }];
}
//立即购买
- (IBAction)rightNowBuy:(UIButton *)sender {
    if (self.rightnowBuy) {
        self.rightnowBuy(_model.goods_id);
    }
}
-(CountDown*)countDown{
    if (!_countDown) {
        _countDown = [[CountDown alloc]init];
    }
    return _countDown;
}
-(void )getNowTimeWithString:(NSString *)aTimeString stuasstr:(NSString*)stuasstr{
    NSDateFormatter* formater = [[NSDateFormatter alloc] init];
    [formater setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    // 截止时间date格式
    NSDate  *expireDate = [formater dateFromString:aTimeString];
    NSDate  *nowDate = [formater dateFromString:[self nowtimeWithString]];
    //    NSDate  *nowDate = [NSDate date];
    //    // 当前时间字符串格式
    //    NSString *nowDateStr = [formater stringFromDate:nowDate];
    //    // 当前时间date格式
    //    nowDate = [formater dateFromString:nowDateStr];
    
    NSTimeInterval timeInterval =[expireDate timeIntervalSinceDate:nowDate];
    
    int days = (int)(timeInterval/(3600*24));
    int hours = (int)((timeInterval-days*24*3600)/3600);
    int minutes = (int)(timeInterval-days*24*3600-hours*3600)/60;
    int seconds = timeInterval-days*24*3600-hours*3600-minutes*60;
    
    NSString *dayStr;NSString *hoursStr;NSString *minutesStr;NSString *secondsStr;
    //天
    dayStr = [NSString stringWithFormat:@"%d",days];
    //小时
    if(hours<10)
        hoursStr = [NSString stringWithFormat:@"0%d",hours];
    else
        hoursStr = [NSString stringWithFormat:@"%d",hours];
    
    //分钟
    if(minutes<10)
        minutesStr = [NSString stringWithFormat:@"0%d",minutes];
    else
        minutesStr = [NSString stringWithFormat:@"%d",minutes];
    //秒
    if(seconds < 10)
        secondsStr = [NSString stringWithFormat:@"0%d", seconds];
    else
        secondsStr = [NSString stringWithFormat:@"%d",seconds];
    if (hours<=0&&minutes<=0&&seconds<=0) {
        [self.hourBt setTitle:@"00" forState:UIControlStateNormal];
        [self.mineteBt  setTitle:@"00" forState:UIControlStateNormal];
        [self.secondBt  setTitle:@"00" forState:UIControlStateNormal];
         [self.countDown destoryTimer];
        if (self.refreshData) {
            self.refreshData();
        }
        return;
    }
    
    [self.hourBt setTitle:hoursStr forState:UIControlStateNormal];
    [self.mineteBt setTitle:minutesStr forState:UIControlStateNormal];
    [self.secondBt setTitle:secondsStr forState:UIControlStateNormal];
    
}

-(NSString*)nowtimeWithString{
    // 格式化时间
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd  HH:mm:ss"];
    
    // 毫秒值转化为秒
    NSDate* date = [NSDate date];
    NSString* dateString = [formatter stringFromDate:date];
    return dateString;
    
    //    // 毫秒值转化为秒
    //    NSDate* date = [NSDate dateWithTimeIntervalSince1970:[self.model.now_time doubleValue]];
    //    NSString* dateString = [formatter stringFromDate:date];
    //    return dateString;
    
}

- (NSString *)timeWithTimeIntervalString:(NSString *)timeString
{
    // 格式化时间
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd  HH:mm:ss"];
    
    // 毫秒值转化为秒
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:[timeString doubleValue]];
    NSString* dateString = [formatter stringFromDate:date];
    return dateString;
}
@end
