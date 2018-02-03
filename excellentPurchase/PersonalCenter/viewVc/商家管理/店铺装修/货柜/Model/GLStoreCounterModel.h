//
//  GLStoreCounterModel.h
//  excellentPurchase
//
//  Created by 龚磊 on 2018/2/3.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GLStoreCounter_goodsModel : NSObject

@property (nonatomic, copy)NSString *goods_id;//商品总条数
@property (nonatomic, copy)NSString *goods_name;//商品名
@property (nonatomic, copy)NSString *thumb;//商品图片
@property (nonatomic, copy)NSString *discount;//商品价格
@property (nonatomic, copy)NSString *goods_num;//商品库存
@property (nonatomic, copy)NSString *status;//商品上下架状态 1上架，2下架
@property (nonatomic, copy)NSString *sh_status;//商品审核状态 1审核失败 2审核成功 3未审核

@end


@interface GLStoreCounterModel : NSObject

@property (nonatomic, copy)NSString *id;//货柜id
@property (nonatomic, copy)NSString *conname;//货柜名
@property (nonatomic, copy)NSString *goodscount;//商品总数量
@property (nonatomic, copy)NSString *theshelves;//上架商品数量
@property (nonatomic, copy)NSString *offtheshelf;//下架商品数量
@property (nonatomic, copy)NSString *auditing;//审核商品数量

@end
