//
//  LBHomeOneDolphinBaseViewController.h
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/3/8.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

#define isIPhoneX kScreenH==812
#define kScrollViewBeginTopInset ((UIScreenWidth - 22)/3.0  +  90 + 60 + SafeAreaTopHeight)

UIKIT_EXTERN NSNotificationName const ChildScrollViewDidScrollNSNotificationDolphin;
UIKIT_EXTERN NSNotificationName const ChildScrollViewRefreshStateNSNotificationDolphin;

@interface LBHomeOneDolphinBaseViewController : UIViewController

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, assign) CGPoint lastContentOffset;

@property (nonatomic, assign) BOOL isFirstViewLoaded;

@property (nonatomic, assign) BOOL refreshState;

@property (nonatomic, strong) UITableView *tableView;

@end
