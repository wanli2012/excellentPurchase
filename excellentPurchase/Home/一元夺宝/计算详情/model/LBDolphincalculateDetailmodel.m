//
//  LBDolphincalculateDetailmodel.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/5/9.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "LBDolphincalculateDetailmodel.h"

@implementation LBDolphincalculateDetailmodel

+ (NSDictionary *)mj_objectClassInArray{
    return @{
               @"page_data" : @"LBDolphincalculateDetailListmodel",
             };
}

- (void)setValue:(id)value forKey:(NSString *)key {
    
    if ([value isKindOfClass:[NSNull class]]) {
        [super setValue:@"" forKey:key];
        return;
    }
    [super setValue:value forKey:key];
}
    
    
@end

@implementation LBDolphincalculateDetailListmodel

@end
