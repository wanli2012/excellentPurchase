//
//  LBHomeViewActivityWaitTableViewCell.h
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/3/8.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LBHomeViewActivityListModel.h"

#define OneDolphinTimeCellNotification  @"NotificationTimeOneDolphinCell"
#define OneDolphinCellNotificationone  @"NotificationTimeOneDolphinCellone"

@interface LBHomeViewActivityWaitTableViewCell : UITableViewCell

@property (assign , nonatomic)NSInteger  timeType;//全部类型为1 待开奖为2
@property (strong , nonatomic)LBHomeViewActivityListModel *model;
//作用是只是刷新显示在屏幕上的时间
@property(nonatomic,assign)BOOL isDisplay;
@property(nonatomic,assign)BOOL isDisplayone;

- (void)setSecond:(NSString *)second row:(NSInteger) section buyingsecond:(NSString*)buyingsecond;

- (void)setSecondone:(NSString *)second row:(NSInteger) section buyingsecond:(NSString*)buyingsecond;

@end
