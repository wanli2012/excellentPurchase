//
//  GLStoreCounterListModel.h
//  excellentPurchase
//
//  Created by 龚磊 on 2018/2/2.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GLStoreCounterListModel : NSObject

@property (nonatomic, copy)NSString *id;//货柜id
@property (nonatomic, copy)NSString *conname;//货柜名称
@property (nonatomic, copy)NSString *point;//货柜已有商品数量

@end
