//
//  GLMine_Team_AchieveManageBaseController.m
//  excellentPurchase
//
//  Created by 龚磊 on 2018/1/17.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "GLMine_Team_AchieveManageBaseController.h"

NSNotificationName const GLMine_Team_ChildScrollViewDidScrollNSNotification = @"GLMine_Team_ChildScrollViewDidScrollNSNotification";
NSNotificationName const GLMine_Team_ChildScrollViewRefreshStateNSNotification = @"GLMine_Team_ChildScrollViewRefreshStateNSNotification";

@interface GLMine_Team_AchieveManageBaseController ()

@end

@implementation GLMine_Team_AchieveManageBaseController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    adjustsScrollViewInsets_NO(self.tableView, self);
//    self.rowCount = 20;
    
    [self.view addSubview:self.tableView];
    self.scrollView = self.tableView;
}

//// 下拉刷新
//- (void)downPullUpdateData {
//    [[NSNotificationCenter defaultCenter] postNotificationName:ChildScrollViewRefreshStateNSNotification object:nil userInfo:@{@"isRefreshing":@(YES)}];
//    // 模拟网络请求，1秒后结束刷新
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        self.rowCount = 20;
//
//
//        [[NSNotificationCenter defaultCenter] postNotificationName:ChildScrollViewRefreshStateNSNotification object:nil userInfo:@{@"isRefreshing":@(NO)}];
//    });
//}
//
//// 上拉加载
//- (void)upPullLoadMoreData {
//    self.rowCount = 30;
//    [self.tableView reloadData];
//    [[NSNotificationCenter defaultCenter] postNotificationName:ChildScrollViewRefreshStateNSNotification object:nil userInfo:@{@"isRefreshing":@(YES)}];
//    // 模拟网络请求，1秒后结束刷新
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        self.rowCount = 20;
//
//
//        [[NSNotificationCenter defaultCenter] postNotificationName:ChildScrollViewRefreshStateNSNotification object:nil userInfo:@{@"isRefreshing":@(NO)}];
//    });
//}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetDifference = scrollView.contentOffset.y - self.lastContentOffset.y;
    // 滚动时发出通知
    [[NSNotificationCenter defaultCenter] postNotificationName:GLMine_Team_ChildScrollViewDidScrollNSNotification object:nil userInfo:@{@"scrollingScrollView":scrollView,@"offsetDifference":@(offsetDifference)}];
    self.lastContentOffset = scrollView.contentOffset;
}


- (UITableView *)tableView {
    
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, UIScreenWidth, UIScreenHeight-SafeAreaBottomHeight-SafeAreaTopHeight) style:UITableViewStylePlain];
        _tableView.contentInset = UIEdgeInsetsMake(self.scrollViewBeginTopInset, 0, 0, 0);
        _tableView.scrollIndicatorInsets = UIEdgeInsetsMake(self.scrollViewBeginTopInset, 0, 0, 0);
        _tableView.tableFooterView = [UIView new];
        
    }
    return _tableView;
}


@end
