//
//  GLMine_PayFailedView.h
//  excellentPurchase
//
//  Created by 龚磊 on 2018/1/23.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GLMine_PayFailedViewDelegate <NSObject>

- (void)backToOrder;//返回订单
- (void)goOn;//继续购物
- (void)tryAgain;//重试

@end

@interface GLMine_PayFailedView : UICollectionReusableView

@property (nonatomic, weak)id <GLMine_PayFailedViewDelegate> delegate;

@end
