//
//  LBFinancialCenterBaseViewController.h
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/1/20.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

#define isIPhoneX kScreenH==812
#define kScrollViewBeginTopInset (196 + 60 + SafeAreaTopHeight)

UIKIT_EXTERN NSNotificationName const ChildScrollViewDidScrollNSNotificationFinancial;
UIKIT_EXTERN NSNotificationName const ChildScrollViewRefreshStateNSNotificationFinancial;

@interface LBFinancialCenterBaseViewController : UIViewController

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, assign) CGPoint lastContentOffset;

@property (nonatomic, assign) BOOL isFirstViewLoaded;

@property (nonatomic, assign) BOOL refreshState;

@property (nonatomic, strong) UITableView *tableView;

@end
