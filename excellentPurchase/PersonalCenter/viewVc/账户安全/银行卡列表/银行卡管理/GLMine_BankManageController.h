//
//  GLMine_BankManageController.h
//  excellentPurchase
//
//  Created by 龚磊 on 2018/1/27.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ReturnValueBlock) (BOOL isUnbind);
@interface GLMine_BankManageController : UIViewController

@property (nonatomic, copy)NSString *endNum;//银行卡尾数
@property (nonatomic, copy)NSString *bank_id;//银行卡id

@property(nonatomic, copy) ReturnValueBlock block;

@end
