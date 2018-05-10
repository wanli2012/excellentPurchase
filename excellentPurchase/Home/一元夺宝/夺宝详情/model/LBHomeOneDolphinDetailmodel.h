//
//  LBHomeOneDolphinDetailmodel.h
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/5/5.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
@class LBindianastartmodel;
@class LBindianawait_rewardmodel;
@class LBindianafinishedmodel;
@class LBindianaproudmodel;

@interface LBHomeOneDolphinDetailmodel : NSObject

@property (copy , nonatomic)NSString *indiana_share_url;
@property (copy , nonatomic)NSString *indiana_id;
@property (copy , nonatomic)NSString *indiana_goods_key;
@property (copy , nonatomic)NSString *indiana_number;
@property (copy , nonatomic)NSString *indiana_goods_id;
@property (copy , nonatomic)NSString *indiana_reward_count;
@property (copy , nonatomic)NSString *indiana_remainder_count;
@property (copy , nonatomic)NSString *indiana_status;
@property (copy , nonatomic)NSString *indiana_everyone_max_count;
@property (copy , nonatomic)NSString *indiana_everyone_min_count;
@property (copy , nonatomic)NSString *indiana_goods_name;
@property (copy , nonatomic)NSArray *indiana_goods_thumb;
@property (strong , nonatomic)LBindianastartmodel *start;
@property (strong , nonatomic)LBindianawait_rewardmodel *wait_reward;
@property (strong , nonatomic)LBindianafinishedmodel *finished;
@property (copy , nonatomic)NSArray *rule;
@property (strong , nonatomic)LBindianaproudmodel *proud;
@property (strong , nonatomic)LBindianaproudmodel *sofa;
@property (strong , nonatomic)LBindianaproudmodel *tail;

@end

@interface LBindianastartmodel : NSObject

@property (copy , nonatomic)NSString *buy_count;
@property (copy , nonatomic)NSArray *lucky_number;

@end

@interface LBindianawait_rewardmodel : NSObject

@property (copy , nonatomic)NSString *reward_time;
@property (copy , nonatomic)NSString *buy_count;
@property (copy , nonatomic)NSString *reward_rule_thumb;
@property (copy , nonatomic)NSArray *lucky_number;

@end

@interface LBindianafinishedmodel : NSObject

@property (copy , nonatomic)NSString *pic;
@property (copy , nonatomic)NSString *reward_nick_name;
@property (copy , nonatomic)NSString *reward_user_name;
@property (copy , nonatomic)NSString *reward_time;
@property (copy , nonatomic)NSString *reward_lucky_number;
@property (copy , nonatomic)NSString *reward_rule_thumb;
@property (copy , nonatomic)NSString *reward_buy_count;

@end

@interface LBindianaproudmodel : NSObject

@property (copy , nonatomic)NSString *head_pic;
@property (copy , nonatomic)NSString *nickname;
@property (copy , nonatomic)NSString *info;

@end

