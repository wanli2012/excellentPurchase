//
//  LBCollectionManager.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/1/24.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "LBCollectionManager.h"

@implementation LBCollectionManager

+ (LBCollectionManager *)defaultUser {
    static LBCollectionManager *model;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{

        if (!model) {
            model = [[LBCollectionManager alloc]init];
        }
        
    });
    
    return model;
}

@end
