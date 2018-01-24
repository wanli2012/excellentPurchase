//
//  LBMineHeaderView.h
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/1/15.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LBMineHeaderViewDelegate <NSObject>

//跳转到我的资产
- (void)toMyProperty;

//切换账号
- (void)changeAccountEvent;

@end

@interface LBMineHeaderView : UIView

@property (nonatomic, weak)id <LBMineHeaderViewDelegate> delegate;

@property (nonatomic, copy)NSArray *titleArr;
@property (nonatomic, copy)NSArray *valueArr;

@end
