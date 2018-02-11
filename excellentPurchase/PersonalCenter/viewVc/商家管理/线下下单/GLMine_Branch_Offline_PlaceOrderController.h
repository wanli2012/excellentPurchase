//
//  GLMine_Branch_Offline_PlaceOrderController.h
//  excellentPurchase
//
//  Created by 龚磊 on 2018/1/25.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GLMine_Branch_OfflineOrderModel.h"

@interface GLMine_Branch_Offline_PlaceOrderController : UIViewController

@property (nonatomic, assign)NSInteger type;//1:线下下单 2:线下订单失败 重新下单

@property (nonatomic, strong)GLMine_Branch_OfflineOrderModel *model;

@end
