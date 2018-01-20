//
//  GLMine_Team_AchieveManageModel.h
//  excellentPurchase
//
//  Created by 龚磊 on 2018/1/19.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GLMine_Team_AchieveManageModel : NSObject

@property (nonatomic, copy)NSString *name;//名字
@property (nonatomic, copy)NSString *IDNumber;//ID号
@property (nonatomic, copy)NSString *picName;//图片

@property (nonatomic, copy)NSString *setAchievement;//设置的绩效
@property (nonatomic, copy)NSString *done_Achieve;//已完成的绩效
@property (nonatomic, copy)NSString *setType;//是否布置:1:已布置 2:未布置

@property (nonatomic, copy)NSString *phone;//手机号
@property (nonatomic, copy)NSString *date;//日期

@property (nonatomic, copy)NSString *group_id;//身份类型

@property (nonatomic, assign)NSInteger cellType;//0:绩效管理  1:团队成员  两个地方公用一个cell

@end
