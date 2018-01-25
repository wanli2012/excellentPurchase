//
//  GLMine_Branch_Achievement.h
//  excellentPurchase
//
//  Created by 龚磊 on 2018/1/25.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GLMine_Branch_AchievementModel : NSObject

@property (nonatomic, copy)NSString *orderNum;//订单号
@property (nonatomic, copy)NSString *date;//下单时间
@property (nonatomic, copy)NSString *pic;//图片
@property (nonatomic, copy)NSString *price;//总价
@property (nonatomic, copy)NSString *remark;//备注
@property (nonatomic, copy)NSString *submitDate;//提单时间

@property (nonatomic, assign)NSInteger type;//1:线上业绩 0:线下业绩


@end
