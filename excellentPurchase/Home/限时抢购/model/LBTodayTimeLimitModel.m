//
//  LBTodayTimeLimitModel.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/3/28.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "LBTodayTimeLimitModel.h"

@implementation LBTodayTimeLimitModel

+ (NSDictionary *)mj_objectClassInArray{
    return @{ @"wait" : @"LBTodayWatTimeLimitActiveModel"};
}

- (void)setValue:(id)value forKey:(NSString *)key {
    
    if ([value isKindOfClass:[NSNull class]]) {
        [super setValue:@"" forKey:key];
        return;
    }
    [super setValue:value forKey:key];
}

@end

@implementation LBTodayTimeLimitActiveModel

@end

@implementation LBTodayBuyingTimeLimitActiveModel

+ (NSDictionary *)mj_objectClassInArray{
    return @{ @"data" : @"LBTodayBuyingListTimeLimitActiveModel"};
}

-(void)setValue:(id)value forKey:(NSString *)key{
    [super setValue:value forKey:key];
    self.cellType = LBTodayTimeLimitCellTypeBeing;
}

@end

@implementation LBTodayWatTimeLimitActiveModel

+ (NSDictionary *)mj_objectClassInArray{
    return @{ @"active" : @"LBTodayTimeLimitActiveModel"};
}

-(void)setValue:(id)value forKey:(NSString *)key{
    [super setValue:value forKey:key];
    self.cellType = LBTodayTimeLimitCellTypeWating;
}

@end

@implementation LBTodayBuyingListTimeLimitActiveModel



@end
