//
//  LBImprovePersonalInformationViewController.h
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/1/10.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^infomationBlock)(BOOL isRefresh);

@interface LBImprovePersonalInformationViewController : UIViewController

@property (nonatomic, copy)infomationBlock block;

@end
