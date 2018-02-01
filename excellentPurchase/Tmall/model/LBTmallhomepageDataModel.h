//
//  LBTmallhomepageDataModel.h
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/1/31.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
@class LBTmallhomepageDataStructureModel;

@interface LBTmallhomepageDataModel : NSObject

@property (copy , nonatomic)NSArray<LBTmallhomepageDataStructureModel*> *groom_goods_list;//每日推荐
@property (copy , nonatomic)NSArray<LBTmallhomepageDataStructureModel*> *choice_goods_list;//精品优选

@end

@interface LBTmallhomepageDataStructureModel : NSObject

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
