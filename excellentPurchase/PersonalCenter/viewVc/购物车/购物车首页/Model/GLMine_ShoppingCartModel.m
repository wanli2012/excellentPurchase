//
//  GLMine_ShoppingCartModel.m
//  excellentPurchase
//
//  Created by 龚磊 on 2018/1/22.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "GLMine_ShoppingCartModel.h"

@implementation GLMine_ShoppingActiveCartModel

@end

@implementation GLMine_ShoppingPropertyCartModel

/* 设置模型属性名和字典key之间的映射关系 */
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    /* 返回的字典，key为模型属性名，value为转化的字典的多级key */
    return @{
             @"specification_id" : @"id"
             };
}

@end

@implementation GLMine_ShoppingCartModel

+ (NSDictionary *)mj_objectClassInArray{
    return @{ @"goods" : @"GLMine_ShoppingPropertyCartModel"
              };
    
}

@end

@implementation GLMine_ShoppingCartDataModel

+ (NSDictionary *)mj_objectClassInArray{
    return @{ @"cart_data" : @"GLMine_ShoppingCartModel",
                    @"abate_data" : @"GLMine_ShoppingCartModel"
              };
    
}
@end

