//
//  GLMine_ShoppingCartModel.h
//  excellentPurchase
//
//  Created by 龚磊 on 2018/1/22.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GLMine_ShoppingCartModel : NSObject

@property (nonatomic, copy)NSString *pic;//图片
@property (nonatomic, copy)NSString *goodsName;//商品名
@property (nonatomic, copy)NSString *spec;//规格
@property (nonatomic, copy)NSString *price;//价格
@property (nonatomic, copy)NSString *amount;//购物车数量
@property (nonatomic, copy)NSString *stock;//库存
@property (nonatomic, copy)NSString *jifen;//返的积分
@property (nonatomic, copy)NSString *coupon;//购物券

@property (nonatomic, assign)BOOL isSelected;//是否被选中

@property (nonatomic, assign)BOOL isDone;//是否是完成状态 yes:完成  NO:编辑状态

@end
