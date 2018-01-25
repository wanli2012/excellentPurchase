//
//  GLMine_Branch_OnlineHeader.h
//  excellentPurchase
//
//  Created by 龚磊 on 2018/1/25.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GLMine_Branch_OnlineHeaderDelegate <NSObject>

- (void)toOrderDetail:(NSInteger)section;

@end

@interface GLMine_Branch_OnlineHeader :UITableViewHeaderFooterView

@property (nonatomic, weak)id <GLMine_Branch_OnlineHeaderDelegate> delegate;

@property (nonatomic, assign)NSInteger section;

@end
