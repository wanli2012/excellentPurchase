//
//  LBMineOrderObligationmodel.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/2/4.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "LBMineOrderObligationmodel.h"

@implementation LBMineOrderObligationmodel

+ (NSDictionary *)mj_objectClassInArray{
    return @{ @"goods_data" : @"LBMineOrderObligationGoodsmodel"};
}

- (void)setValue:(id)value forKey:(NSString *)key {
    
    if ([value isKindOfClass:[NSNull class]]) {
        [super setValue:@"" forKey:key];
        return;
    }
    [super setValue:value forKey:key];
}

@end
@implementation LBMineOrderObligationGoodsmodel

@end
