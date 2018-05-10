//
//  LBPanicBuyingOdersTableViewCell.h
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/3/21.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LBPanicBuyingOdersModel.h"

#define OrderTimeCellNotification  @"NotificationTimeOrderCell"
#define OrderTimeCellNotificationone  @"NotificationTimeOrderCellone"
#define OrderTimeCellNotificationtwo  @"NotificationTimeOrderCelltwo"
#define OrderTimeCellNotificationthree  @"NotificationTimeOrderCellthree"
#define OrderTimeCellNotificationfour  @"NotificationTimeOrderCellfour"

@protocol LBPanicBuyingOdersdelegete <NSObject>

-(void)cancelOrders:(NSString*)ord_id;//取消订单
-(void)GoPayOrders:(NSIndexPath*)indexpath;//去支付
-(void)checklogistics:(NSIndexPath*)indexpath;//查看物流
-(void)sureReciveGoods:(NSIndexPath*)indexpath;//确认收货
-(void)Goevaluate:(NSIndexPath*)indexpath;//去评价
-(void)applyRefund:(NSIndexPath*)indexpath;//申请退款

@end

@interface LBPanicBuyingOdersTableViewCell : UITableViewCell

@property (assign , nonatomic)NSInteger  timeType;//全部类型为1 待付款为2
@property (strong , nonatomic)LBPanicBuyingOdersGoodsModel *model;
@property (copy , nonatomic)void(^refreshdata)(void);
@property (assign , nonatomic)id<LBPanicBuyingOdersdelegete> delegete;
@property (strong , nonatomic)NSIndexPath *indexpath;
@property (assign , nonatomic)NSInteger  jumpType;//判断是从滔滔订单还是活动订单

//作用是只是刷新显示在屏幕上的时间
@property(nonatomic,assign)BOOL isDisplay;
@property(nonatomic,assign)BOOL isDisplayone;
@property(nonatomic,assign)BOOL isDisplaytwo;
@property(nonatomic,assign)BOOL isDisplaythree;
@property(nonatomic,assign)BOOL isDisplayfour;

- (void)setSecond:(NSString *)second row:(NSInteger) section buyingsecond:(NSString*)buyingsecond;

- (void)setSecondone:(NSString *)second row:(NSInteger) section buyingsecond:(NSString*)buyingsecond;

- (void)setSecondtwo:(NSString *)second row:(NSInteger) section buyingsecond:(NSString*)buyingsecond;

- (void)setSecondthree:(NSString *)second row:(NSInteger) section buyingsecond:(NSString*)buyingsecond;

- (void)setSecondfour:(NSString *)second row:(NSInteger) section buyingsecond:(NSString*)buyingsecond;

@end
