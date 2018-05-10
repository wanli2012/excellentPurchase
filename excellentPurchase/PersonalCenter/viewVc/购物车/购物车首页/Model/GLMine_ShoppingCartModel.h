//
//  GLMine_ShoppingCartModel.h
//  excellentPurchase
//
//  Created by 龚磊 on 2018/1/22.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

//活动属性
@interface GLMine_ShoppingActiveCartModel : NSObject

@property (copy , nonatomic)NSString *active_type;
@property (copy , nonatomic)NSString *active_id;
@property (copy , nonatomic)NSString *active_status;
@property (copy , nonatomic)NSString *active_start_time;
@property (copy , nonatomic)NSString *active_end_time;
@property (copy , nonatomic)NSString *remain_allow_count;
@property (copy , nonatomic)NSString *u_count;

@end
//商品属性
@interface GLMine_ShoppingPropertyCartModel : NSObject

@property (copy , nonatomic)NSString *specification_id;
@property (copy , nonatomic)NSString *uid;
@property (copy , nonatomic)NSString *thumb;
@property (copy , nonatomic)NSString *goods_id;
@property (copy , nonatomic)NSString *goods_name;
@property (copy , nonatomic)NSString *buy_num;
@property (copy , nonatomic)NSString *store_phone;
@property (copy , nonatomic)NSString *addtime;
@property (copy , nonatomic)NSString *goods_option_id;
@property (copy , nonatomic)NSString *store_id;
@property (copy , nonatomic)NSString *status;
@property (copy , nonatomic)NSString *title;
@property (copy , nonatomic)NSString *marketprice;
@property (copy , nonatomic)NSString *rewardspoints;
@property (copy , nonatomic)NSString *stock;
@property (copy , nonatomic)NSString *costprice;
@property (copy , nonatomic)NSString *challenge_max_count;
@property (copy , nonatomic)NSString *challenge_alowd_num;
@property (copy , nonatomic)NSString *challenge_rewardspoints;
@property (copy , nonatomic)NSString *reward_coupons;
@property (copy , nonatomic)NSString *discount;
@property (copy , nonatomic)NSString *send_price;
@property (strong , nonatomic)GLMine_ShoppingActiveCartModel *active;
@property (strong , nonatomic)GLMine_ShoppingActiveCartModel *coupons_active;
@property (assign , nonatomic)BOOL  isSelect;//是否被选中
@property (assign , nonatomic)BOOL  isEdit;//是否在编辑

@end


@interface GLMine_ShoppingCartModel : NSObject

@property (copy , nonatomic)NSString *store_id;
@property (copy , nonatomic)NSString *store_name;
@property (copy , nonatomic)NSArray<GLMine_ShoppingPropertyCartModel *> *goods;
@property (assign , nonatomic)BOOL  isSelect;

@end

@interface GLMine_ShoppingCartDataModel : NSObject

@property (nonatomic, copy)NSArray<GLMine_ShoppingCartModel *> *cart_data;//商品数组
@property (nonatomic, copy)NSArray<GLMine_ShoppingCartModel *> *abate_data;//失效商品数组

@end
