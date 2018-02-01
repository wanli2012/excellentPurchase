//
//  GLMine_Team_StaffingTabelController.h
//  excellentPurchase
//
//  Created by 龚磊 on 2018/2/1.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GLMine_Team_OpenSetModel.h"

typedef void(^GLMine_Team_StaffingTabelControllerBlock)(NSArray *arr);

@interface GLMine_Team_StaffingTabelController : UIViewController

@property (nonatomic, strong)NSMutableArray <GLMine_Team_OpenSet_subModel *>*models;

@property (nonatomic, copy)GLMine_Team_StaffingTabelControllerBlock block;

@end
