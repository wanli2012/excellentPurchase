//
//  LBTimeLimitHeaderView.h
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/3/2.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LBTodayTimeLimitModel.h"

#define TimeCellNotification  @"NotificationTimeCell"

@interface LBTimeLimitHeaderView : UITableViewHeaderFooterView

@property (strong , nonatomic)LBTodayBuyingTimeLimitActiveModel *buymodel;
@property (strong , nonatomic)LBTodayWatTimeLimitActiveModel *waitmodel;
@property (copy , nonatomic)void(^refreshdata)(void);
@property (assign , nonatomic)NSInteger  status;

//作用是只是刷新显示在屏幕上的时间
@property(nonatomic,assign)BOOL isDisplay;

- (void)setSecond:(NSString *)second row:(NSInteger) section buyingsecond:(NSString*)buyingsecond;

@end
