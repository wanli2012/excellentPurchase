//
//  LBEat_StoreDetailViewController.h
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/1/18.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LBEat_StoreDetailViewController : UIViewController

@property (strong , nonatomic)NSString *store_id;
@property (strong , nonatomic)NSString *titilestr;
@property (assign , nonatomic)BOOL  isSelf;//是否是自己店里跳转过来
@end
