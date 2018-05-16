//
//  LBHomeOneDolphinAllViewController.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/3/8.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "LBHomeOneDolphinAllViewController.h"
#import "LBHomeViewActivityNowTableViewCell.h"
#import "LBHomeOneDolphinDetailController.h"
#import "LBHomeViewActivityViewController.h"
#import "LBHomeViewActivityListModel.h"
#import "LBHomeViewActivityWaitTableViewCell.h"
#import "LBHomeViewActivityAlreadyTableViewCell.h"

static NSString *homeViewActivityNowTableViewCell = @"LBHomeViewActivityNowTableViewCell";
static NSString *homeViewActivityWaitTableViewCell = @"LBHomeViewActivityWaitTableViewCell";
static NSString *homeViewActivityAlreadyTableViewCell = @"LBHomeViewActivityAlreadyTableViewCell";

@interface LBHomeOneDolphinAllViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic)NSMutableArray *models;
@property (assign, nonatomic)NSInteger page;//页数默认为1
@property (strong, nonatomic)NodataView *nodataV;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation LBHomeOneDolphinAllViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.tableView];
    
    //注册cell
    [self.tableView registerNib:[UINib nibWithNibName:homeViewActivityNowTableViewCell bundle:nil] forCellReuseIdentifier:homeViewActivityNowTableViewCell];
    [self.tableView registerNib:[UINib nibWithNibName:homeViewActivityWaitTableViewCell bundle:nil] forCellReuseIdentifier:homeViewActivityWaitTableViewCell];
    [self.tableView registerNib:[UINib nibWithNibName:homeViewActivityAlreadyTableViewCell bundle:nil] forCellReuseIdentifier:homeViewActivityAlreadyTableViewCell];
    
        [self setupNpdata];//设置无数据的时候展示
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(countDownoneDolphin) name:@"countDownoneDolphin" object:nil];
    
    WeakSelf;
    [LBDefineRefrsh defineRefresh:self.tableView headerrefresh:^{
        [weakSelf postRequest:YES];
    } footerRefresh:^{
        [weakSelf postRequest:NO];
    }];

    self.page = 1;
    [self postRequest:YES];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.trailing.equalTo(self.view).offset(0);
        make.leading.equalTo(self.view).offset(0);
        make.top.equalTo(self.view).offset(0);
        make.bottom.equalTo(self.view).offset(0);
    }];
}

-(void)countDownoneDolphin{
    
    for (int i = 0; i < self.models.count; i++) {
        LBHomeViewActivityListModel *model = self.models[i];
        NSInteger second = [model.active_reward_time integerValue];
        second = second - 1;
        model.active_reward_time = [NSString stringWithFormat:@"%zd",second];
    }
    [[NSNotificationCenter defaultCenter]postNotificationName:OneDolphinTimeCellNotification object:nil];
}
//刷新
-(void)refreshReceivingAddress{
    [self postRequest:YES];
}

/**
 设置无数据图
 */
-(void)setupNpdata{
    WeakSelf;
    self.tableView.tableFooterView = [UIView new];
    
    self.tableView.ly_emptyView = [LYEmptyView emptyViewWithImageStr:@"nodata_pic"
                                                            titleStr:@"暂无数据，点击重新加载"
                                                           detailStr:@""];
    self.tableView.ly_emptyView.imageSize = CGSizeMake(100, 100);
    self.tableView.ly_emptyView.titleLabTextColor = YYSRGBColor(109, 109, 109, 1);
    self.tableView.ly_emptyView.titleLabFont = [UIFont fontWithName:@"MDT_1_95969" size:15];
    self.tableView.ly_emptyView.detailLabFont = [UIFont fontWithName:@"MDT_1_95969" size:13];
    
    self.tableView.ly_emptyView.contentViewY = 40;
    //emptyView内容上的点击事件监听
    [self.tableView.ly_emptyView setTapContentViewBlock:^{
        [weakSelf postRequest:YES];
    }];
}

//请求数据
-(void)postRequest:(BOOL)isRefresh{
    if(isRefresh){
        self.page = 1;
    }else{
        self.page ++;
    }
    
//    [EasyShowLodingView showLodingText:@"数据请求中"];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"app_handler"] = @"SEARCH";
    dic[@"type"] = @"0";
    dic[@"page"] = @(self.page);
    
    [NetworkManager requestPOSTWithURLStr:kIndianaindiana_main paramDic:dic finish:^(id responseObject) {
        [LBDefineRefrsh dismissRefresh:self.tableView];
        [EasyShowLodingView hidenLoding];
        if(isRefresh){
            [self.models removeAllObjects];
        }
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE) {
            for (NSDictionary *dic in responseObject[@"data"][@"list"][@"page_data"]) {
                LBHomeViewActivityListModel *model = [LBHomeViewActivityListModel mj_objectWithKeyValues:dic];
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

#pragma mark - UITabelViewDelegate UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.models.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    LBHomeViewActivityListModel *model  = _models[indexPath.row];
    if ([model.indiana_status integerValue] == 1) {
        return 110;
    }else if ([model.indiana_status integerValue] == 2){
        return 125;
    }else if ([model.indiana_status integerValue] == 3){
        return 121;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LBHomeViewActivityListModel *model  = _models[indexPath.row];
    if ([model.indiana_status integerValue] == 1) {
        LBHomeViewActivityNowTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:homeViewActivityNowTableViewCell forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = model;
        return cell;
    }else if ([model.indiana_status integerValue] == 2){
        LBHomeViewActivityWaitTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:homeViewActivityWaitTableViewCell forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.timeType = 1;
        cell.model = model;
        return cell;
    }else if ([model.indiana_status integerValue] == 3){
        LBHomeViewActivityAlreadyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:homeViewActivityAlreadyTableViewCell forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = model;
        return cell;
    }
    
    return [[UITableViewCell alloc]init];

}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
     LBHomeViewActivityListModel *model  = _models[indexPath.row];
    [self viewController].hidesBottomBarWhenPushed = YES;
    LBHomeOneDolphinDetailController *vc = [[LBHomeOneDolphinDetailController alloc]init];
    vc.indiana_id = model.indiana_id;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    LBHomeViewActivityListModel *model  = _models[indexPath.row];
    if ([model.indiana_status integerValue] == 2){
        LBHomeViewActivityWaitTableViewCell  *cell1 =  (LBHomeViewActivityWaitTableViewCell*)cell;
        cell1.isDisplay = YES;
        LBHomeViewActivityListModel *model = self.models[indexPath.row];
        [cell1 setSecond:model.active_reward_time row:indexPath.row buyingsecond:nil];
    }
}

-(void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    LBHomeViewActivityListModel *model  = _models[indexPath.row];
    if ([model.indiana_status integerValue] == 2){
        LBHomeViewActivityWaitTableViewCell  *cell1 =  (LBHomeViewActivityWaitTableViewCell*)cell;
        cell1.isDisplay = NO;
    }
   
}

#pragma mark - 懒加载
/**
 *  获取父视图的控制器
 *
 *  @return 父视图的控制器
 */
- (LBHomeViewActivityViewController *)viewController
{
    for (UIView* next = [self.view superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[LBHomeViewActivityViewController class]]) {
            return (LBHomeViewActivityViewController *)nextResponder;
        }
    }
    return nil;
}
-(NSMutableArray *)models{
    
    if (!_models) {
        _models = [NSMutableArray array];
    }
    
    return _models;
    
}
- (UITableView *)tableView {
    
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.tableFooterView = [UIView new];
        _tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}


@end
