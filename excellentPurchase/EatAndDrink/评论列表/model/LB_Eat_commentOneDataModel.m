//
//  LB_Eat_commentOneDataModel.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/1/19.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "LB_Eat_commentOneDataModel.h"

@implementation LB_Eat_commentOneDataModel

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    //    if([key isEqualToString:@"id"]){
    //        _ID = value;
    //    }
}
-(instancetype)initWithDict:(NSDictionary *)dict{
    if (self = [super init]) {
        //kvc赋值
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

+(instancetype)getIndustryWithDict:(NSDictionary *)dict{
    return [[self alloc]initWithDict:dict];
}

+(NSArray *)getIndustryModels:(NSArray *)infos{
    NSMutableArray *dataArr = [@[]mutableCopy];
    [infos enumerateObjectsUsingBlock:^(NSDictionary*  _Nonnull dict, NSUInteger idx, BOOL * _Nonnull stop) {
        LB_Eat_commentOneDataModel *model = [LB_Eat_commentOneDataModel getIndustryWithDict:dict];
        [dataArr addObject:model];
        
    }];
    return [dataArr mutableCopy];
}

@end
