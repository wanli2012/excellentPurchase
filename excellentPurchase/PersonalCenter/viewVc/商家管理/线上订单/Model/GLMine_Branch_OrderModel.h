//
//  GLMine_Branch_OrderModel.h
//  excellentPurchase
//
//  Created by 龚磊 on 2018/2/4.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GLMine_Branch_Order_goodsModel : NSObject

@property (nonatomic, copy)NSString *goods_name;////商品名字
@property (nonatomic, copy)NSString *thumb;//商品图片
@property (nonatomic, copy)NSString *ord_spec_info;//规格描述
@property (nonatomic, copy)NSString *ord_id;//子订单id
@property (nonatomic, copy)NSString *ord_goods_num;//商品数量
@property (nonatomic, copy)NSString *ord_goods_price;//单价
@property (nonatomic, copy)NSString *ord_status;//子订单状态
@property (nonatomic, copy)NSString *ord_offset_coupons;//可抵扣购物券
@property (nonatomic, copy)NSString *ord_send_price;//运费
@property (nonatomic, copy)NSString *ord_odd_num; //物流单号    没有就为空字符串
@property (nonatomic, copy)NSString *ord_wl_company;//物流公司  没有就为空字符串
@property (nonatomic, copy)NSString *ord_cancel_reason;//商户取消订单原因

@end

@interface GLMine_Branch_OrderModel : NSObject

@property (nonatomic, copy)NSString *ord_order_id;////主订单id
@property (nonatomic, copy)NSString *time;//下单时间
@property (nonatomic, copy)NSString *order_num;//订单编号
@property (nonatomic, copy)NSString *goods_num;//商品总数量
@property (nonatomic, copy)NSString *remark;//订单备注
@property (nonatomic, copy)NSString *order_money;//订单总金额
@property (nonatomic, copy)NSString *send_price; //运费
@property (nonatomic, copy)NSString *offset_coupons;//总抵扣的购物券
@property (nonatomic, copy)NSString *get_user;//收货人名字
@property (nonatomic, copy)NSString *get_phone;//收货人电话
@property (nonatomic, copy)NSString *get_address;//收货地址ord_odd_num
@property (nonatomic, copy)NSString *ord_odd_num;//物流单号    没有就为空字符串

@property (nonatomic, copy)NSArray<GLMine_Branch_Order_goodsModel *> *goods_data;


@end
