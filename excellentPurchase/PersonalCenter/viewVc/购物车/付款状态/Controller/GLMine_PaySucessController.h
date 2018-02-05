//
//  GLMine_PaySucessController.h
//  excellentPurchase
//
//  Created by 龚磊 on 2018/1/23.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GLMine_PaySucessController : UIViewController

@property (nonatomic, assign)NSInteger type;//类型:1:成功  2:失败

@property (strong , nonatomic)NSString *odernum;//订单号
@property (strong , nonatomic)NSString *method;//订单支付方式
@property (strong , nonatomic)NSString *piece;//订单金额

@end
