
//
//  LBBankCardListViewController.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/1/12.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "LBBankCardListViewController.h"
#import "LBBankCardListTableViewCell.h"
#import "LBAddBankCardViewController.h"
#import "GLMine_CardListModel.h"

#import "GLMine_BankManageController.h"//银行卡管理

@interface LBBankCardListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong)NSMutableArray *models;
@property (nonatomic, assign)NSInteger page;
@property (nonatomic, strong)NodataView *nodataV;

/**数据*/
@property (strong, nonatomic) NSArray *dataArr;

@end

static NSString *bankCardListTableViewCell = @"LBBankCardListTableViewCell";

@implementation LBBankCardListViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"银行卡";
    self.navigationController.navigationBar.hidden = NO;
    //注册cell
    [self.tableView registerNib:[UINib nibWithNibName:bankCardListTableViewCell bundle:nil] forCellReuseIdentifier:bankCardListTableViewCell];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"添加银行卡"] style:UIBarButtonItemStylePlain target:self action:@selector(addBanCard)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    //
    
    [self.tableView addSubview:self.nodataV];
    self.nodataV.hidden = YES;
    
//    __weak __typeof(self) weakSelf = self;
//    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//
//        [weakSelf postRequest:YES];
//
//    }];
//
//    MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
//
//        [weakSelf postRequest:NO];
//
//    }];
//
//    // 设置文字
//    [header setTitle:@"快扯我，快点" forState:MJRefreshStateIdle];
//
//    [header setTitle:@"数据要来啦" forState:MJRefreshStatePulling];
//
//    [header setTitle:@"服务器正在狂奔..." forState:MJRefreshStateRefreshing];
//
//    self.tableView.mj_header = header;
//    self.tableView.mj_footer = footer;
    
    self.page = 1;
    [self postRequest:YES];
    
}

- (void)postRequest:(BOOL)isRefresh{
    
    if (isRefresh) {
        self.page = 1;
        
    }else{
        self.page ++ ;
    }
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    dic[@"app_handler"] = @"SEARCH";
    dic[@"token"] = [UserModel defaultUser].token;
    dic[@"uid"] = [UserModel defaultUser].uid;
    dic[@"page"] = @(self.page);
    
    [EasyShowLodingView showLodingText:@"正在加载数据"];
    
    [NetworkManager requestPOSTWithURLStr:kBankList_URL paramDic:dic finish:^(id responseObject) {
        
        [EasyShowLodingView hidenLoding];
        
        if (isRefresh) {
            [self.models removeAllObjects];
        }
        
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE){
            if([(NSDictionary *)responseObject[@"data"] count] != 0){

                for (NSDictionary *dic in responseObject[@"data"][@"page_data"]) {
                    GLMine_CardModel * model = [GLMine_CardModel mj_objectWithKeyValues:dic];

                    [self.models addObject:model];
                }
            }
        }else{
            [EasyShowTextView showErrorText:responseObject[@"message"]];
        }
        
        [self.tableView reloadData];
        
    } enError:^(NSError *error) {

        [EasyShowLodingView hidenLoding];
        [self.tableView reloadData];
        [EasyShowTextView showErrorText:error.localizedDescription];
        
    }];
}

//- (void)endRefresh {
//
//    [self.tableView.mj_header endRefreshing];
//    [self.tableView.mj_footer endRefreshing];
//
//}

/**
 添加银行卡
 */
-(void)addBanCard{
    
    self.hidesBottomBarWhenPushed = YES;
    LBAddBankCardViewController *vc =[[LBAddBankCardViewController alloc]init];
    WeakSelf;
    vc.block = ^(BOOL isUnbind) {
        if (isUnbind) {
            [weakSelf postRequest:YES];
        }
    };
    [self.navigationController pushViewController:vc animated:YES];
    
}
#pragma mark - 重写----设置有groupTableView有几个分区
-(NSInteger)numberOfSectionsInTableView:(UITableView*)tableView {
    return self.models.count; //返回值是多少既有几个分区
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 125;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    LBBankCardListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:bankCardListTableViewCell forIndexPath:indexPath];
    cell.model = self.models[indexPath.section];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
   
    return cell;
}

#pragma mark - 重写----设置自定义的标题和标注
-(UIView*)tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *headerLabel = [[UIView alloc] initWithFrame:CGRectZero];
    headerLabel.backgroundColor = [UIColor whiteColor];
    
    return headerLabel;
}

#pragma mark - 重写----设置标题和标注的高度
-(CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section {
    return 10.0f;
}

-(CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.0001f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GLMine_CardModel *model = self.models[indexPath.section];
    
    self.hidesBottomBarWhenPushed = YES;
    
    GLMine_BankManageController *VC = [[GLMine_BankManageController alloc] init];
    VC.endNum = model.endnumber;
    VC.bank_id = model.bank_id;
    WeakSelf;
    VC.block = ^(BOOL isUnbind) {
        if (isUnbind) {
            ///刷新
            [weakSelf postRequest:YES];
        }
    };
    [self.navigationController pushViewController:VC animated:YES];
}

#pragma mark - 懒加载
- (NSMutableArray *)models{
    if (!_models) {
        _models = [NSMutableArray array];
    }
    return _models;
}

@end
