//
//  GLAddOrEditProductCateModel.m
//  excellentPurchase
//
//  Created by 龚磊 on 2018/2/2.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "GLAddOrEditProductCateModel.h"

@implementation GLAddOrEditProductCate_brandModel

@end

@implementation GLAddOrEditProductCate_labeModel

@end

@implementation GLAddOrEditProductCate_attrModel

@end

@implementation GLAddOrEditProductCateModel

+ (NSDictionary *)mj_objectClassInArray{
    
    
    return @{ @"brand" : @"GLAddOrEditProductCate_brandModel",
              @"labe" : @"GLAddOrEditProductCate_labeModel",
              @"attr" : @"GLAddOrEditProductCate_attrModel"
              };
}

@end
