//
//  GLMine_Team_AccountChooseModel.h
//  excellentPurchase
//
//  Created by 龚磊 on 2018/1/18.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GLMine_Team_AccountChooseModel : NSObject

@property (nonatomic, copy)NSString *group_id;
@property (nonatomic, copy)NSString *uid;
@property (nonatomic, copy)NSString *user_name;
@property (nonatomic, copy)NSString *truename;
@property (nonatomic, copy)NSString *nickname;
@property (nonatomic, copy)NSString *group_name;

@property (nonatomic, assign)BOOL isSelected;

@end
