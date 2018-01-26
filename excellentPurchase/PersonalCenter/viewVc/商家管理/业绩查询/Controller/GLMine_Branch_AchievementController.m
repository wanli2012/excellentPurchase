//
//  GLMine_Branch_AchievementController.m
//  excellentPurchase
//
//  Created by 龚磊 on 2018/1/25.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "GLMine_Branch_AchievementController.h"
#import "GLMine_Branch_AchievementCell.h"
#import "GLMine_Branch_AchievementModel.h"

@interface GLMine_Branch_AchievementController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, assign) NSInteger rowCount;

@property (nonatomic, strong)NSMutableArray *models;

@end

static NSString *donationTableViewCell = @"GLMine_Branch_AchievementCell";

@implementation GLMine_Branch_AchievementController

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
    return self.models.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 165;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GLMine_Branch_AchievementCell *cell = [tableView dequeueReusableCellWithIdentifier:donationTableViewCell forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = self.models[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    self.hidesBottomBarWhenPushed = YES;
//    GLMine_Team_UnderLingAchieveController *vc = [[GLMine_Team_UnderLingAchieveController alloc] init];
//    [self.navigationController pushViewController:vc animated:YES];
    
}

#pragma mark - 懒加载
- (NSMutableArray *)models{
    if (!_models) {
        _models = [NSMutableArray array];
        
        for (int i = 0; i <7; i ++) {
            GLMine_Branch_AchievementModel *model = [[GLMine_Branch_AchievementModel alloc] init];
            model.date = [NSString stringWithFormat:@"2018-01-0%zd",i];
            model.price = @"3333";
            model.remark = @"d搭建浪费时间代理费家拉设计费加啊;地方家拉设计费静安寺防火卷帘撒回复";
            model.submitDate = @"2018-01-02";
            model.type = self.type;
            
            [_models addObject:model];
        }
    }
    return _models;
}


@end
