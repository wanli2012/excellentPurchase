//
//  LBStoreInfoModel.h
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/2/2.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LBStoreInfoModel : NSObject

@property (copy , nonatomic)NSString *store_id;
@property (copy , nonatomic)NSString *store_name;
@property (copy , nonatomic)NSString *store_thumb;
@property (copy , nonatomic)NSArray *store_homepage;
@property (copy , nonatomic)NSString *is_collect;
@property (copy , nonatomic)NSString *fans_count;

@end
