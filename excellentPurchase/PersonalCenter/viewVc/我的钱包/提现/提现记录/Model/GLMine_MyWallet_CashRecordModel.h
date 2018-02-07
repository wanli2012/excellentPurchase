//
//  GLMine_MyWallet_CashRecordModel.h
//  excellentPurchase
//
//  Created by 龚磊 on 2018/2/6.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GLMine_MyWallet_CashRecordModel : NSObject

@property (nonatomic, copy)NSString * id;//提现id
@property (nonatomic, copy)NSString * money;//提现金额
@property (nonatomic, copy)NSString * type;//提现状态 1提现中 2提现失败 3提现成功
@property (nonatomic, copy)NSString * reason;//提现失败原因
@property (nonatomic, copy)NSString * addtime;//提现时间
@property (nonatomic, copy)NSString * bank_name;//提现银行
@property (nonatomic, copy)NSString * banknumber;//提现银行卡号

@end
