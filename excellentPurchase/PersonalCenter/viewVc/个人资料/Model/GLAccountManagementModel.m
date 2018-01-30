//
//  GLAccountManagementModel.m
//  excellentPurchase
//
//  Created by 龚磊 on 2018/1/29.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "GLAccountManagementModel.h"

@implementation GLAccountManagementModel

- (void)setValue:(id)value forKey:(NSString *)key {
    if ([value isKindOfClass:[NSNull class]]) {
        
        return;
    }
    
    [super setValue:value forKey:key];
}

@end
