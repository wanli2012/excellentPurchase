//
//  LBEat_cateModel.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/1/28.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "LBEat_cateModel.h"

@implementation LBEat_cateModel

/**< 线程安全的单例创建 */
+ (LBEat_cateModel *)defaultUser {
    static LBEat_cateModel *model;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!model) {
            model = [[LBEat_cateModel alloc]init];
        }
        
    });
    
    return model;
}

@end
