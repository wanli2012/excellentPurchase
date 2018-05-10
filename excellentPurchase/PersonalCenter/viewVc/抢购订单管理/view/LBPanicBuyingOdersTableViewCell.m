//
//  LBPanicBuyingOdersTableViewCell.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/3/21.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "LBPanicBuyingOdersTableViewCell.h"
#import "CountDown.h"
#import "LBMineCenterFlyNoticeDetailViewController.h"

@interface LBPanicBuyingOdersTableViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *imagev;
@property (weak, nonatomic) IBOutlet UILabel *goodname;
@property (weak, nonatomic) IBOutlet UILabel *statuslb;
@property (weak, nonatomic) IBOutlet UILabel *pricelb;
@property (weak, nonatomic) IBOutlet UILabel *numlb;
@property (weak, nonatomic) IBOutlet UIButton *hourbt;
@property (weak, nonatomic) IBOutlet UIButton *minutebt;
@property (weak, nonatomic) IBOutlet UIButton *secondbt;
@property (strong, nonatomic)  CountDown *countDown;
@property (strong, nonatomic)  NSString *timeSp;

@property (weak, nonatomic) IBOutlet UILabel *ord_num;
@property (weak, nonatomic) IBOutlet UILabel *ordstatuslb;
@property (weak, nonatomic) IBOutlet UIButton *rightbt;
@property (weak, nonatomic) IBOutlet UIButton *leftbt;
@property (weak, nonatomic) IBOutlet UILabel *describlb;
@property (weak, nonatomic) IBOutlet UILabel *ord_spec_info;
@property (weak, nonatomic) IBOutlet UILabel *oldpricelb;

@property (weak, nonatomic) IBOutlet UIView *buttonView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *butonviewW;
@property (weak, nonatomic) IBOutlet UIView *timeview;

@property (weak, nonatomic) IBOutlet UIView *timeviewone;
@property (weak, nonatomic) IBOutlet UIButton *houronebt;
@property (weak, nonatomic) IBOutlet UIButton *minuteonebt;
@property (weak, nonatomic) IBOutlet UIButton *secondonebt;

@property (weak, nonatomic) IBOutlet UIView *timeviewtwo;
@property (weak, nonatomic) IBOutlet UIButton *hourtwobt;
@property (weak, nonatomic) IBOutlet UIButton *minutetwobt;
@property (weak, nonatomic) IBOutlet UIButton *secondtwobt;

@property (weak, nonatomic) IBOutlet UIView *timeviewthree;
@property (weak, nonatomic) IBOutlet UIButton *hourthreebt;
@property (weak, nonatomic) IBOutlet UIButton *minutethreebt;
@property (weak, nonatomic) IBOutlet UIButton *secondthreebt;

@property (weak, nonatomic) IBOutlet UIView *timeviewfour;
@property (weak, nonatomic) IBOutlet UIButton *hourfourbt;
@property (weak, nonatomic) IBOutlet UIButton *minutefourbt;
@property (weak, nonatomic) IBOutlet UIButton *secondfourbt;

@property(nonatomic,strong)NSString *time;
@property(nonatomic,strong)NSString *buyingsecond;
@property(nonatomic,assign)NSInteger section;

@property(nonatomic,strong)NSString *timeone;
@property(nonatomic,strong)NSString *buyingsecondone;
@property(nonatomic,assign)NSInteger sectionone;

@property(nonatomic,strong)NSString *timetwo;
@property(nonatomic,strong)NSString *buyingsecondtwo;
@property(nonatomic,assign)NSInteger sectiontwo;

@property(nonatomic,strong)NSString *timethree;
@property(nonatomic,strong)NSString *buyingsecondthree;
@property(nonatomic,assign)NSInteger sectionthree;

@property(nonatomic,strong)NSString *timefour;
@property(nonatomic,strong)NSString *buyingsecondfour;
@property(nonatomic,assign)NSInteger sectionfour;

@property (weak, nonatomic) IBOutlet UIButton *refuseBT;


@end

@implementation LBPanicBuyingOdersTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];

    self.countDown = [[CountDown alloc] init];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationCenterEvent:)
                                                 name:OrderTimeCellNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationCenterEventone:)
                                                 name:OrderTimeCellNotificationone
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationCenterEventtwo:)
                                                 name:OrderTimeCellNotificationtwo
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationCenterEventthree:)
                                                 name:OrderTimeCellNotificationthree
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationCenterEventfour:)
                                                 name:OrderTimeCellNotificationfour
                                               object:nil];
}

- (IBAction)rightEventBt:(UIButton *)sender {
    if ([_model.ord_status integerValue] == 1) {
        [self eventPayorder];//去付款
    }else if ([_model.ord_status integerValue] == 2){//申请退款
        [self replyRefuseEvent:nil];
    }else if ([_model.ord_status integerValue] == 3){
        [self.delegete sureReciveGoods:self.indexpath];
    }else if ([_model.ord_status integerValue] == 5){
        [self.delegete Goevaluate:self.indexpath];
    }
}

- (IBAction)leftEventBt:(UIButton *)sender {
    if ([_model.ord_status integerValue] == 1) {
        [self cancelOrder];//取消订单
    }else if ([_model.ord_status integerValue] == 3){
        [self.delegete checklogistics:self.indexpath];
    }else if ([_model.ord_status integerValue] == 5){
        
    }
}
//申请退款
- (IBAction)replyRefuseEvent:(UIButton *)sender {
    
    [self.delegete applyRefund:self.indexpath];
}

-(void)eventPayorder{
    [self.delegete GoPayOrders:self.indexpath];
}

-(void)cancelOrder{
    [self.delegete cancelOrders:_model.ord_id];
}

- (void)notificationCenterEvent:(NSNotification*)noti{
    
    if (self.isDisplay) {
        self.time = [NSString stringWithFormat:@"%ld",[self.time integerValue] - 1];
        self.buyingsecond = [NSString stringWithFormat:@"%ld",[self.buyingsecond integerValue] + 1];
        [self setSecond:self.time row:self.section buyingsecond:self.buyingsecond];
    }
    
}

- (void)notificationCenterEventone:(NSNotification*)noti{
    
    if (self.isDisplayone) {
        self.timeone = [NSString stringWithFormat:@"%ld",[self.timeone integerValue] - 1];
        self.buyingsecondone = [NSString stringWithFormat:@"%ld",[self.buyingsecondone integerValue] + 1];
        [self setSecondone:self.timeone row:self.sectionone buyingsecond:self.buyingsecondone];
    }
    
}

- (void)notificationCenterEventtwo:(NSNotification*)noti{
    
    if (self.isDisplaytwo) {
        self.timetwo = [NSString stringWithFormat:@"%ld",[self.timetwo integerValue] - 1];
        self.buyingsecondtwo = [NSString stringWithFormat:@"%ld",[self.buyingsecondtwo integerValue] + 1];
        [self setSecondtwo:self.timetwo row:self.sectiontwo buyingsecond:self.buyingsecondtwo];
    }
}

- (void)notificationCenterEventthree:(NSNotification*)noti{
    
    if (self.isDisplaythree) {
        self.timethree = [NSString stringWithFormat:@"%ld",[self.timethree integerValue] - 1];
        self.buyingsecondthree = [NSString stringWithFormat:@"%ld",[self.buyingsecondthree integerValue] + 1];
        [self setSecondthree:self.timethree row:self.sectionthree buyingsecond:self.buyingsecondthree];
    }
}

- (void)notificationCenterEventfour:(NSNotification*)noti{
    
    if (self.isDisplayfour) {
        self.timefour = [NSString stringWithFormat:@"%ld",[self.timefour integerValue] - 1];
        self.buyingsecondfour = [NSString stringWithFormat:@"%ld",[self.buyingsecondfour integerValue] + 1];
        [self setSecondfour:self.timefour row:self.sectionfour buyingsecond:self.buyingsecondfour];
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

-(void)setSecondtwo:(NSString *)second row:(NSInteger)section buyingsecond:(NSString *)buyingsecond{
    
    self.sectiontwo = section;
    self.timetwo = second;
    self.buyingsecondtwo = buyingsecond;
    [self timeFormatted:[second intValue]];
    
}

-(void)setSecondthree:(NSString *)second row:(NSInteger)section buyingsecond:(NSString *)buyingsecond{
    
    self.sectionthree = section;
    self.timethree = second;
    self.buyingsecondthree = buyingsecond;
    [self timeFormatted:[second intValue]];
    
}

-(void)setSecondfour:(NSString *)second row:(NSInteger)section buyingsecond:(NSString *)buyingsecond{
    
    self.sectionfour = section;
    self.timefour = second;
    self.buyingsecondfour = buyingsecond;
    [self timeFormatted:[second intValue]];
    
}

- (void)timeFormatted:(int)totalSeconds
{
    
    int seconds = totalSeconds % 60;
    int minutes = (totalSeconds / 60) % 60;
    int hours = totalSeconds / 3600;
    
    if (self.timeType == 1) {//全部
        if (hours <= 0 && minutes <=0 && seconds <= 0) {
            [self hideAllTimeview];
            return;
        }
        [self.hourbt setTitle:[NSString stringWithFormat:@"%02d",hours] forState:UIControlStateNormal];
        [self.minutebt setTitle:[NSString stringWithFormat:@"%02d", minutes] forState:UIControlStateNormal];
        [self.secondbt setTitle:[NSString stringWithFormat:@"%02d",seconds] forState:UIControlStateNormal];
    }else if (self.timeType == 2){//待付款
        if (hours <= 0 && minutes <=0 && seconds <= 0) {
           [self hideAllTimeview];
            return;
        }
        [self.houronebt setTitle:[NSString stringWithFormat:@"%02d",hours] forState:UIControlStateNormal];
        [self.minuteonebt setTitle:[NSString stringWithFormat:@"%02d", minutes] forState:UIControlStateNormal];
        [self.secondonebt setTitle:[NSString stringWithFormat:@"%02d",seconds] forState:UIControlStateNormal];
    }else if (self.timeType == 3){//已完成
        if (hours <= 0 && minutes <=0 && seconds <= 0) {
            [self hideAllTimeview];
            return;
        }
        [self.hourtwobt setTitle:[NSString stringWithFormat:@"%02d",hours] forState:UIControlStateNormal];
        [self.minutetwobt setTitle:[NSString stringWithFormat:@"%02d", minutes] forState:UIControlStateNormal];
        [self.secondtwobt setTitle:[NSString stringWithFormat:@"%02d",seconds] forState:UIControlStateNormal];
    }else if (self.timeType == 4){//待收货
        if (hours <= 0 && minutes <=0 && seconds <= 0) {
            [self hideAllTimeview];
            return;
        }
        [self.hourthreebt setTitle:[NSString stringWithFormat:@"%02d",hours] forState:UIControlStateNormal];
        [self.minutethreebt setTitle:[NSString stringWithFormat:@"%02d", minutes] forState:UIControlStateNormal];
        [self.secondthreebt setTitle:[NSString stringWithFormat:@"%02d",seconds] forState:UIControlStateNormal];
    }else if (self.timeType == 5){//退款
        if (hours <= 0 && minutes <=0 && seconds <= 0) {
            [self hideAllTimeview];
            return;
        }
        [self.hourfourbt setTitle:[NSString stringWithFormat:@"%02d",hours] forState:UIControlStateNormal];
        [self.minutefourbt setTitle:[NSString stringWithFormat:@"%02d", minutes] forState:UIControlStateNormal];
        [self.secondfourbt setTitle:[NSString stringWithFormat:@"%02d",seconds] forState:UIControlStateNormal];
    }
    
}

-(void)setModel:(LBPanicBuyingOdersGoodsModel *)model{
    _model = model;
    [self.imagev sd_setImageWithURL:[NSURL URLWithString:_model.thumb] placeholderImage:[UIImage imageNamed:PlaceHolder]];
    self.goodname.text = [NSString stringWithFormat:@"%@",_model.goods_name];
    self.pricelb.text = [NSString stringWithFormat:@"¥%@",_model.ord_goods_price];
    self.numlb.text = [NSString stringWithFormat:@"x%@",_model.ord_goods_num];
    self.oldpricelb.text = [NSString stringWithFormat:@"¥%@",_model.marketprice];
    self.ord_spec_info.text = [NSString stringWithFormat:@"规格:%@",_model.ord_spec_info];
    self.ord_num.text = [NSString stringWithFormat:@"订单号:%@",_model.ord_order_num];
    [self setOrdstatus:[_model.ord_status intValue]];
    [self setbutton:[_model.ord_status intValue]];
    NSString *allsendprice = [NSString stringWithFormat:@"%d",([_model.ord_goods_price intValue] + [_model.ord_send_price intValue]) * [_model.ord_goods_num intValue]];
    if ([_model.ord_status intValue] == 7 || [_model.ord_status intValue] == 8 || [_model.ord_status intValue] == 9) {
        if ([_model.ord_offset_coupons integerValue] == 0) {
            self.describlb.attributedText = [self addoriginstr:[NSString stringWithFormat:@"退款金额¥%d (不含运费¥%d)",([_model.ord_goods_price intValue] ) * [_model.ord_goods_num intValue],[_model.ord_send_price intValue] * [_model.ord_goods_num intValue]] specilstr:@[[NSString stringWithFormat:@"¥%d",([_model.ord_goods_price intValue] ) * [_model.ord_goods_num intValue]]]];
            
        }else{
            self.describlb.attributedText = [self addoriginstr:[NSString stringWithFormat:@"退款金额¥%d + %d购物券(不含运费¥%d)",([_model.ord_goods_price intValue] - [_model.ord_offset_coupons intValue]) * [_model.ord_goods_num intValue],[_model.ord_offset_coupons intValue] * [_model.ord_goods_num intValue],[_model.ord_send_price intValue] * [_model.ord_goods_num intValue]] specilstr:@[[NSString stringWithFormat:@"¥%d + %d",([_model.ord_goods_price intValue] - [_model.ord_offset_coupons intValue]) * [_model.ord_goods_num intValue],[_model.ord_offset_coupons intValue] * [_model.ord_goods_num intValue]]]];
        }
    }else{
        if ([_model.ord_offset_coupons integerValue] == 0) {
            self.describlb.attributedText = [self addoriginstr:[NSString stringWithFormat:@"共%@件商品，合计：¥%d (含运费¥%d)",_model.ord_goods_num,([_model.ord_goods_price intValue] + [_model.ord_send_price intValue]) * [_model.ord_goods_num intValue],[_model.ord_send_price intValue] * [_model.ord_goods_num intValue]] specilstr:@[allsendprice]];
        }else{
            self.describlb.attributedText = [self addoriginstr:[NSString stringWithFormat:@"共%@件商品，合计：¥%d (含购物券%d;含运费¥%d)",_model.ord_goods_num,([_model.ord_goods_price intValue] + [_model.ord_send_price intValue]) * [_model.ord_goods_num intValue],[_model.ord_offset_coupons intValue] * [_model.ord_goods_num intValue],[_model.ord_send_price intValue] * [_model.ord_goods_num intValue]] specilstr:@[allsendprice]];
        }
    }
    
    if (self.jumpType == 1) {
        self.statuslb.hidden = YES;
        self.timeview.hidden = YES;
        self.timeviewone.hidden = YES;
        self.timeviewtwo.hidden = YES;
        self.timeviewthree.hidden = YES;
        self.timeviewfour.hidden = YES;
    }else{
        [self setTimeShow];
    }
    
}

-(void)setTimeShow{
    
    if (self.timeType == 1) {
        self.timeview.hidden = NO;
        self.timeviewone.hidden = YES;
        self.timeviewtwo.hidden = YES;
        self.timeviewthree.hidden = YES;
        self.timeviewfour.hidden = YES;
    }else  if (self.timeType == 2){
        self.timeview.hidden = YES;
        self.timeviewone.hidden = NO;
        self.timeviewtwo.hidden = YES;
        self.timeviewthree.hidden = YES;
        self.timeviewfour.hidden = YES;
    }else  if (self.timeType == 3){
        self.timeview.hidden = YES;
        self.timeviewone.hidden = YES;
        self.timeviewtwo.hidden = NO;
        self.timeviewthree.hidden = YES;
        self.timeviewfour.hidden = YES;
    }else  if (self.timeType == 4){
        self.timeview.hidden = YES;
        self.timeviewone.hidden = YES;
        self.timeviewtwo.hidden = YES;
        self.timeviewthree.hidden = NO;
        self.timeviewfour.hidden = YES;

    }else  if (self.timeType == 5){
        self.timeview.hidden = YES;
        self.timeviewone.hidden = YES;
        self.timeviewtwo.hidden = YES;
        self.timeviewthree.hidden = YES;
        self.timeviewfour.hidden = NO;
    }
    
    if ([_model.active.active_status integerValue] == 1) {
        self.statuslb.text = @"距结束:";
        
    }else  if ([_model.active.active_status integerValue] == 2) {
        self.statuslb.text = @"距开始:";
        
    }else  if ([_model.active.active_status integerValue] == 3) {
        [self hideAllTimeview];
        return;
    }else {
        [self hideAllTimeview];
        return;
    }
}

-(void)setbutton:(int)status{
    self.refuseBT.hidden = YES;
    switch (status) {
        case 0:
        {
            self.buttonView.hidden = YES;
            self.butonviewW.constant = 0;
        }
            break;
        case 1:
        {
            self.buttonView.hidden = NO;
            self.leftbt.hidden = NO;
            self.rightbt.hidden = NO;
            self.butonviewW.constant = 55;
            self.leftbt.layer.borderWidth = 1;
            self.leftbt.layer.borderColor =YYSRGBColor(188, 188, 188, 1).CGColor;
            [self.leftbt setTitleColor:LBHexadecimalColor(0x333333) forState:UIControlStateNormal];
            self.leftbt.backgroundColor = [UIColor whiteColor];
            self.rightbt.backgroundColor = MAIN_COLOR;
            [self.rightbt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            self.rightbt.layer.borderWidth = 1;
            self.rightbt.layer.borderColor =[UIColor clearColor].CGColor;
            [self.leftbt setTitle:@"取消订单" forState:UIControlStateNormal];
            [self.rightbt setTitle:@"去付款" forState:UIControlStateNormal];
        }
            break;
        case 2:
            {
                self.buttonView.hidden = NO;
                self.leftbt.hidden = YES;
                self.rightbt.hidden = NO;
                self.butonviewW.constant = 55;
                self.rightbt.layer.borderWidth = 1;
                self.rightbt.layer.borderColor =YYSRGBColor(188, 188, 188, 1).CGColor;
                [self.rightbt setTitleColor:LBHexadecimalColor(0x333333) forState:UIControlStateNormal];
                self.rightbt.backgroundColor = [UIColor whiteColor];
                [self.rightbt setTitle:@"申请退款" forState:UIControlStateNormal];
                
            }
            break;
        case 3:
            {
                self.buttonView.hidden = NO;
                self.refuseBT.hidden = NO;
                self.butonviewW.constant = 55;
                self.leftbt.hidden = NO;
                self.rightbt.hidden = NO;
                self.leftbt.layer.borderWidth = 1;
                self.leftbt.layer.borderColor =YYSRGBColor(188, 188, 188, 1).CGColor;
                [self.leftbt setTitleColor:LBHexadecimalColor(0x333333) forState:UIControlStateNormal];
                self.leftbt.backgroundColor = [UIColor whiteColor];
                self.rightbt.backgroundColor = [UIColor whiteColor];
                [self.rightbt setTitleColor:MAIN_COLOR forState:UIControlStateNormal];
                self.rightbt.layer.borderWidth = 1;
                self.rightbt.layer.borderColor =MAIN_COLOR.CGColor;
        
                [self.leftbt setTitle:@"查看物流" forState:UIControlStateNormal];
                [self.rightbt setTitle:@"确认收货" forState:UIControlStateNormal];

            }
            break;
        case 5:
            {
                if ([_model.is_comment  integerValue]== 1) {
                    self.buttonView.hidden = YES;
                    self.butonviewW.constant = 0;
                }else{
                    self.buttonView.hidden = NO;
                    self.butonviewW.constant = 55;
                    self.leftbt.hidden = YES;
                    self.rightbt.hidden = NO;
                    self.rightbt.backgroundColor = [UIColor whiteColor];
                    [self.rightbt setTitleColor:MAIN_COLOR forState:UIControlStateNormal];
                    self.rightbt.layer.borderWidth = 1;
                    self.rightbt.layer.borderColor =MAIN_COLOR.CGColor;
                     [self.rightbt setTitle:@"去评价" forState:UIControlStateNormal];
                }
            }
            break;
        case 6:
            {
                self.buttonView.hidden = YES;
                self.butonviewW.constant = 0;
            }
            break;
        case 7:
            {
                self.buttonView.hidden = YES;
                self.butonviewW.constant = 0;
            }
            break;
        case 8:
            {
                self.buttonView.hidden = YES;
                self.butonviewW.constant = 0;
            }
            break;
        case 9:
            {
                self.buttonView.hidden = YES;
                self.butonviewW.constant = 0;
            }
            break;
        case 10:
            {
                self.buttonView.hidden = YES;
                self.butonviewW.constant = 0;
            }
            break;
        case 11:
            {
                self.buttonView.hidden = YES;
                self.butonviewW.constant = 0;
            }
            break;
            
        default:
            break;
    }
    
}

-(void)setOrdstatus:(int)status{
    
    switch (status) {
        case 0:
            self.ordstatuslb.text = @"订单异常";
            break;
        case 1:
            self.ordstatuslb.text = @"已下单,未付款";
            break;
        case 2:
            self.ordstatuslb.text = @"已付款,待发货";
            break;
        case 3:
            self.ordstatuslb.text = @"已发货,待验收";
            break;
        case 5:
            self.ordstatuslb.text = @"确认订单生效";
            break;
        case 6:
            self.ordstatuslb.text = @"交易失败";
            break;
        case 7:
            self.ordstatuslb.text = @"退款中";
            break;
        case 8:
            self.ordstatuslb.text = @"退款成功";
            break;
        case 9:
            self.ordstatuslb.text = @"退款失败";
            break;
        case 10:
            self.ordstatuslb.text = @"用户取消订单";
            break;
        case 11:
            self.ordstatuslb.text = @"商户取消订单";
            break;
            
        default:
            break;
    }
}

-(void)hideAllTimeview{
    self.statuslb.hidden = NO;
    self.statuslb.text = @"活动已结束";
    self.timeview.hidden = YES;
     self.timeviewone.hidden = YES;
     self.timeviewtwo.hidden = YES;
     self.timeviewthree.hidden = YES;
     self.timeviewfour.hidden = YES;
}

-(NSMutableAttributedString*)addoriginstr:(NSString*)originstr specilstr:(NSArray*)specilstrArr{
    
    NSMutableAttributedString *noteStr = [[NSMutableAttributedString alloc] initWithString:originstr];
    for (int i = 0; i < specilstrArr.count; i++) {
        NSRange rang = [originstr rangeOfString:specilstrArr[i]];
        [noteStr addAttributes:@{NSForegroundColorAttributeName:YYSRGBColor(69, 69, 69, 1)} range:rang];
        [noteStr addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18]} range:rang];
    }
    
    return noteStr;
    
}

@end
