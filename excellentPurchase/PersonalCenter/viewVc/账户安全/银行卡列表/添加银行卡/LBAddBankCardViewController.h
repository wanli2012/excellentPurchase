//
//  LBAddBankCardViewController.h
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/1/12.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ReturnValueBlock) (BOOL isUnbind);

@interface LBAddBankCardViewController : UIViewController

@property(nonatomic, copy) ReturnValueBlock block;

@end
