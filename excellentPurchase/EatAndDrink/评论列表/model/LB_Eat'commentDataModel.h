//
//  LB_Eat'commentDataModel.h
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/1/19.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface LB_Eat_commentDataModel : NSObject

@property (copy , nonatomic)NSString *store_comment_id;

@property (copy , nonatomic)NSString *comment;//内容

@property (copy , nonatomic)NSString *reply;//回复

@property (copy , nonatomic)NSString *addtime;

@property (copy , nonatomic)NSString *reply_time;

@property (copy , nonatomic)NSString *mark;

@property (copy , nonatomic)NSString *nickname;

@property (copy , nonatomic)NSString *user_name;

@property (copy , nonatomic)NSString *pic;

@property (copy , nonatomic)NSString *group_name;


+(NSArray *)getIndustryModels:(NSArray *)infos;

@end
