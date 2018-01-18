//
//  GLMine_Team_AchieveManageBaseController.h
//  excellentPurchase
//
//  Created by 龚磊 on 2018/1/17.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

#define isIPhoneX kScreenH==812
//#define kGLMine_TeamScrollViewBeginTopInset 300

UIKIT_EXTERN NSNotificationName const GLMine_Team_ChildScrollViewDidScrollNSNotification;
UIKIT_EXTERN NSNotificationName const GLMine_Team_ChildScrollViewRefreshStateNSNotification;


@interface GLMine_Team_AchieveManageBaseController : UIViewController

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, assign) CGPoint lastContentOffset;

@property (nonatomic, assign) BOOL isFirstViewLoaded;

@property (nonatomic, assign) BOOL refreshState;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, assign)NSInteger scrollViewBeginTopInset;

@end
