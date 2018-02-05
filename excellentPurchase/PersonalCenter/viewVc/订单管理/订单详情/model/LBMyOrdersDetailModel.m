//
//  LBMyOrdersDetailModel.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/2/5.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "LBMyOrdersDetailModel.h"

@implementation LBMyOrdersDetailModel

+ (NSDictionary *)mj_objectClassInArray{
    return @{ @"goods_info" : @"LBMyOrdersDetailGoodsListModel"};
}

- (void)setValue:(id)value forKey:(NSString *)key {
    
    if ([value isKindOfClass:[NSNull class]]) {
        [super setValue:@"" forKey:key];
        return;
    }
    [super setValue:value forKey:key];
}

@end

@implementation LBMyOrdersDetailGoodsListModel

@end
