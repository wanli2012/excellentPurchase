//
//  LBPanicBuyingOdersModel.h
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/4/4.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
@class LBPanicBuyingOdersGoodsModel;
@class LBPanicBuyingOdersGoodsActiveModel;

@interface LBPanicBuyingOdersModel : NSObject

@property (assign , nonatomic)BOOL iselect;
@property (copy , nonatomic)NSString *store_name;
@property (copy , nonatomic)NSString *store_type;
@property (copy , nonatomic)NSString *store_id;
@property (strong , nonatomic)LBPanicBuyingOdersGoodsModel *goods_data;

@end

@interface LBPanicBuyingOdersGoodsModel : NSObject

@property (copy , nonatomic)NSString *goods_id;
@property (copy , nonatomic)NSString *goods_name;
@property (copy , nonatomic)NSString *is_comment;
@property (copy , nonatomic)NSString *ord_cancel_reason;
@property (copy , nonatomic)NSString *ord_goods_num;
@property (copy , nonatomic)NSString *goods_num;
@property (copy , nonatomic)NSString *ord_goods_price;
@property (copy , nonatomic)NSString *ord_odd_num;
@property (copy , nonatomic)NSString *ord_id;
@property (copy , nonatomic)NSString *ord_send_price;
@property (copy , nonatomic)NSString *ord_spec_info;
@property (copy , nonatomic)NSString *ord_status;
@property (copy , nonatomic)NSString *thumb;
@property (copy , nonatomic)NSString *marketprice;
@property (copy , nonatomic)NSString *store_name;
@property (copy , nonatomic)NSString *store_type;
@property (copy , nonatomic)NSString *store_phone;
@property (copy , nonatomic)NSString *store_id;
@property (copy , nonatomic)NSString *ord_shop_uid;
@property (copy , nonatomic)NSString *ord_order_num;
@property (copy , nonatomic)NSString *ord_refund_money;
@property (copy , nonatomic)NSString *ord_offset_coupons;
@property (strong , nonatomic)LBPanicBuyingOdersGoodsActiveModel *active;

@end

@interface LBPanicBuyingOdersGoodsActiveModel : NSObject

@property (copy , nonatomic)NSString *active_end_time;
@property (copy , nonatomic)NSString *active_id;
@property (copy , nonatomic)NSString *active_start_time;
@property (copy , nonatomic)NSString *active_status;
@property (copy , nonatomic)NSString *active_type;
@property (copy , nonatomic)NSString *remain_allow_count;
@property (copy , nonatomic)NSString *u_count;
@property (copy , nonatomic)NSString *time;

@end
