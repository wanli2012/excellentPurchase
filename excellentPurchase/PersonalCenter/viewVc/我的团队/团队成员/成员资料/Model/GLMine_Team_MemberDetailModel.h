//
//  GLMine_Team_MemberDetailModel.h
//  excellentPurchase
//
//  Created by 龚磊 on 2018/2/5.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GLMine_Team_MemberDetailModel : NSObject

@property (nonatomic, copy)NSString *uid;//成员uid
@property (nonatomic, copy)NSString *group_id;//用户等级
@property (nonatomic, copy)NSString *user_name;//成员 用户名
@property (nonatomic, copy)NSString *pic;//成员头像 有的用户没有头像 请设置默认头像
@property (nonatomic, copy)NSString *truename;//成员真实姓名
@property (nonatomic, copy)NSString *phone;//电话号码
@property (nonatomic, copy)NSString *tg_status;//推广员审核状态 1 通过 2审核中 3失败
@property (nonatomic, copy)NSString *province;//省ID
@property (nonatomic, copy)NSString *city;//市ID
@property (nonatomic, copy)NSString *area;//区ID
@property (nonatomic, copy)NSString *group_name;//用户等级名称
@property (nonatomic, copy)NSString *p_name;//省名
@property (nonatomic, copy)NSString *c_name;//市名
@property (nonatomic, copy)NSString *a_name;//区名

@end
