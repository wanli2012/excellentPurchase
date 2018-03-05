//
//  GLMine_Branch_OfflineStatusController.m
//  excellentPurchase
//
//  Created by 龚磊 on 2018/1/25.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "GLMine_Branch_OfflineStatusController.h"
#import "GLMine_Branch_OfflineCell.h"
#import "GLMine_Branch_OfflineOrderModel.h"

#import "GLMine_Branch_Offline_PlaceOrderController.h"//线下下单

@interface GLMine_Branch_OfflineStatusController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong)UITableView *tableView;

@property (strong, nonatomic)NSMutableArray *models;
@property (assign, nonatomic)NSInteger page;//页数默认为1
@property (strong, nonatomic)NodataView *nodataV;

@end

@implementation GLMine_Branch_OfflineStatusController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.tableView];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"GLMine_Branch_OfflineCell" bundle:nil] forCellReuseIdentifier:@"GLMine_Branch_OfflineCell"];
     [self setupNpdata];//设置无数据的时候展示
    WeakSelf;
    [LBDefineRefrsh defineRefresh:self.tableView headerrefresh:^{
        [weakSelf postRequest:YES];
    } footerRefresh:^{
        [weakSelf postRequest:NO];
    }];
    
    self.page = 1;
    [self postRequest:YES];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refresh) name:@"GLMine_RefreshNotification" object:nil];
    
}

//刷新
-(void)refresh{
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
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    dic[@"app_handler"] = @"SEARCH";
    dic[@"uid"] = [UserModel defaultUser].uid;
    dic[@"token"] = [UserModel defaultUser].token;
    dic[@"page"] = @(self.page);
    dic[@"status"] = @(self.type);//0失败 1成功 2未审核 状态类型
    
    [EasyShowLodingView showLoding];
    [NetworkManager requestPOSTWithURLStr:kstore_line_list paramDic:dic finish:^(id responseObject) {
        [EasyShowLodingView hidenLoding];
        [LBDefineRefrsh dismissRefresh:self.tableView];
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE) {
            
            if (isRefresh == YES) {
                [self.models removeAllObjects];
            }
            for (NSDictionary *dict in responseObject[@"data"][@"page_data"]) {
                GLMine_Branch_OfflineOrderModel *model = [GLMine_Branch_OfflineOrderModel mj_objectWithKeyValues:dict];
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

#pragma mark - GLMine_Branch_OnlineFooterDelegate

- (void)cancelOrder:(NSInteger)section{
    NSLog(@"--取消订单-%zd",section);
}

- (void)ensureOrder:(NSInteger)section{
    NSLog(@"--确认订单-%zd",section);
}

#pragma mark -UITableviewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.models.count;
}

-(UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    GLMine_Branch_OfflineCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GLMine_Branch_OfflineCell"];
    cell.selectionStyle = 0;
    cell.model = self.models[indexPath.row];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 170;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(self.type == 0){//0失败 1成功 2未审核 状态类型
        self.hidesBottomBarWhenPushed = YES;
        GLMine_Branch_Offline_PlaceOrderController *vc = [[GLMine_Branch_Offline_PlaceOrderController alloc] init];
        vc.model = self.models[indexPath.row];
        vc.type = 2;////1:线下下单 2:线下订单失败 重新下单
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}

#pragma mark - 懒加载
- (NSMutableArray *)models{
    if (!_models) {
        _models = [NSMutableArray array];
    }
    return _models;
}

#pragma 懒加载
- (UITableView *)tableView{
    
    if (!_tableView) {
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, UIScreenWidth, UIScreenHeight - SafeAreaTopHeight - 50) style:UITableViewStylePlain];
        
        _tableView.backgroundColor = YYSRGBColor(245, 245, 245, 1);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
    }
    return _tableView;
}

@end
