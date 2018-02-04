//
//  GLMine_Seller_OrderDetailController.h
//  excellentPurchase
//
//  Created by 龚磊 on 2018/1/25.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GLMine_Branch_OrderModel.h"

@interface GLMine_Seller_OrderDetailController : UIViewController

@property (nonatomic, assign)NSInteger type;;//查询状态 2.待发货 3.已发货 11.已取消
@property (nonatomic, strong)GLMine_Branch_OrderModel *model;

@end
