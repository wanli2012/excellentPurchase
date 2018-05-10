//
//  LBMyActivityNumbersViewController.h
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/3/21.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LBDolphinRecodermodel.h"

@interface LBMyActivityNumbersViewController : UIViewController

@property (strong , nonatomic)LBDolphinRecodermodel *model;
@property (copy , nonatomic)void(^popvc)(void);

@end
