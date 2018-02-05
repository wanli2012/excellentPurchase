//
//  GLMine_Branch_Achievement.h
//  excellentPurchase
//
//  Created by 龚磊 on 2018/1/25.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GLMine_Branch_AchievementModel : NSObject

@property (nonatomic, copy)NSString *line_order_num;//订单号
@property (nonatomic, copy)NSString *line_addtime;//下单时间
@property (nonatomic, copy)NSString *line_dkpz_pic;//图片
@property (nonatomic, copy)NSString *line_money;//总价
@property (nonatomic, copy)NSString *line_updatetime;//立返时间

@property (nonatomic, assign)NSInteger type;//1:线上业绩 2:线下业绩

@property (nonatomic, copy)NSString *ord_remark;//订单备注
@property (nonatomic, copy)NSString *order_num;//商品订单号
@property (nonatomic, copy)NSString *ord_suretime;//交易成功实践
@property (nonatomic, copy)NSString *price;//总金
@property (nonatomic, copy)NSString *thumb;//订单商品展示图片


@end
