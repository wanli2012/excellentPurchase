//
//  GLMine_Team_MemberModel.h
//  excellentPurchase
//
//  Created by 龚磊 on 2018/2/5.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GLMine_Team_MemberModel : NSObject

@property (nonatomic, copy)NSString *pic;//用户头像
@property (nonatomic, copy)NSString *uid;//用户uid
@property (nonatomic, copy)NSString *user_name;//成员 用户名
@property (nonatomic, copy)NSString *truename;//成员真实姓名
@property (nonatomic, copy)NSString *regtime;//用户注册时间
@property (nonatomic, copy)NSString *phone;//电话号码
@property (nonatomic, copy)NSString *del;//用户状态 0启用 1禁用
@property (nonatomic, copy)NSString *group_name;//用户等级，名称

@end
