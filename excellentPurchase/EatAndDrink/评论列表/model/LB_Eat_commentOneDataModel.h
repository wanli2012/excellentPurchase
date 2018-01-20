//
//  LB_Eat_commentOneDataModel.h
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/1/19.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LB_Eat_commentOneDataModel : NSObject

@property (copy , nonatomic)NSString *name;

@property (copy , nonatomic)NSString *replyname;

@property (copy , nonatomic)NSString *content;

+(NSArray *)getIndustryModels:(NSArray *)infos;

@end
