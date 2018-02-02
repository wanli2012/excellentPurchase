//
//  GLFinishMainModel.h
//  excellentPurchase
//
//  Created by 龚磊 on 2018/2/2.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GLFinishMainModel : NSObject

@property (nonatomic, copy)NSString *store_id;//商铺id
@property (nonatomic, copy)NSString *store_thumb;//商铺头像
@property (nonatomic, copy)NSString *store_name;//商铺名
@property (nonatomic, copy)NSString *typename;//商铺类型
@property (nonatomic, copy)NSString *salenum;//总销售量
@property (nonatomic, copy)NSString *ct;//粉丝数量

@end
