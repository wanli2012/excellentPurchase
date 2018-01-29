//
//  GLHomeModel.m
//  excellentPurchase
//
//  Created by 龚磊 on 2018/1/29.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "GLHomeModel.h"

@implementation GLHome_bannerModel

@end

@implementation GLHome_newsModel


@end

@implementation GLHome_ordersModel


@end

@implementation GLHomeModel

+ (NSDictionary *)mj_objectClassInArray{
    
    return @{ @"banner" : @"GLHome_bannerModel",
              @"news" : @"GLHome_newsModel",
              @"orders":@"GLHome_ordersModel"
              };
}

@end
