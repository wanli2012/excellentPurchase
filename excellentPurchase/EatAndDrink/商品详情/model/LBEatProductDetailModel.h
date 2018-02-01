//
//  LBEatProductDetailModel.h
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/1/30.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
@class LBEatProductDetailOtherModel;

@interface LBEatProductDetailModel : NSObject

@property (copy , nonatomic)NSString *goods_id;
@property (copy , nonatomic)NSString *shop_id;
@property (copy , nonatomic)NSString *goods_name;
@property (copy , nonatomic)NSString *thumb;
@property (copy , nonatomic)NSString *discount;
@property (copy , nonatomic)NSString *goods_info;
@property (copy , nonatomic)NSString *store_address;
@property (copy , nonatomic)NSString *store_phone;
@property (copy , nonatomic)NSArray<LBEatProductDetailOtherModel*> *other;// 店内商品推荐
@property (copy , nonatomic)NSArray *more_pic;//轮播图

@end

@interface LBEatProductDetailOtherModel : NSObject

@property (copy , nonatomic)NSString *discount;
@property (copy , nonatomic)NSString *goods_id;
@property (copy , nonatomic)NSString *goods_info;
@property (copy , nonatomic)NSString *goods_name;
@property (copy , nonatomic)NSString *thumb;
@property (copy , nonatomic)NSString *goods_price;
@property (copy , nonatomic)NSString *shop_id;

@end
