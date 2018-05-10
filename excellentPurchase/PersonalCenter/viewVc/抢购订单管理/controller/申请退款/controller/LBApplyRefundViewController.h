//
//  LBApplyRefundViewController.h
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/4/23.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LBPanicBuyingOdersModel.h"

@interface LBApplyRefundViewController : UIViewController

@property (strong , nonatomic)LBPanicBuyingOdersModel *model;
@property (copy , nonatomic)void(^refreshdata)(NSString  *ord_refund_money);

@end
