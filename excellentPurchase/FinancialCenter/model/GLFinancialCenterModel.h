//
//  GLFinancialCenterModel.h
//  excellentPurchase
//
//  Created by 龚磊 on 2018/1/30.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GLFinancialCenterModel : NSObject

@property (nonatomic, copy)NSString *ratio;//福宝市值(福宝市值)   出售时市值(出售记录)  兑换时兑换比例(兑换记录)
@property (nonatomic, copy)NSString *addtime;//时间

@property (nonatomic, copy)NSString *ratio_max;//福宝市值最大值

@property (nonatomic, copy)NSString *back_status;//出售状态(出售记录)
@property (nonatomic, copy)NSString *really_num;//实际出售福宝数量(出售记录) 实际兑换数量(兑换记录)
@property (nonatomic, copy)NSString *sell_num;//出售福宝数量(出售记录)  兑换数量(兑换记录)

@property (nonatomic, assign)NSInteger cellType;//1:福宝市值 2:出售记录 3:兑换记录

@end
