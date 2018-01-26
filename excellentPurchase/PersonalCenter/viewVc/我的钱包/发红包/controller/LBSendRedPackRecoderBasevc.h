//
//  LBSendRedPackRecoderBasevc.h
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/1/11.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LBSendRedPackHeaderV.h"

#define isIPhoneX kScreenH==812
#define kScrollViewBeginTopInset 210

UIKIT_EXTERN NSNotificationName const ChildScrollViewDidScrollNSNotification;
UIKIT_EXTERN NSNotificationName const ChildScrollViewRefreshStateNSNotification;

@interface LBSendRedPackRecoderBasevc : UIViewController

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, assign) CGPoint lastContentOffset;

@property (nonatomic, assign) BOOL isFirstViewLoaded;

@property (nonatomic, assign) BOOL refreshState;

@property (nonatomic, strong) UITableView *tableView;


@end
