//
//  GLMine_TeamModel.h
//  excellentPurchase
//
//  Created by 龚磊 on 2018/2/5.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GLMine_TeamModel : NSObject

@property (nonatomic, copy)NSString *uid;//成员uid
@property (nonatomic, copy)NSString *group_id;//用户等级
@property (nonatomic, copy)NSString *user_name;//成员 用户名
@property (nonatomic, copy)NSString *truename;//成员头像 有的用户没有头像 请设置默认头像
@property (nonatomic, copy)NSString *pic;//成员真实姓名
@property (nonatomic, copy)NSString *consume;//自身消费
@property (nonatomic, copy)NSString *tj_con;//推荐用户消费
@property (nonatomic, copy)NSString *maker_con;//下属创客业绩
@property (nonatomic, copy)NSString *reg_reward;//获得奖励

@end
