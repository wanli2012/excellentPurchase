//
//  GLMine_Branch_OfflineOrderModel.h
//  excellentPurchase
//
//  Created by 龚磊 on 2018/1/25.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GLMine_Branch_OfflineOrderModel : NSObject

@property (nonatomic, copy)NSString *line_order_num;//订单号
@property (nonatomic, copy)NSString *time;//下单时间
@property (nonatomic, copy)NSString *line_dkpz_pic;//打款凭证
@property (nonatomic, copy)NSString *user_name;//用户名
@property (nonatomic, copy)NSString *line_money;//订单金额
@property (nonatomic, copy)NSString *line_rl_money;//奖励金额
@property (nonatomic, copy)NSString *line_fail_reason;//审核失败原因
@property (nonatomic, copy)NSString *line_id;//订单id
@property (nonatomic, copy)NSString *line_uid;//用户uid


@property (nonatomic, assign)NSInteger type;//0:审核中 1:已完成 2:已失败

@end
