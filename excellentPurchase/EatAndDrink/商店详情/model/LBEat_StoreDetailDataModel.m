//
//  LBEat_StoreDetailDataModel.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/1/29.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "LBEat_StoreDetailDataModel.h"

@implementation LBEat_StoreDetailDataModel

+ (NSDictionary *)mj_objectClassInArray{
    return @{ @"other" : @"LBEat_StoreDetailOtherDataModel"};
}

- (void)setValue:(id)value forKey:(NSString *)key {
  
     if ([value isKindOfClass:[NSNull class]]) {
         [super setValue:@"" forKey:key];
        return;
        }
   [super setValue:value forKey:key];
 }

@end

@implementation LBEat_StoreDetailOtherDataModel


@end
