//
//  GLMine_Seller_IncomeCodeController.h
//  excellentPurchase
//
//  Created by 龚磊 on 2018/1/26.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GLMine_Seller_IncomeCodeController : UIViewController

@property (nonatomic, assign)NSInteger type;//1:个人资料界面跳转过来的 2:商家收款

@property (nonatomic, copy)NSString *moneyCount;//金额
@property (nonatomic, copy)NSString *noProfitMoney;//让利金额

@end
