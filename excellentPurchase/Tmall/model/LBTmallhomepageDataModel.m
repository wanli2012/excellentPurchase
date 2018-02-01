//
//  LBTmallhomepageDataModel.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/1/31.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "LBTmallhomepageDataModel.h"

@implementation LBTmallhomepageDataModel

+ (NSDictionary *)mj_objectClassInArray{
    return @{ @"groom_goods_list" : @"LBTmallhomepageDataStructureModel",@"choice_goods_list" : @"LBTmallhomepageDataStructureModel"};
}

- (void)setValue:(id)value forKey:(NSString *)key {
    
    if ([value isKindOfClass:[NSNull class]]) {
        [super setValue:@"" forKey:key];
        return;
    }
    [super setValue:value forKey:key];
}

@end

@implementation LBTmallhomepageDataStructureModel


@end
