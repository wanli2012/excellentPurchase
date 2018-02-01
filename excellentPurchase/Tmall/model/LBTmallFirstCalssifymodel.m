//
//  LBTmallFirstCalssifymodel.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/1/30.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "LBTmallFirstCalssifymodel.h"

@implementation LBTmallFirstCalssifymodel

/**< 线程安全的单例创建 */
+ (LBTmallFirstCalssifymodel *)defaultUser {
    static LBTmallFirstCalssifymodel *model;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!model) {
            model = [[LBTmallFirstCalssifymodel alloc]init];
        }
        
    });
    
    return model;
}

@end
