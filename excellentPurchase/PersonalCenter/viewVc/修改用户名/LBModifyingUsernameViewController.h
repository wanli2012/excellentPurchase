//
//  LBModifyingUsernameViewController.h
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/1/10.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^LBModifyingUsernameBlock)(NSString *name);

@interface LBModifyingUsernameViewController : UIViewController

@property (nonatomic, copy)LBModifyingUsernameBlock block;

@end
