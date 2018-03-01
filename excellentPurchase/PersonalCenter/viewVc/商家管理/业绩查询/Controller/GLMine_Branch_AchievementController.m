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

@property (strong, nonatomic)NSMutableArray *models;
@property (assign, nonatomic)NSInteger page;//页数默认为1
@property (strong, nonatomic)NodataView *nodataV;

@property (nonatomic, copy)NSString *date;

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
    
    WeakSelf;
    [LBDefineRefrsh defineRefresh:self.tableView headerrefresh:^{
        [weakSelf postRequest:YES];
    } footerRefresh:^{
        [weakSelf postRequest:NO];
    }];
    
    self.page = 1;
    [self postRequest:YES];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refresh:) name:@"AchievementNotification" object:nil];
    
}

//刷新
-(void)refresh:(NSNotification *)noti{
    
    self.date = noti.userInfo[@"month"];
    
    [self postRequest:YES];
    
}

//请求数据
-(void)postRequest:(BOOL)isRefresh{
    
    if(isRefresh){
        self.page = 1;
    }else{
        self.page ++;
    }
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    dic[@"app_handler"] = @"SEARCH";
    dic[@"uid"] = [UserModel defaultUser].uid;
    dic[@"token"] = [UserModel defaultUser].token;
    dic[@"page"] = @(self.page);
    dic[@"time"] = self.date;
    
    if (self.typeIndex == 1) {//1主店的业绩查询 2:分店的业绩查询
        dic[@"shop_uid"] = [UserModel defaultUser].uid;
    }else{
        dic[@"shop_uid"] = self.sid;
    }
    
    NSString *url;
    if (self.type == 1) {////1:线上业绩  0:线下业绩
        url = kstore_achievement;
    }else{
        url = kstore_achievement_line;
    }
    
    [EasyShowLodingView showLoding];
    [NetworkManager requestPOSTWithURLStr:url paramDic:dic finish:^(id responseObject) {
        
        [EasyShowLodingView hidenLoding];
        [LBDefineRefrsh dismissRefresh:self.tableView];
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE) {
            
            if (isRefresh == YES) {
                [self.models removeAllObjects];
            }
            
            for (NSDictionary *dict in responseObject[@"data"][@"page_data"]) {
                GLMine_Branch_AchievementModel *model = [GLMine_Branch_AchievementModel mj_objectWithKeyValues:dict];
                model.type = self.type;
                [self.models addObject:model];
            }
            
        }else{
            [EasyShowTextView showErrorText:responseObject[@"message"]];
        }
        
        [self.tableView reloadData];
        
    } enError:^(NSError *error) {
        
        [LBDefineRefrsh dismissRefresh:self.tableView];
        [EasyShowLodingView hidenLoding];
        [EasyShowTextView showErrorText:error.localizedDescription];
        [self.tableView reloadData];
        
    }];
}

//// 下拉刷新
//- (void)downPullUpdateData {
//    [[NSNotificationCenter defaultCenter] postNotificationName:GLMine_Team_ChildScrollViewRefreshStateNSNotification object:nil userInfo:@{@"isRefreshing":@(YES)}];
//    // 模拟网络请求，1秒后结束刷新
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        self.rowCount = 20;
//
//        [[NSNotificationCenter defaultCenter] postNotificationName:GLMine_Team_ChildScrollViewRefreshStateNSNotification object:nil userInfo:@{@"isRefreshing":@(NO)}];
//    });
//}
//
//// 上拉加载
//- (void)upPullLoadMoreData {
//    self.rowCount = 30;
//    [self.tableView reloadData];
//    [[NSNotificationCenter defaultCenter] postNotificationName:GLMine_Team_ChildScrollViewRefreshStateNSNotification object:nil userInfo:@{@"isRefreshing":@(YES)}];
//    // 模拟网络请求，1秒后结束刷新
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        self.rowCount = 20;
//
//        [[NSNotificationCenter defaultCenter] postNotificationName:GLMine_Team_ChildScrollViewRefreshStateNSNotification object:nil userInfo:@{@"isRefreshing":@(NO)}];
//    });
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.models.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.type == 1) {////1:线上业绩  2:线下业绩
        return 165;
    }else{
        return 215;
    }
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
        
      
    }
    return _models;
}


@end
