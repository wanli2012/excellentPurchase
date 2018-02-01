//
//  LBTmallProductListModel.h
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/1/31.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LBTmallProductListModel : NSObject

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
