//
//  GLMine_Team_OpenSetModel.h
//  excellentPurchase
//
//  Created by 龚磊 on 2018/2/1.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GLMine_Team_OpenSet_subModel : NSObject

@property (nonatomic, copy)NSString *group_id;//身份id
@property (nonatomic, copy)NSString *name;//身份名
@property (nonatomic, copy)NSString *msg;//提示消息

@property (nonatomic, assign)NSInteger personNum;//设置的人数

@end

@interface GLMine_Team_OpenSetModel : NSObject

@property (nonatomic, copy)NSArray <GLMine_Team_OpenSet_subModel *> *sub;
@property (nonatomic, copy)NSArray <GLMine_Team_OpenSet_subModel *> *setup;

@end
