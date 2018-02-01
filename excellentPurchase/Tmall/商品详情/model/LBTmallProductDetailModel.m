//
//  LBTmallProductDetailModel.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/1/31.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "LBTmallProductDetailModel.h"

@implementation LBTmallProductDetailModel

+ (NSDictionary *)mj_objectClassInArray{
    return @{
                     @"comment_list" : @"LBTmallProductDetailgoodsCommentModel",
                     @"love" : @"LBTmallProductDetailgoodsLoveModel"
              };
}

- (void)setValue:(id)value forKey:(NSString *)key {
    
    if ([value isKindOfClass:[NSNull class]]) {
        [super setValue:@"" forKey:key];
        return;
    }
    [super setValue:value forKey:key];
}

@end

@implementation LBTmallProductDetailgoodsSpecModel

+ (NSDictionary *)mj_objectClassInArray{
    return @{  @"items" : @"LBTmallProductDetailgoodsSpecItemModel"
               };
}

- (void)setValue:(id)value forKey:(NSString *)key {
    
    if ([value isKindOfClass:[NSNull class]]) {
        [super setValue:@"" forKey:key];
        return;
    }
    [super setValue:value forKey:key];
}

@end

@implementation LBTmallProductDetailgoodsSpecItemModel

@end

@implementation LBTmallProductDetailgoodsCommentModel

@end

@implementation LBTmallProductDetailgoodsLoveModel

@end

@implementation LBTmallProductDetailgoodsSpecOtherModel

@end
