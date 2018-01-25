//
//  GLMine_Branch_OfflineOrderModel.h
//  excellentPurchase
//
//  Created by 龚磊 on 2018/1/25.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GLMine_Branch_OfflineOrderModel : NSObject

@property (nonatomic, copy)NSString *orderNum;
@property (nonatomic, copy)NSString *date;
@property (nonatomic, copy)NSString *pic;
@property (nonatomic, copy)NSString *IDNum;
@property (nonatomic, copy)NSString *consume;
@property (nonatomic, copy)NSString *noPorfit;

@property (nonatomic, assign)NSInteger type;//0:审核中 1:已完成 2:已失败

@end
