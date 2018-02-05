//
//  GLMine_TeamAchievementModel.h
//  excellentPurchase
//
//  Created by 龚磊 on 2018/1/17.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GLMine_TeamAchievementModel : NSObject

@property (nonatomic, copy)NSString *pic;//成员uid
@property (nonatomic, copy)NSString *group_id;//用户等级
@property (nonatomic, copy)NSString *uid;//成员 用户名
@property (nonatomic, copy)NSString *user_name;//成员头像
@property (nonatomic, copy)NSString *truename;//是否启用
@property (nonatomic, copy)NSString *regtime;//成员真实姓名
@property (nonatomic, copy)NSString *phone;//注册时间
@property (nonatomic, copy)NSString *del;//用户组名
@property (nonatomic, copy)NSString *group_name;//下级业绩
@property (nonatomic, copy)NSString *performance;//手机号

@end
