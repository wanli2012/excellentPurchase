//
//  LBMineCenterFlyNoticeModel.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/2/7.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "LBMineCenterFlyNoticeModel.h"

@implementation LBMineCenterFlyNoticeModel

+ (NSDictionary *)mj_objectClassInArray{
    return @{ @"wl_info" : @"LBMineCenterFlyNoticeDetailModel"};
}

- (void)setValue:(id)value forKey:(NSString *)key {
    
    if ([value isKindOfClass:[NSNull class]]) {
        [super setValue:@"" forKey:key];
        return;
    }
    [super setValue:value forKey:key];
}


@end

@implementation LBMineCenterFlyNoticeDetailModel

@end
