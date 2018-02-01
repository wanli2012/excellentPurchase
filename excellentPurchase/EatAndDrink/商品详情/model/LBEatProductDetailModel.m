//
//  LBEatProductDetailModel.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/1/30.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "LBEatProductDetailModel.h"

@implementation LBEatProductDetailModel

+ (NSDictionary *)mj_objectClassInArray{
    return @{ @"other" : @"LBEatProductDetailOtherModel"};
}

- (void)setValue:(id)value forKey:(NSString *)key {
    
    if ([value isKindOfClass:[NSNull class]]) {
        [super setValue:@"" forKey:key];
        return;
    }
    [super setValue:value forKey:key];
}

@end

@implementation LBEatProductDetailOtherModel



@end
