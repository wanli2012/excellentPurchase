//
//  GLAddRecommderController.h
//  excellentPurchase
//
//  Created by 龚磊 on 2018/2/12.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^GLAddRecommderControllerBlock)(NSString *recommendID);

@interface GLAddRecommderController : UIViewController

@property (nonatomic, copy)GLAddRecommderControllerBlock block;

@end
