//
//  LBSendRedPackRecoderReciveVc.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/1/11.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "LBSendRedPackRecoderReciveVc.h"
#import "LBDonationTableViewCell.h"

@interface LBSendRedPackRecoderReciveVc ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, assign) NSInteger rowCount;

@end

static NSString *donationTableViewCell = @"LBDonationTableViewCell";

@implementation LBSendRedPackRecoderReciveVc

- (void)viewDidLoad {
    [super viewDidLoad];
    adjustsScrollViewInsets_NO(self.scrollView, self);
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    //注册cell
    [self.tableView registerNib:[UINib nibWithNibName:donationTableViewCell bundle:nil] forCellReuseIdentifier:donationTableViewCell];
}


// 下拉刷新
- (void)downPullUpdateData {
    [[NSNotificationCenter defaultCenter] postNotificationName:ChildScrollViewRefreshStateNSNotification object:nil userInfo:@{@"isRefreshing":@(YES)}];
    // 模拟网络请求，1秒后结束刷新
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.rowCount = 20;
        
        
        [[NSNotificationCenter defaultCenter] postNotificationName:ChildScrollViewRefreshStateNSNotification object:nil userInfo:@{@"isRefreshing":@(NO)}];
    });
}

// 上拉加载
- (void)upPullLoadMoreData {
    self.rowCount = 30;
    [self.tableView reloadData];
    [[NSNotificationCenter defaultCenter] postNotificationName:ChildScrollViewRefreshStateNSNotification object:nil userInfo:@{@"isRefreshing":@(YES)}];
    // 模拟网络请求，1秒后结束刷新
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.rowCount = 20;
        
        
        [[NSNotificationCenter defaultCenter] postNotificationName:ChildScrollViewRefreshStateNSNotification object:nil userInfo:@{@"isRefreshing":@(NO)}];
    });
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LBDonationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:donationTableViewCell forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}



@end
