//
//  NSString+LBNullOrEmpty.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/1/29.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "NSString+LBNullOrEmpty.h"

@implementation NSString (LBNullOrEmpty)

+ (BOOL)StringIsNullOrEmpty:(NSString *)str
{
    return (str == nil || [str isKindOfClass:[NSNull class]] || str.length == 0);
}

@end
