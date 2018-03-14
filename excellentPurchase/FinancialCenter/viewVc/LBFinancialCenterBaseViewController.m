//
//  LBFinancialCenterBaseViewController.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/1/20.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "LBFinancialCenterBaseViewController.h"

NSNotificationName const ChildScrollViewDidScrollNSNotificationFinancial = @"ChildScrollViewDidScrollNSNotificationFinancial";
NSNotificationName const ChildScrollViewRefreshStateNSNotificationFinancial = @"ChildScrollViewRefreshStateNSNotificationFinancial";

@interface LBFinancialCenterBaseViewController ()


@end

@implementation LBFinancialCenterBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    adjustsScrollViewInsets_NO(self.tableView, self);
    //self.rowCount = 20;
    
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
//        [[NSNotificationCenter defaultCenter] postNotificationName:ChildScrollViewRefreshStateNSNotificationFinancial object:nil userInfo:@{@"isRefreshing":@(NO)}];
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
//        [[NSNotificationCenter defaultCenter] postNotificationName:ChildScrollViewRefreshStateNSNotificationFinancial object:nil userInfo:@{@"isRefreshing":@(NO)}];
//    });
//}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetDifference = scrollView.contentOffset.y - self.lastContentOffset.y;
    // 滚动时发出通知
    [[NSNotificationCenter defaultCenter] postNotificationName:ChildScrollViewDidScrollNSNotificationFinancial object:nil userInfo:@{@"scrollingScrollView":scrollView,@"offsetDifference":@(offsetDifference)}];
    self.lastContentOffset = scrollView.contentOffset;
}

- (UITableView *)tableView {
    
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, UIScreenWidth, UIScreenHeight- SafeAreaBottomReallyHeight) style:UITableViewStylePlain];
        _tableView.contentInset = UIEdgeInsetsMake(kScrollViewBeginTopInset, 0, 0, 0);
        _tableView.scrollIndicatorInsets = UIEdgeInsetsMake(kScrollViewBeginTopInset, 0, 0, 0);
        _tableView.tableFooterView = [UIView new];
        _tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
    }
    return _tableView;
}

@end
