//
//  LBMineOrderObligationmodel.h
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/2/4.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
@class LBMineOrderObligationGoodsmodel;
@interface LBMineOrderObligationmodel : NSObject

@property (copy , nonatomic)NSString *ord_order_id;
@property (copy , nonatomic)NSString *ord_shop_uid;
@property (copy , nonatomic)NSString *shop_name;
@property (copy , nonatomic)NSString *time;
@property (copy , nonatomic)NSString *send_price;
@property (copy , nonatomic)NSString *order_price;
@property (copy , nonatomic)NSString *goods_num;
@property (copy , nonatomic)NSString *ord_odd_num;//订单号
@property (copy , nonatomic)NSString *store_thumb;
@property (copy , nonatomic)NSString *ord_cancel_reason;
@property (assign , nonatomic)BOOL iselect;//是否被选中
@property (copy , nonatomic)NSArray<LBMineOrderObligationGoodsmodel*> *goods_data;

@end

@interface LBMineOrderObligationGoodsmodel : NSObject

@property (copy , nonatomic)NSString *goods_name;
@property (copy , nonatomic)NSString *thumb;
@property (copy , nonatomic)NSString *ord_spec_info;
@property (copy , nonatomic)NSString *ord_goods_num;
@property (copy , nonatomic)NSString *ord_goods_price;
@property (copy , nonatomic)NSString *ord_id;
@property (copy , nonatomic)NSString *goods_id;
@property (copy , nonatomic)NSString *ord_order_id;
@property (copy , nonatomic)NSString *time;
@property (copy , nonatomic)NSString *ord_odd_num;//物流单号
@property (copy , nonatomic)NSString *is_comment;//是否评论 1是0否
@property (copy , nonatomic)NSString *ord_cancel_reason;//取消订单原因
@end
