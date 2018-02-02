//
//  GLFinishGoodsDetailModel.h
//  excellentPurchase
//
//  Created by 龚磊 on 2018/2/2.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GLFinishGoodsDetailModel : NSObject

@property (nonatomic, copy)NSString *goods_id;//商品id
@property (nonatomic, copy)NSString *goods_name;//商品名
@property (nonatomic, copy)NSString *thumb;//商品图片
@property (nonatomic, copy)NSString *discount;//商品价格
@property (nonatomic, copy)NSString *browse;//商品浏览量
@property (nonatomic, copy)NSString *salenum;//商品已付款数量
@property (nonatomic, copy)NSString *rewardspoints;//奖励积分
@property (nonatomic, copy)NSString *voucher;//奖励多少优购券

@end
