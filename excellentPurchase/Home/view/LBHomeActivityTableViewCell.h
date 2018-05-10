//
//  LBHomeActivityTableViewCell.h
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/4/20.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LBTodayTimeLimitModel.h"

@interface LBHomeActivityTableViewCell : UITableViewCell

@property (strong , nonatomic)LBTodayBuyingListTimeLimitActiveModel *model;
@property (weak, nonatomic) IBOutlet UILabel *timelb;
@property (copy , nonatomic)void(^rightnowBuy)(NSString *good_id);
@property (copy , nonatomic)void(^refreshData)(void);

@end
