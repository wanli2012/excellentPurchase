//
//  LBEat_StoreDetailDataModel.h
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/1/29.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
@class LBEat_StoreDetailOtherDataModel;

@interface LBEat_StoreDetailDataModel : NSObject

@property (copy , nonatomic)NSString *is_collect;//是否收藏
@property (copy , nonatomic)NSString *store_address;
@property (copy , nonatomic)NSString *store_id;
@property (copy , nonatomic)NSString *lat;
@property (copy , nonatomic)NSString *lng;
@property (copy , nonatomic)NSString *store_name;//店名
@property (copy , nonatomic)NSString *store_phone;//手机号
@property (copy , nonatomic)NSString *store_score;//分数
@property (copy , nonatomic)NSString *store_thumb;// 商店图片
@property (copy , nonatomic)NSString *store_comment_count;//评论数
@property (copy , nonatomic)NSArray<LBEat_StoreDetailOtherDataModel*> *other;// 店内商品推荐
@property (copy , nonatomic)NSArray *store_pic;//轮播图

@end

@interface LBEat_StoreDetailOtherDataModel : NSObject

@property (copy , nonatomic)NSString *discount;
@property (copy , nonatomic)NSString *goods_id;
@property (copy , nonatomic)NSString *goods_info;
@property (copy , nonatomic)NSString *goods_name;
@property (copy , nonatomic)NSString *thumb;

@end
