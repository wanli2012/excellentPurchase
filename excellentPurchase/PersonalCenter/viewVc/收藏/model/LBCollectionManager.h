//
//  LBCollectionManager.h
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/1/24.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LBCollectionManager : NSObject

@property (assign , nonatomic)NSInteger index;// 0 代表没有编辑 1 代表编辑

@property (assign , nonatomic)NSInteger storeType;// 2海淘商城店铺 3吃喝玩乐店铺

+(LBCollectionManager*)defaultUser;

@end
