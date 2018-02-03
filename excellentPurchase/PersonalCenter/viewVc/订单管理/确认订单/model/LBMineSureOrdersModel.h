//
//  LBMineSureOrdersModel.h
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/2/3.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
@class LBMineSureOrdersGoodInfoModel;

@interface LBMineSureOrdersModel : NSObject

@property (copy , nonatomic)NSArray<LBMineSureOrdersGoodInfoModel*> *goods_info;
@property (copy , nonatomic)NSString *money;//这个店铺的商品总价
@property (copy , nonatomic)NSString *offset_coupons;//可抵扣购物券
@property (copy , nonatomic)NSString *reword_coupons;//应返购物券
@property (copy , nonatomic)NSString *reword_mark;//应返积分
@property (copy , nonatomic)NSString *send_price;//运费
@property (copy , nonatomic)NSString *shop_uid;
@property (copy , nonatomic)NSString *store_name;

@end

@interface LBMineSureOrdersGoodInfoModel : NSObject

@property (copy , nonatomic)NSString *discount;//可抵扣券
@property (copy , nonatomic)NSString *goods_id;
@property (copy , nonatomic)NSString *goods_name;
@property (copy , nonatomic)NSString *goods_num;
@property (copy , nonatomic)NSString *marketprice;//单价
@property (copy , nonatomic)NSString *rewardspoints;//奖励积分
@property (copy , nonatomic)NSString *send_price;//运费
@property (copy , nonatomic)NSString *spec_id;//规格id
@property (copy , nonatomic)NSString *thumb;
@property (copy , nonatomic)NSString *title;

@end
