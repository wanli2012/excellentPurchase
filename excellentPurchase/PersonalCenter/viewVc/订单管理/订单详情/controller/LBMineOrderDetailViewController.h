//
//  LBMineOrderDetailViewController.h
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/1/22.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LBMineOrderDetailViewController : UIViewController

@property (assign , nonatomic)NSInteger typeindex;//1:待付款 3.待收货 5.已完成 10.已取消
@property (strong , nonatomic)NSString *ord_str;//订单
@property (strong , nonatomic)NSString *shop_uid;//商家uid

@property (copy , nonatomic)void(^refreshDatasource)(void);

@end
