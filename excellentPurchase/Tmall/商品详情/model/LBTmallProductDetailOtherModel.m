//
//  LBTmallProductDetailOtherModel.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/1/31.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "LBTmallProductDetailOtherModel.h"

@implementation LBTmallProductDetailOtherModel

+ (NSDictionary *)mj_objectClassInArray{
    return @{  @"goods_spec" : @"LBTmallProductDetailgoodsSpecOtherModel",
               @"comment_list" : @"LBTmallProductDetailgoodsCommentOtherModel",
               @"love" : @"LBTmallProductDetailgoodsLoveOtherModel"
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

@implementation LBTmallProductDetailgoodsSpecOtherModel

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    if([key isEqualToString:@"id"]){
        self.idspec = value;
   }
}

- (void)setValue:(id)value forKey:(NSString *)key {
    
    if ([value isKindOfClass:[NSNull class]]) {
        [super setValue:@"" forKey:key];
        return;
    }
    [super setValue:value forKey:key];
}

@end

@implementation LBTmallProductDetailgoodsSpecItemOtherModel

@end

@implementation LBTmallProductDetailgoodsCommentOtherModel

@end

@implementation LBTmallProductDetailgoodsLoveOtherModel

@end

