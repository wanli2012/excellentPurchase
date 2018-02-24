//
//  LBProductDetailViewController.h
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/1/15.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^refreshDataBlock)(NSInteger index,BOOL isCollected);

@interface LBProductDetailViewController : UIViewController

@property (strong , nonatomic)NSString *goods_id;//商品id

@property (nonatomic, assign)NSInteger index;//商品下标

@property (nonatomic, copy)refreshDataBlock block;

@end
