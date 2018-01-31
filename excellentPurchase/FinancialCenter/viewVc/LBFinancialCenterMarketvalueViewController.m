//
//  LBFinancialCenterMarketvalueViewController.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/1/20.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "LBFinancialCenterMarketvalueViewController.h"
#import "LBFinancialCenterTableViewCell.h"
#import "GLFinancialCenterModel.h"

@interface LBFinancialCenterMarketvalueViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic)NSMutableArray *models;
@property (assign, nonatomic)NSInteger page;//页数默认为1
@property (strong, nonatomic)NodataView *nodataV;

@end

static NSString *donationTableViewCell = @"LBFinancialCenterTableViewCell";

@implementation LBFinancialCenterMarketvalueViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    //注册cell
    [self.tableView registerNib:[UINib nibWithNibName:donationTableViewCell bundle:nil] forCellReuseIdentifier:donationTableViewCell];
    
//    [self setupNpdata];//设置无数据的时候展示

    WeakSelf;
    [LBDefineRefrsh defineRefresh:self.tableView headerrefresh:^{
        [weakSelf postRequest:YES];
    } footerRefresh:^{
        [weakSelf postRequest:NO];
    }];
    
    self.page = 1;
    [self postRequest:YES];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshReceivingAddress) name:@"refreshReceivingAddress" object:nil];
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
    
    self.tableView.ly_emptyView.contentViewY = 20;
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
    
    [EasyShowLodingView showLodingText:@"数据请求中"];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"app_handler"] = @"SEARCH";
    dic[@"uid"] = [UserModel defaultUser].uid;
    dic[@"token"] = [UserModel defaultUser].token;
    dic[@"page"] = @(self.page);
    
    [NetworkManager requestPOSTWithURLStr:kget_money_list paramDic:dic finish:^(id responseObject) {
        [LBDefineRefrsh dismissRefresh:self.tableView];
        [EasyShowLodingView hidenLoding];
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE) {
            
            if (isRefresh == YES) {
                [self.models removeAllObjects];
            }
            for (NSDictionary *dict in responseObject[@"data"][@"page_data"]) {
                GLFinancialCenterModel *model = [GLFinancialCenterModel mj_objectWithKeyValues:dict];
                model.ratio_max = responseObject[@"data"][@"ratio_max"];
                model.cellType = 1;
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
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    LBFinancialCenterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:donationTableViewCell forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = self.models[indexPath.row];
    
    return cell;
}

#pragma mark - 懒加载

-(NSMutableArray *)models{
    
    if (!_models) {
        _models = [NSMutableArray array];
    }
    
    return _models;
    
}

@end
