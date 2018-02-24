//
//  GLMine_MyWallet_CashRecordController.m
//  excellentPurchase
//
//  Created by 龚磊 on 2018/1/26.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "GLMine_MyWallet_CashRecordController.h"
#import "GLMine_MyWallet_CashRecordCell.h"
#import "GLMine_MyWallet_CashRecordModel.h"

@interface GLMine_MyWallet_CashRecordController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic)NSMutableArray *models;
@property (assign, nonatomic)NSInteger page;//页数默认为1
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomHeight;

@end

@implementation GLMine_MyWallet_CashRecordController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"提现记录";
    [self.tableView registerNib:[UINib nibWithNibName:@"GLMine_MyWallet_CashRecordCell" bundle:nil] forCellReuseIdentifier:@"GLMine_MyWallet_CashRecordCell"];
    
    [self setupNpdata];//设置无数据的时候展示
    WeakSelf;
    [LBDefineRefrsh defineRefresh:self.tableView headerrefresh:^{
        [weakSelf postRequest:YES];
    } footerRefresh:^{
        [weakSelf postRequest:NO];
    }];
    
    self.page = 1;
    [self postRequest:YES];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshReceivingAddress) name:@"refreshReceivingAddress" object:nil];
    
    self.bottomHeight.constant = SafeAreaBottomHeight;
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
    
    [NetworkManager requestPOSTWithURLStr:kstore_balance_list paramDic:dic finish:^(id responseObject) {
        
        [LBDefineRefrsh dismissRefresh:self.tableView];
        [EasyShowLodingView hidenLoding];
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE) {
            
            if (isRefresh == YES) {
                [self.models removeAllObjects];
            }
            for (NSDictionary *dict in responseObject[@"data"][@"page_data"]) {
                GLMine_MyWallet_CashRecordModel *model = [GLMine_MyWallet_CashRecordModel mj_objectWithKeyValues:dict];
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

#pragma mark -UITableviewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.models.count;
}

-(UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    GLMine_MyWallet_CashRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GLMine_MyWallet_CashRecordCell"];
    
    cell.selectionStyle = 0;
    
    cell.model = self.models[indexPath.row];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    tableView.rowHeight = UITableViewAutomaticDimension;
    tableView.estimatedRowHeight = 44;
    
    return tableView.rowHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GLMine_MyWallet_CashRecordModel *model = self.models[indexPath.row];
    if ([model.type integerValue] == 2) {
        [EasyShowTextView showInfoText:model.reason];
    }
    
}

#pragma mark - 懒加载
-(NSMutableArray *)models{
    
    if (!_models) {
        _models = [NSMutableArray array];
    }
    
    return _models;
}

@end
