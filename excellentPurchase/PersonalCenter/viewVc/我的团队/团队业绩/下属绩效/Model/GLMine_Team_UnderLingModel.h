//
//  GLMine_Team_UnderLingModel.h
//  excellentPurchase
//
//  Created by 龚磊 on 2018/2/5.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GLMine_TeamUnderLing_teamModel : NSObject

@property (nonatomic, copy)NSString *uid;//成员uid
@property (nonatomic, copy)NSString *group_id;//用户等级
@property (nonatomic, copy)NSString *user_name;//成员 用户名
@property (nonatomic, copy)NSString *truename;//成员真实姓名
@property (nonatomic, copy)NSString *pic;//成员头像
@property (nonatomic, copy)NSString *consume;//自身本月消费
@property (nonatomic, copy)NSString *tj_con;//推荐用户消费
@property (nonatomic, copy)NSString *maker_con;//下属业绩
@property (nonatomic, copy)NSString *reg_reward;//获得奖励

@end

@interface GLMine_TeamUnderLing_data_upModel : NSObject

@property (nonatomic, copy)NSString *uid;//成员uid
@property (nonatomic, copy)NSString *group_id;//用户等级
@property (nonatomic, copy)NSString *user_name;//成员 用户名
@property (nonatomic, copy)NSString *truename;//成员真实姓名
@property (nonatomic, copy)NSString *phone;//手机号
@property (nonatomic, copy)NSString *pic;//成员头像
@property (nonatomic, copy)NSString *del;//是否启用
@property (nonatomic, copy)NSString *regtime;//注册时间
@property (nonatomic, copy)NSString *group_name;//用户组名
@property (nonatomic, copy)NSString *performance;//本身业绩

@end

@interface GLMine_Team_UnderLingModel : NSObject

@property (nonatomic, strong)GLMine_TeamUnderLing_teamModel *team_performancer;
@property (nonatomic, strong)NSArray <GLMine_TeamUnderLing_data_upModel *> *data_up;

@end
