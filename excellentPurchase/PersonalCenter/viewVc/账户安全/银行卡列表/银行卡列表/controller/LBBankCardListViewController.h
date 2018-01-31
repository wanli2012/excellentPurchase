//
//  LBBankCardListViewController.h
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/1/12.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GLMine_CardListModel.h"

typedef void(^cardChooseBlock)(GLMine_CardModel *model);

@interface LBBankCardListViewController : UIViewController

@property (nonatomic, assign)NSInteger pushType;//1:出售界面 跳转过来的 2:

@property (nonatomic, copy)cardChooseBlock block;

@end

