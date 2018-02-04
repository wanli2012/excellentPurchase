//
//  GLMine_Branch_Online_DeliveredController.m
//  excellentPurchase
//
//  Created by 龚磊 on 2018/1/25.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "GLMine_Branch_Online_DeliveredController.h"
#import "GLMine_Branch_OnlineOrderCell.h"
#import "GLMine_Branch_AchievementModel.h"
#import "GLMine_Branch_OnlineHeader.h"
#import "GLMine_Branch_OnlineFooter.h"
#import "GLMine_Seller_OrderDetailController.h"//订单详情
#import "GLMine_Branch_OrderModel.h"

@interface GLMine_Branch_Online_DeliveredController ()<UITableViewDelegate,UITableViewDataSource,GLMine_Branch_OnlineFooterDelegate,GLMine_Branch_OnlineHeaderDelegate>

@property (nonatomic, strong)UITableView *tableView;

@property (strong, nonatomic)NSMutableArray *models;
@property (assign, nonatomic)NSInteger page;//页数默认为1
@property (strong, nonatomic)NodataView *nodataV;


@end

@implementation GLMine_Branch_Online_DeliveredController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.tableView];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"GLMine_Branch_OnlineOrderCell" bundle:nil] forCellReuseIdentifier:@"GLMine_Branch_OnlineOrderCell"];
    
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
    dic[@"status"] = self.status;//查询状态 2.待发货 3.已发货 11.已取消
    
    [EasyShowLodingView showLoding];
    [NetworkManager requestPOSTWithURLStr:kstore_product_orders paramDic:dic finish:^(id responseObject) {
        [EasyShowLodingView hidenLoding];
        [LBDefineRefrsh dismissRefresh:self.tableView];
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE) {
            
            if (isRefresh == YES) {
                [self.models removeAllObjects];
            }
            for (NSDictionary *dict in responseObject[@"data"][@"page_data"]) {
                GLMine_Branch_OrderModel *model = [GLMine_Branch_OrderModel mj_objectWithKeyValues:dict];
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


#pragma mark - GLMine_Branch_OnlineHeaderDelegate 订单详情
- (void)toOrderDetail:(NSInteger)section{
    
    self.hidesBottomBarWhenPushed = YES;
    GLMine_Seller_OrderDetailController *vc = [[GLMine_Seller_OrderDetailController alloc] init];
    vc.type = 3;//查询状态 2.待发货 3.已发货 11.已取消
    vc.model = self.models[section];
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - GLMine_Branch_OnlineFooterDelegate

- (void)cancelOrder:(NSInteger)section{
    NSLog(@"--取消订单-%zd",section);
}

- (void)ensureOrder:(NSInteger)section{
    NSLog(@"--确认订单-%zd",section);
}


#pragma mark -UITableviewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.models.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    GLMine_Branch_OrderModel *model = self.models[section];
    return model.goods_data.count;
}

-(UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    GLMine_Branch_OrderModel *model = self.models[indexPath.section];
    
    GLMine_Branch_OnlineOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GLMine_Branch_OnlineOrderCell"];
    cell.selectionStyle = 0;
    cell.model = model.goods_data[indexPath.row];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 120;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    NSString *ID = @"onlineOrderHeaderView";
    
    GLMine_Branch_OnlineHeader *headerview = [tableView dequeueReusableHeaderFooterViewWithIdentifier:ID];
    
    if (!headerview) {
        headerview = [[GLMine_Branch_OnlineHeader alloc] initWithReuseIdentifier:ID];
    }
    headerview.delegate = self;
    headerview.model = self.models[section];
    return headerview;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{

    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UIScreenWidth, 0.001)];

    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 65;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.001;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //    self.hidesBottomBarWhenPushed = YES;
    //    GLMine_Team_MemberDataController *dataVC = [[GLMine_Team_MemberDataController alloc] init];
    //    [self.navigationController pushViewController:dataVC animated:YES];
    
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
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, UIScreenWidth, UIScreenHeight - SafeAreaTopHeight - 50) style:UITableViewStyleGrouped];
        _tableView.backgroundColor = YYSRGBColor(245, 245, 245, 1);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
    }
    return _tableView;
}
@end
