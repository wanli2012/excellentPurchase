//
//  UserModel.h
//  813DeepBreathing
//
//  Created by rimi on 15/8/13.
//  Copyright (c) 2015年 . All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserModel : NSObject<NSCoding>

@property (nonatomic, assign)BOOL needAutoLogin;

@property (nonatomic, assign)BOOL loginstatus;//登陆状态

@property (nonatomic, copy)NSString *token;
@property (nonatomic, copy)NSString *uid;
@property (nonatomic, copy)NSString *user_name;//用户ID
@property (nonatomic, copy)NSString *phone;//手机号 账号
@property (nonatomic, copy)NSString *pic;//头像
@property (nonatomic, copy)NSString *truename;//真实姓名
@property (nonatomic, copy)NSString *group_id;//用户组
@property (nonatomic, copy)NSString *group_name;//用户分组名称

@property (nonatomic, copy)NSString *im_id;//云信id
@property (nonatomic, copy)NSString *im_token;//云信token
@property (nonatomic, copy)NSString *nick_name;//用户昵称
@property (nonatomic, copy)NSString *rzstatus;//用户 认证状态 0没有认证 1:申请实名认证 2审核通过3失败
@property (nonatomic, copy)NSString *del;//用户 账号状态 0启用 1禁用
@property (nonatomic, copy)NSString *tjr_group;//推荐人分组名称
@property (nonatomic, copy)NSString *tjr_name;//推荐人分组名
@property (nonatomic, copy)NSString *mark;//用户积分
@property (nonatomic, copy)NSString *balance;//用户余额
@property (nonatomic, copy)NSString *keti_bean;//用户优购币
@property (nonatomic, copy)NSString *shopping_voucher;//用户购物券
@property (nonatomic, copy)NSString *cion_price;//优购币出售市值
@property (nonatomic, copy)NSString *voucher_ratio;//购物券兑换比例
@property (nonatomic, copy)NSString *tg_status;//创客审核状态 1 通过 2审核中 3失败
@property (nonatomic, copy)NSString *currency;//优购币单价
@property (nonatomic, copy)NSString *Total_money;//平台昨日营业额总量
@property (nonatomic, copy)NSString *Total_mark;//平台昨日新增积分总量
@property (nonatomic, copy)NSString *Total_currency;//平台昨日优购币新增
@property (nonatomic, copy)NSString *money_sum;//总收益

@property (nonatomic, copy)NSString *checkCode;//唯一校验码


+(UserModel*)defaultUser;


@end
