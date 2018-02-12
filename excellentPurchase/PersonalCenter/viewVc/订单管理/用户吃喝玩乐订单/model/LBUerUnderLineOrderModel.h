//
//  LBUerUnderLineOrderModel.h
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/2/4.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LBUerUnderLineOrderModel : NSObject

@property (copy , nonatomic)NSString *face_order_num;
@property (copy , nonatomic)NSString *face_money;
@property (copy , nonatomic)NSString *face_addtime;
@property (copy , nonatomic)NSString *face_back_mark;
@property (copy , nonatomic)NSString *face_back_coupons;
@property (copy , nonatomic)NSString *face_id;//订单id
@property (copy , nonatomic)NSString *face_shop_uid;//店铺uid
@property (copy , nonatomic)NSString *store_name;//店铺名称
@property (copy , nonatomic)NSString *store_thumb;//店铺头像
@property (copy , nonatomic)NSString *is_comment;//是否评论
@property (copy , nonatomic)NSString *face_order_code;//1面对面订单 2线下订单

@end
