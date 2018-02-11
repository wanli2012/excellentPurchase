//
//  GLVoucherRecordModel.h
//  excellentPurchase
//
//  Created by 龚磊 on 2018/2/6.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GLVoucherRecordModel : NSObject

@property (nonatomic, copy)NSString *money;//充值金额
@property (nonatomic, copy)NSString *type;//充值方式 1微信 2支付宝
@property (nonatomic, copy)NSString *addtime;//充值时间name
@property (nonatomic, copy)NSString *name;//充值人账号名
@property (nonatomic, copy)NSString *cname;//被充值人账号名


@end
