//
//  LBTmallProductDetailOtherModel.h
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/1/31.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LBTmallProductDetailgoodsSpecOtherModel;
@class LBTmallProductDetailgoodsSpecItemOtherModel;
@class LBTmallProductDetailgoodsCommentOtherModel;
@class LBTmallProductDetailgoodsLoveOtherModel;

@interface LBTmallProductDetailOtherModel : NSObject

@property (copy , nonatomic)NSString *goods_id;
@property (copy , nonatomic)NSString *store_id;
@property (copy , nonatomic)NSString *goods_name;
@property (copy , nonatomic)NSString *thumb;
@property (copy , nonatomic)NSArray *thumb_url;//banner图
@property (copy , nonatomic)NSString *discount;
@property (copy , nonatomic)NSString *goods_price;
@property (copy , nonatomic)NSString *goods_num;
@property (copy , nonatomic)NSString *salenum;
@property (copy , nonatomic)NSString *month_salenum;
@property (copy , nonatomic)NSString *browse;
@property (copy , nonatomic)NSString *bonuspoints;
@property (copy , nonatomic)NSString *reword_coupons;
@property (copy , nonatomic)NSString *goods_info;
@property (copy , nonatomic)NSString *addtime;
@property (copy , nonatomic)NSString *is_collect;
@property (copy , nonatomic)NSString *comment_count;
@property (copy , nonatomic)NSArray<LBTmallProductDetailgoodsSpecOtherModel*> *goods_spec;//规格
@property (copy , nonatomic)NSArray<LBTmallProductDetailgoodsCommentOtherModel*> *comment_list;//评论
@property (copy , nonatomic)NSArray<LBTmallProductDetailgoodsLoveOtherModel*> *love;//喜欢

@end

//规格
@interface LBTmallProductDetailgoodsSpecOtherModel : NSObject

@property (copy , nonatomic)NSString *idspec;
@property (copy , nonatomic)NSString *title;
@property (copy , nonatomic)NSString *stock;
@property (copy , nonatomic)NSString *marketprice;
@property (copy , nonatomic)NSString *rewardspoints;
@property (copy , nonatomic)NSString *reward_coupons;

@end

@interface LBTmallProductDetailgoodsSpecItemOtherModel : NSObject

@property (copy , nonatomic)NSString *itemid;
@property (copy , nonatomic)NSString *title;
@property (copy , nonatomic)NSString *spec_thumb;
@property (copy , nonatomic)NSString *optionid;
@property (copy , nonatomic)NSString *marketprice;
@property (copy , nonatomic)NSString *stock;
@property (copy , nonatomic)NSString *rewardspoints;
@property (copy , nonatomic)NSString *reword_coupons;

@end

@interface LBTmallProductDetailgoodsCommentOtherModel : NSObject

@property (copy , nonatomic)NSString *comment_id;
@property (copy , nonatomic)NSString *comment;
@property (copy , nonatomic)NSString *reply;
@property (copy , nonatomic)NSString *addtime;
@property (copy , nonatomic)NSString *reply_time;
@property (copy , nonatomic)NSString *mark;
@property (copy , nonatomic)NSString *ord_spec_info;
@property (copy , nonatomic)NSString *nickname;
@property (copy , nonatomic)NSString *user_name;
@property (copy , nonatomic)NSString *pic;
@property (copy , nonatomic)NSString *group_name;

@end

@interface LBTmallProductDetailgoodsLoveOtherModel : NSObject

@property (copy , nonatomic)NSString *store_id;
@property (copy , nonatomic)NSString *goods_id;
@property (copy , nonatomic)NSString *goods_name;
@property (copy , nonatomic)NSString *thumb;
@property (copy , nonatomic)NSString *discount;
@property (copy , nonatomic)NSString *bonuspoints;
@property (copy , nonatomic)NSString *salenum;
@property (copy , nonatomic)NSString *month_salenum;
@property (copy , nonatomic)NSString *browse;
@property (copy , nonatomic)NSString *channel;
@property (copy , nonatomic)NSString *is_collect;

@end
