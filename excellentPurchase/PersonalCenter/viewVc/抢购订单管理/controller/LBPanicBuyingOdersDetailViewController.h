//
//  LBPanicBuyingOdersDetailViewController.h
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/4/18.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LBPanicBuyingOdersModel.h"

@interface LBPanicBuyingOdersDetailViewController : UIViewController

@property (assign , nonatomic)NSInteger active_status;//活动类型
@property (assign , nonatomic)NSInteger typeindex;
@property (strong , nonatomic)NSString *ord_str;//订单
@property (strong , nonatomic)NSString *shop_uid;//商家uid
@property (strong , nonatomic)NSString *is_comment;
@property (copy , nonatomic)void(^refreshDatasource)(void);
@property (strong , nonatomic)LBPanicBuyingOdersModel *model;

@end
