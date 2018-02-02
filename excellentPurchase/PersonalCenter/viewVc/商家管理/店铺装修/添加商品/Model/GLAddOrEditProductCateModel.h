//
//  GLAddOrEditProductCateModel.h
//  excellentPurchase
//
//  Created by 龚磊 on 2018/2/2.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GLAddOrEditProductCate_brandModel : NSObject

@property (nonatomic, copy)NSString *brand_id;
@property (nonatomic, copy)NSString *brand_name;
@property (nonatomic, copy)NSString *brand_img;

@property (nonatomic, assign)BOOL isSelected;

@end

@interface GLAddOrEditProductCate_labeModel : NSObject

@property (nonatomic, copy)NSString *label_id;
@property (nonatomic, copy)NSString *label_name;

@property (nonatomic, assign)BOOL isSelected;

@end

@interface GLAddOrEditProductCate_attrModel : NSObject

@property (nonatomic, copy)NSString *attr_id;
@property (nonatomic, copy)NSString *attr_info;

@property (nonatomic, assign)BOOL isSelected;

@end

@interface GLAddOrEditProductCateModel : NSObject

@property (nonatomic, copy)NSArray <GLAddOrEditProductCate_brandModel *>*brand;//品牌
@property (nonatomic, copy)NSArray <GLAddOrEditProductCate_labeModel *>*labe;//标签
@property (nonatomic, copy)NSArray <GLAddOrEditProductCate_attrModel *>*attr;//属性

@end
