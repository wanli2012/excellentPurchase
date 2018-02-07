//
//  LBMyOrdersDetailModel.h
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/2/5.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
@class LBMyOrdersDetailGoodsListModel;

@interface LBMyOrdersDetailModel : NSObject

@property (copy , nonatomic)NSString *address_id;
@property (copy , nonatomic)NSString *coupons;
@property (copy , nonatomic)NSString *get_address;
@property (copy , nonatomic)NSString *get_phone;
@property (copy , nonatomic)NSString *get_user;
@property (copy , nonatomic)NSString *money;
@property (copy , nonatomic)NSString *order_chinese_status;
@property (copy , nonatomic)NSString *order_num;
@property (copy , nonatomic)NSString *order_status;
@property (copy , nonatomic)NSString *remark;
@property (copy , nonatomic)NSString *reward_coupons;
@property (copy , nonatomic)NSString *reward_mark;
@property (copy , nonatomic)NSString *send_price;
@property (copy , nonatomic)NSString *shop_name;
@property (copy , nonatomic)NSString *time;
@property (copy , nonatomic)NSString *odd_num;
@property (copy , nonatomic)NSArray<LBMyOrdersDetailGoodsListModel*> *goods_info;

@end

@interface LBMyOrdersDetailGoodsListModel : NSObject

@property (copy , nonatomic)NSString *address_id;
@property (copy , nonatomic)NSString *goods_name;
@property (copy , nonatomic)NSString *ord_goods_id;
@property (copy , nonatomic)NSString *ord_goods_num;
@property (copy , nonatomic)NSString *ord_goods_price;
@property (copy , nonatomic)NSString *ord_order_id;
@property (copy , nonatomic)NSString *ord_spec_info;//规格描述
@property (copy , nonatomic)NSString *thumb;
@property (copy , nonatomic)NSString *ord_id;
@property (copy , nonatomic)NSString *is_comment;//是否已经评价 1是 0否

@end
