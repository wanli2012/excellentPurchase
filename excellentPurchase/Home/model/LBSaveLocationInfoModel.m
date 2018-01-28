//
//  LBSaveLocationInfoModel.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/1/27.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "LBSaveLocationInfoModel.h"

@implementation LBSaveLocationInfoModel

/**< 线程安全的单例创建 */
+ (LBSaveLocationInfoModel *)defaultUser {
    static LBSaveLocationInfoModel *model;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!model) {
            model = [[LBSaveLocationInfoModel alloc]init];
        }
        
    });
    
    return model;
}

@end
