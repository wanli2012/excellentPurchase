//
//  GLMine_ShoppingCartCell.m
//  excellentPurchase
//
//  Created by 龚磊 on 2018/1/22.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "GLMine_ShoppingCartCell.h"
#import "ReactiveCocoa.h"
#import "CountDown.h"
#import "NSMutableAttributedString+LBSpecialAttributedString.h"

@interface GLMine_ShoppingCartCell()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIView *selectView;//选中点击范围view
@property (weak, nonatomic) IBOutlet UIImageView *selectedImageV;//是否选中标
@property (weak, nonatomic) IBOutlet UIImageView *picImageV;//商品数量
@property (weak, nonatomic) IBOutlet UILabel *goodsNameLabel;//商品名
@property (weak, nonatomic) IBOutlet UILabel *specLabel;//规格
@property (weak, nonatomic) IBOutlet UILabel *rebateLabel;//返的积分 和 购物券
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;//价格
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;//购买数量

@property (weak, nonatomic) IBOutlet UIView *numberChangeView;//数量加减
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *picImageVWidth;
@property (weak, nonatomic) IBOutlet UIView *rateView;
@property (weak, nonatomic) IBOutlet UIView *timeView;
@property (weak, nonatomic) IBOutlet UILabel *timeLb;
@property (weak, nonatomic) IBOutlet UIButton *hourBt;
@property (weak, nonatomic) IBOutlet UIButton *minuteBt;
@property (weak, nonatomic) IBOutlet UIButton *secondBt;
@property (strong, nonatomic)  CountDown *countDown;
@property (strong, nonatomic)  NSString *timeSp;
@property (weak, nonatomic) IBOutlet UILabel *discountPrice;//原价
@property (weak, nonatomic) IBOutlet UILabel *discountLb;//原价后面描述
@property (weak, nonatomic) IBOutlet UIView *discountline;//原价画线
@property (weak, nonatomic) IBOutlet UILabel *limitLb;


@end

@implementation GLMine_ShoppingCartCell
-(void)dealloc{
    [self.countDown destoryTimer];
}
- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.picImageVWidth.constant = CZH_ScaleWidth(110);
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectClick)];
    [self.selectView addGestureRecognizer:tap];
    self.countDown = [[CountDown alloc] init];
    ///响应式编程  即时获取textfield输入值
    [[self.amountTF rac_textSignal] subscribeNext:^(id x) {
        _model.buy_num = x;
    }];
    
}

//选中  取消
- (void)selectClick{
    if ([self.delegate respondsToSelector:@selector(changeStatus: andSection:)]) {
        [self.delegate changeStatus:self.index andSection:self.section];
    }
}

/**
 数量加减
 @param sender 加号按钮 还是 减号按钮
 */
- (IBAction)changeNum:(UIButton *)sender {
    switch (sender.tag) {
        case 11://数量减
        {
            if ([self.delegate respondsToSelector:@selector(changeNum:andSection:andIsAdd:)]) {
                [self.delegate changeNum:self.index andSection:self.section andIsAdd:NO];
            }
        }
            break;
        case 12://数量加
        {
            if ([self.delegate respondsToSelector:@selector(changeNum:andSection:andIsAdd:)]) {
                [self.delegate changeNum:self.index andSection:self.section andIsAdd:YES];
            }
        }
            break;
            
        default:
            break;
    }
}

- (void)setModel:(GLMine_ShoppingPropertyCartModel *)model{
    _model = model;
    //是否是选中状态
    if(_model.isSelect){
        self.selectedImageV.image = [UIImage imageNamed:@"pay-select-y"];
    }else{
        self.selectedImageV.image = [UIImage imageNamed:@"pay-select-n"];
    }
    
    [self.picImageV sd_setImageWithURL:[NSURL URLWithString:model.thumb] placeholderImage:[UIImage imageNamed:PlaceHolder]];
    self.goodsNameLabel.text = _model.goods_name;
    self.specLabel.text = [NSString stringWithFormat:@"规格:%@",_model.title];
    self.priceLabel.attributedText = [NSMutableAttributedString addoriginstr:[NSString stringWithFormat:@"¥ %@",_model.marketprice] specilstr:@[[NSString stringWithFormat:@"%@",_model.marketprice]] strFont:[UIFont systemFontOfSize:15] strColor:LBHexadecimalColor(0x333333)];

    self.amountTF.text = model.buy_num;
    self.amountLabel.text = [NSString stringWithFormat:@"x%@",_model.buy_num];
    
    if ([_model.rewardspoints floatValue] <= 0 && [_model.reward_coupons floatValue] <= 0 ) {
        self.rateView.hidden = YES;
    }else{
        self.rateView.hidden = NO;
        if ([_model.rewardspoints floatValue] > 0 && [_model.reward_coupons floatValue] > 0) {
             self.rebateLabel.text = [NSString stringWithFormat:@"%@积分; %@购物券",_model.rewardspoints,_model.reward_coupons];
        }else  if ([_model.rewardspoints floatValue] <= 0 && [_model.reward_coupons floatValue] > 0) {
             self.rebateLabel.text = [NSString stringWithFormat:@"%@购物券",_model.reward_coupons];
        }else  if ([_model.rewardspoints floatValue] > 0 && [_model.reward_coupons floatValue] <= 0) {
            self.rebateLabel.text = [NSString stringWithFormat:@"%@积分",_model.rewardspoints];
        }
    }

    //设置倒计时
    NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式
    self.timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]];
    
    if ([_model.active.active_status integerValue] == 1) {
        self.timeView.hidden = NO;
        //是否是编辑状态
        if (_model.isEdit) {
            self.priceLabel.hidden = YES;
            self.amountLabel.hidden = YES;
            self.numberChangeView.hidden = NO;
            self.limitLb.hidden = YES;
            [self setHidecontrols:YES];
        }else{
            self.priceLabel.hidden = NO;
            self.amountLabel.hidden = NO;
            self.numberChangeView.hidden = YES;
            self.limitLb.hidden = NO;
            [self setHidecontrols:NO];
        }
        if ([_model.buy_num integerValue] > [_model.challenge_max_count integerValue] || [model.active.u_count integerValue] >= [_model.challenge_max_count integerValue]) {
            if ([_model.coupons_active.active_status integerValue] == 1) {
                NSString  *str1 = [NSString stringWithFormat:@"¥ %.1f + %@购物券",[_model.marketprice floatValue] - [_model.discount floatValue], _model.discount];
                self.priceLabel.attributedText = [NSMutableAttributedString addoriginstr:str1 specilstr:@[[NSString stringWithFormat:@"%.1f",[_model.marketprice floatValue] - [_model.discount floatValue]]] strFont:[UIFont systemFontOfSize:15] strColor:LBHexadecimalColor(0x333333)];
            }else{
                NSString  *str1 = [NSString stringWithFormat:@"¥ %.1f ",[_model.marketprice floatValue]];
                self.priceLabel.attributedText = [NSMutableAttributedString addoriginstr:str1 specilstr:@[[NSString stringWithFormat:@"%.1f",[_model.marketprice floatValue]]] strFont:[UIFont systemFontOfSize:15] strColor:LBHexadecimalColor(0x333333)];
            }
        }else{
            self.priceLabel.attributedText = [NSMutableAttributedString addoriginstr:[NSString stringWithFormat:@"¥ %@",_model.costprice] specilstr:@[[NSString stringWithFormat:@"%@",_model.costprice]] strFont:[UIFont systemFontOfSize:15] strColor:LBHexadecimalColor(0x333333)];
        }
        self.discountPrice.text = [NSString stringWithFormat:@"¥ %@",_model.marketprice];
        self.limitLb.text = [NSString stringWithFormat:@"每人限购%@件",_model.challenge_max_count];
        self.discountLb.text = @"限时抢购";
        self.timeLb.text = @"结束倒计时:";
        __weak __typeof(self) weakSelf= self;
        [self.countDown countDownWithPER_SECBlock:^{
            self.timeSp = [NSString stringWithFormat:@"%f",[self.timeSp doubleValue] + 1];
            
            if ([self.timeSp integerValue] >= [_model.active.active_end_time integerValue]) {
                self.timeLb.text = @"活动已结束:";
                [self.hourBt setTitle:@"00" forState:UIControlStateNormal];
                [self.minuteBt  setTitle:@"00" forState:UIControlStateNormal];
                [self.secondBt  setTitle:@"00" forState:UIControlStateNormal];
                return;
            }else{
                [weakSelf getNowTimeWithString:[weakSelf timeWithTimeIntervalString:_model.active.active_end_time] stuasstr:@""];
            }
                
        }];
    }
//    else if ([_model.active.active_status integerValue] == 2){
//        self.timeView.hidden = NO;
//        //是否是编辑状态
//        if (_model.isEdit) {
//            self.priceLabel.hidden = YES;
//            self.amountLabel.hidden = YES;
//            self.numberChangeView.hidden = NO;
//            self.limitLb.hidden = YES;
//            [self setHidecontrols:YES];
//        }else{
//            self.priceLabel.hidden = NO;
//            self.amountLabel.hidden = NO;
//            self.numberChangeView.hidden = YES;
//            self.limitLb.hidden = NO;
//            [self setHidecontrols:NO];
//        }
//        if ([_model.buy_num integerValue] > [_model.challenge_max_count integerValue] || [model.active.u_count integerValue] >= [_model.challenge_max_count integerValue]) {
//            NSString  *str1 = [NSString stringWithFormat:@"¥ %.1f + %@购物券",[_model.marketprice floatValue] - [_model.discount floatValue], _model.discount];
//            self.priceLabel.attributedText = [NSMutableAttributedString addoriginstr:str1 specilstr:@[[NSString stringWithFormat:@"%.1f",[_model.marketprice floatValue] - [_model.discount floatValue]]] strFont:[UIFont systemFontOfSize:15] strColor:LBHexadecimalColor(0x333333)];
//        }else{
//            self.priceLabel.attributedText = [NSMutableAttributedString addoriginstr:[NSString stringWithFormat:@"¥ %@",_model.costprice] specilstr:@[[NSString stringWithFormat:@"%@",_model.costprice]] strFont:[UIFont systemFontOfSize:15] strColor:LBHexadecimalColor(0x333333)];
//        }
//        self.discountPrice.text = [NSString stringWithFormat:@"¥ %@",_model.marketprice];
//        self.limitLb.text = [NSString stringWithFormat:@"每人限购%@件",_model.challenge_max_count];
//        self.discountLb.text = @"限时抢购";
//        self.timeLb.text = @"开始倒计时:";
//        __weak __typeof(self) weakSelf= self;
//        if ([self.timeSp integerValue] >= [_model.active.active_start_time integerValue]) {
//            self.timeLb.text = @"结束倒计时:";
//            [weakSelf getNowTimeWithString:[weakSelf timeWithTimeIntervalString:_model.active.active_end_time] stuasstr:@""];
//        }else{
//            [weakSelf getNowTimeWithString:[weakSelf timeWithTimeIntervalString:_model.active.active_start_time] stuasstr:@""];
//        }
        
//    }
else{
        self.timeView.hidden = YES;
        self.limitLb.hidden = YES;
         //判断是非为购物券活动
        if ([_model.coupons_active.active_status integerValue] == 1) {
            [self setHidecontrols:NO];
            //是否是编辑状态
            if (_model.isEdit) {
                self.priceLabel.hidden = YES;
                self.amountLabel.hidden = YES;
                self.numberChangeView.hidden = NO;
                [self setHidecontrols:YES];
            }else{
                self.priceLabel.hidden = NO;
                self.amountLabel.hidden = NO;
                self.numberChangeView.hidden = YES;
                [self setHidecontrols:NO];
            }
            if ([_model.coupons_active.active_status integerValue] == 1) {
                NSString  *str1 = [NSString stringWithFormat:@"¥ %.1f + %@购物券",[_model.marketprice floatValue] - [_model.discount floatValue], _model.discount];
                self.priceLabel.attributedText = [NSMutableAttributedString addoriginstr:str1 specilstr:@[[NSString stringWithFormat:@"%.1f",[_model.marketprice floatValue] - [_model.discount floatValue]]] strFont:[UIFont systemFontOfSize:15] strColor:LBHexadecimalColor(0x333333)];
            }else{
                NSString  *str1 = [NSString stringWithFormat:@"¥ %.1f ",[_model.marketprice floatValue]];
                self.priceLabel.attributedText = [NSMutableAttributedString addoriginstr:str1 specilstr:@[[NSString stringWithFormat:@"%.1f",[_model.marketprice floatValue]]] strFont:[UIFont systemFontOfSize:15] strColor:LBHexadecimalColor(0x333333)];
            }
            self.discountPrice.text = [NSString stringWithFormat:@"¥ %@",_model.marketprice];
            self.discountLb.text = @"购物券抵扣";
        }else{
            [self setHidecontrols:YES];
            //是否是编辑状态
            if (_model.isEdit) {
                self.priceLabel.hidden = YES;
                self.amountLabel.hidden = YES;
                self.numberChangeView.hidden = NO;
            }else{
                self.priceLabel.hidden = NO;
                self.amountLabel.hidden = NO;
                self.numberChangeView.hidden = YES;
            }
        }
    }
}
//设置控件显示
-(void)setHidecontrols:(BOOL)b{
    self.discountLb.hidden = b;
    self.discountPrice.hidden = b;
    self.discountline.hidden = b;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [self endEditing:YES];
    
    return YES;
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
        [self.minuteBt  setTitle:@"00" forState:UIControlStateNormal];
        [self.secondBt  setTitle:@"00" forState:UIControlStateNormal];
        return;
    }
    
    [self.hourBt setTitle:hoursStr forState:UIControlStateNormal];
    [self.minuteBt setTitle:minutesStr forState:UIControlStateNormal];
    [self.secondBt setTitle:secondsStr forState:UIControlStateNormal];
    
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

//比较两个日期的大小  日期格式为2016-08-14 08：46：20
- (NSInteger)compareDate:(NSString*)aDate withDate:(NSString*)bDate
{
    NSInteger aa;
    NSDateFormatter *dateformater = [[NSDateFormatter alloc] init];
    [dateformater setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *dta = [[NSDate alloc] init];
    NSDate *dtb = [[NSDate alloc] init];
    
    dta = [dateformater dateFromString:aDate];
    dtb = [dateformater dateFromString:bDate];
    NSComparisonResult result = [dta compare:dtb];
    if (result==NSOrderedSame)
    {
        //        相等
        aa=0;
    }else if (result==NSOrderedAscending)
    {
        //bDate比aDate大
        aa=1;
    }else
    {
        //bDate比aDate小
        aa=-1;
        
    }
    
    return aa;
}

@end
