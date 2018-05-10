//
//  LBHomeViewActivityHeaderView.h
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/3/8.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LBHomeViewActivityHistoryModel.h"

@interface LBHomeViewActivityHeaderView : UIView

@property (strong , nonatomic)NSArray<LBHomeViewActivityHistoryModel*> *dataArr;
@property (copy , nonatomic)void(^jumpactivitydetail)(LBHomeViewActivityHistoryModel *model);

@end
