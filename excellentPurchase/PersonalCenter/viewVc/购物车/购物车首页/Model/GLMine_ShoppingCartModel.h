//
//  GLMine_ShoppingCartModel.h
//  excellentPurchase
//
//  Created by 龚磊 on 2018/1/22.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GLMine_ShoppingCartModel : NSObject

@property (nonatomic, copy)NSString *id;//购物车ID
@property (nonatomic, copy)NSString *uid;//用户ID
@property (nonatomic, copy)NSString *goods_id;//商品ID
@property (nonatomic, copy)NSString *goods_name;//商品名称
@property (nonatomic, copy)NSString *thumb;//商品展示图
@property (nonatomic, copy)NSString *buy_num;//数量
@property (nonatomic, copy)NSString *addtime;//加入购物车时间
@property (nonatomic, copy)NSString *goods_option_id;//规格ID
@property (nonatomic, copy)NSString *store_id;//店铺ID
@property (nonatomic, copy)NSString *title;//规格名称
@property (nonatomic, copy)NSString *marketprice;//销售价格
@property (nonatomic, copy)NSString *rewardspoints;//获得积分
@property (nonatomic, copy)NSString *reward_coupons;//获得购物券
@property (nonatomic, copy)NSString *one_title;//规格名名称
@property (nonatomic, copy)NSString *two_title;//规格项名称
@property (nonatomic, copy)NSString *stock;//库存


@property (nonatomic, assign)BOOL isSelected;//是否被选中
@property (nonatomic, assign)BOOL isEdit;//是否是完成状态 NO:完成  YES:编辑状态
@property (nonatomic, assign)NSInteger index;//cell下标
@property (nonatomic, assign)NSInteger section;//组 下标

@property (nonatomic, assign)BOOL isDel;//删除标志

@end

@interface GLMine_ShoppingCartDataModel : NSObject

@property (nonatomic, copy)NSString *store_name;//商店名
@property (nonatomic, copy)NSString *store_id;//商店id
@property (nonatomic, copy)NSArray<GLMine_ShoppingCartModel *> *goods;//商品数组

@property (nonatomic, assign)BOOL shopIsSelected;//是否被选中

@property (nonatomic, assign)NSInteger shopSection;//header下标

@end
