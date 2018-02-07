//
//  LBEat_StoreCommentsViewController.h
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/1/19.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LBEat_StoreCommentsViewController : UIViewController

@property (strong , nonatomic)NSString *store_id;

@property (assign , nonatomic)NSInteger isstore;//判断是否是商家跳过去 1为商家 0为用户

@end
