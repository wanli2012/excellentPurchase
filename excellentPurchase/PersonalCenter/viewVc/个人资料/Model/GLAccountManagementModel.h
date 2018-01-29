//
//  GLAccountManagementModel.h
//  excellentPurchase
//
//  Created by 龚磊 on 2018/1/29.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GLAccountManagementModel : NSObject

@property (nonatomic, copy)NSString *pic;///头像--
@property (nonatomic, copy)NSString *user_name;//账号
@property (nonatomic, copy)NSString *truename;//真实名字
@property (nonatomic, copy)NSString *group_name;//分组名称
@property (nonatomic, copy)NSString *group_id;//分组id
@property (nonatomic, copy)NSString *tjr;//推荐人uid
@property (nonatomic, copy)NSString *tj_username;//推荐人账号
@property (nonatomic, copy)NSString *tj_nickname;//推荐人用户名


@property (nonatomic, copy)NSString *nickname;//用户名
@property (nonatomic, copy)NSString *rzstatus;//认证状态 0没有认证 1:申请实名认证 2审核通过3失败',
@property (nonatomic, copy)NSString *address;//详细地址
@property (nonatomic, copy)NSString *province;//省id
@property (nonatomic, copy)NSString *city;//市id
@property (nonatomic, copy)NSString *area;//区域id
@property (nonatomic, copy)NSString *detail_address;////所在区域

@end
