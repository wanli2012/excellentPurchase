//
//  LBTimeLimitQinggouTableViewCell.h
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/3/2.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LBTodayTimeLimitModel.h"

@interface LBTimeLimitQinggouTableViewCell : UITableViewCell

@property (strong , nonatomic)LBTodayTimeLimitActiveModel *model;
@property (copy , nonatomic)void(^refreshdata)(void);

@end
