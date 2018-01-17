//
//  GLIdentifySelectController.h
//  excellentPurchase
//
//  Created by 龚磊 on 2018/1/17.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^selectIDBlock)(NSString *name,NSString *group_id);

@interface GLIdentifySelectController : UIViewController

@property (nonatomic, copy)selectIDBlock block;

@property (nonatomic, assign)NSInteger selectIndex;

@end
