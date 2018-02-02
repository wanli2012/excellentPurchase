//
//  LBAddOrEditProductViewController.h
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/1/25.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LBAddOrEditProductViewController : UIViewController

@property (nonatomic, assign)NSInteger type;//1线上商品/海淘商城 2线下商品/吃喝玩乐

@property (nonatomic, copy)NSString *store_id;

@end
