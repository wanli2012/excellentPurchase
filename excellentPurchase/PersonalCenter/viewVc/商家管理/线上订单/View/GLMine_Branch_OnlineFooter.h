//
//  GLMine_Branch_OnlineFooter.h
//  excellentPurchase
//
//  Created by 龚磊 on 2018/1/25.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GLMine_Branch_OnlineFooterDelegate <NSObject>

@optional
/**
 确认订单
 */
- (void)ensureOrder:(NSInteger)section;
/**
 取消订单
 */
- (void)cancelOrder:(NSInteger)section;
/**
 确认发货
 */
- (void)ensureDelivery:(NSInteger)section;

@end

@interface GLMine_Branch_OnlineFooter : UITableViewHeaderFooterView

@property (nonatomic, strong)UIButton *rightBtn;//右按钮
@property (nonatomic, strong)UIButton *leftBtn;//左按钮

@property (nonatomic, weak)id <GLMine_Branch_OnlineFooterDelegate>delegate;

@property (nonatomic, assign)NSInteger section;

@end
