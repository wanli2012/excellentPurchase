//
//  GLMine_Branch_AchievementController.h
//  excellentPurchase
//
//  Created by 龚磊 on 2018/1/25.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GLMine_Team_AchieveManageBaseController.h"

@interface GLMine_Branch_AchievementController : GLMine_Team_AchieveManageBaseController

@property (nonatomic, assign)NSInteger typeIndex;//1:主点的业绩查询 2:分店的业绩查询
@property (nonatomic, assign)NSInteger type;//1:线上业绩  2:线下业绩
@property (nonatomic, copy)NSString *shop_uid;

@end
