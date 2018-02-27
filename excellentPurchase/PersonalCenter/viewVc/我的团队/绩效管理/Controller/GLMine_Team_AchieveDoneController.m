//
//  GLMine_Team_AchieveDoneController.m
//  excellentPurchase
//
//  Created by 龚磊 on 2018/1/17.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "GLMine_Team_AchieveDoneController.h"
#import "GLMine_Team_AchieveManageCell.h"
#import "GLMine_Team_UnderLingAchieveController.h"//下属绩效列表

@interface GLMine_Team_AchieveDoneController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, assign) NSInteger rowCount;

@end

static NSString *donationTableViewCell = @"GLMine_Team_AchieveManageCell";

@implementation GLMine_Team_AchieveDoneController

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
    [[NSNotificationCenter defaultCenter] postNotificationName:GLMine_Team_ChildScrollViewRefreshStateNSNotification object:nil userInfo:@{@"isRefreshing":@(YES)}];
    // 模拟网络请求，1秒后结束刷新
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.rowCount = 20;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:GLMine_Team_ChildScrollViewRefreshStateNSNotification object:nil userInfo:@{@"isRefreshing":@(NO)}];
    });
}

// 上拉加载
- (void)upPullLoadMoreData {
    self.rowCount = 30;
    [self.tableView reloadData];
    [[NSNotificationCenter defaultCenter] postNotificationName:GLMine_Team_ChildScrollViewRefreshStateNSNotification object:nil userInfo:@{@"isRefreshing":@(YES)}];
    // 模拟网络请求，1秒后结束刷新
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.rowCount = 20;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:GLMine_Team_ChildScrollViewRefreshStateNSNotification object:nil userInfo:@{@"isRefreshing":@(NO)}];
    });
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 15;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GLMine_Team_AchieveManageCell *cell = [tableView dequeueReusableCellWithIdentifier:donationTableViewCell forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.hidesBottomBarWhenPushed = YES;
    GLMine_Team_UnderLingAchieveController *vc = [[GLMine_Team_UnderLingAchieveController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
