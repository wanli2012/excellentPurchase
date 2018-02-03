//
//  LBMineCentermodifyAdressViewController.h
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/3/30.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GLMine_AddressModel.h"

typedef void (^returnAddressBlock)(GLMine_AddressModel *adressmodel);

@interface LBMineCentermodifyAdressViewController : UIViewController

@property (nonatomic, copy)returnAddressBlock block;

@end
