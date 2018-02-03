//
//  LBMineCollectionShopViewController.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/1/23.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "LBMineCollectionShopViewController.h"
#import "LBMineCollectionStoreTableViewCell.h"
#import "POP.h"
#import "LBCollectionManager.h"
#import "LBMineCollectionStoreModel.h"
#import "LBEatShopProdcutClassifyViewController.h"
#import "LBEat_StoreDetailViewController.h"

@interface LBMineCollectionShopViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableview;
@property (strong, nonatomic) NSMutableArray    *dataArr;
@property (strong, nonatomic) UIView            *editingView;
@property (nonatomic, assign) NSInteger  allCount;
@property (nonatomic, assign) NSInteger  page;

@end

static NSString *mneCollectionStoreTableViewCell = @"LBMineCollectionStoreTableViewCell";

@implementation LBMineCollectionShopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    adjustsScrollViewInsets_NO(self.tableview, self);
    [self Adds];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(showEditview) name:@"showEditview" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(dismissEditview) name:@"dismissEditview" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshcollectListData) name:@"refreshcollectListData" object:nil];//刷新数据
    
    if ([LBCollectionManager defaultUser].index == 1) {
        [self showEditview];
    }
    
    [self setupNpdata];//设置无数据的时候展示
    [self setuprefrsh];//刷新
}
-(void)setupNpdata{
    WeakSelf;
    self.tableview.tableFooterView = [UIView new];
    
    self.tableview.ly_emptyView = [LYEmptyView emptyViewWithImageStr:@"nodata_pic"
                                                            titleStr:@"暂无数据，点击重新加载"
                                                           detailStr:@""];
    self.tableview.ly_emptyView.imageSize = CGSizeMake(100, 100);
    self.tableview.ly_emptyView.titleLabTextColor = YYSRGBColor(109, 109, 109, 1);
    self.tableview.ly_emptyView.titleLabFont = [UIFont fontWithName:@"MDT_1_95969" size:15];
    self.tableview.ly_emptyView.detailLabFont = [UIFont fontWithName:@"MDT_1_95969" size:13];
    
    
    //emptyView内容上的点击事件监听
    [self.tableview.ly_emptyView setTapContentViewBlock:^{
        weakSelf.page = 1;
        [weakSelf loadData:weakSelf.page refreshDirect:YES];
    }];
}

-(void)setuprefrsh{
    
    [self loadData:1 refreshDirect:YES];
    WeakSelf;
    [LBDefineRefrsh defineRefresh:self.tableview headerrefresh:^{
        weakSelf.page = 1;
        [weakSelf loadData:weakSelf.page refreshDirect:YES];
    } footerRefresh:^{
        if (weakSelf.allCount == weakSelf.dataArr.count && weakSelf.dataArr.count != 0) {
            [EasyShowTextView showInfoText:@"没有数据了"];
            [LBDefineRefrsh dismissRefresh:self.tableview];
        }else{
            [weakSelf loadData:weakSelf.page++ refreshDirect:NO];
        }
    }];
}

-(void)loadData:(NSInteger)page refreshDirect:(BOOL)isDirect{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"app_handler"] = @"SEARCH";
    if ([UserModel defaultUser].loginstatus == YES) {
        dic[@"uid"] = [UserModel defaultUser].uid;
        dic[@"token"] = [UserModel defaultUser].token;
    }
    dic[@"type"] = @([LBCollectionManager defaultUser].storeType);
    dic[@"page"] = @(page);
    
    [NetworkManager requestPOSTWithURLStr:UserUser_collect paramDic:dic finish:^(id responseObject) {
  
        [LBDefineRefrsh dismissRefresh:self.tableview];
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE) {
            self.allCount = [responseObject[@"data"][@"count"] integerValue];
            
            if (isDirect) {
                [self.dataArr removeAllObjects];
            }
            
            for (NSDictionary *dic in responseObject[@"data"][@"page_data"]) {
                LBMineCollectionStoreModel *model = [LBMineCollectionStoreModel mj_objectWithKeyValues:dic];
                [self.dataArr addObject:model];
            }
            
            [self.tableview reloadData];
        }else{
            
            [EasyShowTextView showErrorText:responseObject[@"message"]];
        }
        
    } enError:^(NSError *error) {
        
        [LBDefineRefrsh dismissRefresh:self.tableview];
    }];
    
}

-(void)dismissEditview{
    [self.tableview setEditing:NO animated:YES];
    
    [self showEitingView:NO];
}
-(void)showEditview{
    if (self.dataArr.count == 0) {
        return;
    }
    [self.tableview setEditing:YES animated:YES];
    [self showEitingView:YES];
    
}

//刷新数据
-(void)refreshcollectListData{
    self.page = 1;
    [self loadData:self.page refreshDirect:YES];
}

#pragma mark -- event response

- (void)p__buttonClick:(UIButton *)sender{
    if ([[sender titleForState:UIControlStateNormal] isEqualToString:@"取消收藏"]) {
        NSMutableIndexSet *insets = [[NSMutableIndexSet alloc] init];
        NSMutableArray *deleteArr = [[NSMutableArray alloc] init];
        WeakSelf;
        [[self.tableview indexPathsForSelectedRows] enumerateObjectsUsingBlock:^(NSIndexPath * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [insets addIndex:obj.row];
            [deleteArr addObject:((LBMineCollectionStoreModel*)weakSelf.dataArr[obj.row]).collect_id];
        }];
        if ([UserModel defaultUser].loginstatus == NO) {
            [EasyShowTextView showInfoText:@"请先登录"];
            return;
        }
        if (insets.count <=0) {
            [EasyShowTextView showInfoText:@"未选中商品"];
            return;
        }
        
        [self userCancelCollection:insets deleteArr:deleteArr];
    
        
        /** 数据清空情况下取消编辑状态*/
//        if (self.dataArr.count == 0) {
//            self.navigationItem.rightBarButtonItem.title = @"编辑";
//            [self.tableview setEditing:NO animated:YES];
//            [self showEitingView:NO];
//            /** 带MJ刷新控件重置状态
//             [self.tableView.footer resetNoMoreData];
//             [self.tableView reloadData];
//             */
//        }
        
    }else if ([[sender titleForState:UIControlStateNormal] isEqualToString:@"全选"]) {
        [self.dataArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [self.tableview selectRowAtIndexPath:[NSIndexPath indexPathForRow:idx inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
        }];
        
        [sender setTitle:@"全不选" forState:UIControlStateNormal];
    }else if ([[sender titleForState:UIControlStateNormal] isEqualToString:@"全不选"]){
        [self.tableview reloadData];
        /** 遍历反选
         [[self.tableView indexPathsForSelectedRows] enumerateObjectsUsingBlock:^(NSIndexPath * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
         [self.tableView deselectRowAtIndexPath:obj animated:NO];
         }];
         */
        [sender setTitle:@"全选" forState:UIControlStateNormal];
    }
}


#pragma mark -- addSubView
- (void)Adds{
    
    [self.view addSubview:self.editingView];
    [self.view addSubview:self.tableview];
    
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@1);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.editingView.mas_top);
    }];
    
    [self.editingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.height.equalTo(@50);
        make.bottom.equalTo(self.view).offset(50);
    }];
}


- (void)showEitingView:(BOOL)isShow{
    [self.editingView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(isShow?0:50);
    }];
    [UIView animateWithDuration:0.3 animations:^{
        [self.view layoutIfNeeded];
    }];
}

#pragma mark -- UITabelViewDelegate And DataSource


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    LBMineCollectionStoreTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:mneCollectionStoreTableViewCell forIndexPath:indexPath];
     cell.model = self.dataArr[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.isEditing) {
        return;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([LBCollectionManager defaultUser].storeType == 2) {
        self.hidesBottomBarWhenPushed = YES;
        LBEatShopProdcutClassifyViewController *vc = [[LBEatShopProdcutClassifyViewController alloc]init];
        vc.store_id = ((LBMineCollectionStoreModel*)self.dataArr[indexPath.row]).store_id;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        self.hidesBottomBarWhenPushed = YES;
        LBEat_StoreDetailViewController *vc = [[LBEat_StoreDetailViewController alloc]init];
        vc.store_id = ((LBMineCollectionStoreModel*)self.dataArr[indexPath.section]).store_id;
        vc.titilestr = ((LBMineCollectionStoreModel*)self.dataArr[indexPath.section]).store_name;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
}

//取消收藏
-(void)userCancelCollection:(NSMutableIndexSet*)insets deleteArr:(NSMutableArray*)deleteArr{
   
    NSString *strid = [deleteArr componentsJoinedByString:@","];//#为分隔符
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"app_handler"] = @"DELETE";
    dic[@"collect_id"] = strid;
    if ([UserModel defaultUser].loginstatus == YES) {
        dic[@"uid"] = [UserModel defaultUser].uid;
        dic[@"token"] = [UserModel defaultUser].token;
    }
    dic[@"type"] = @([LBCollectionManager defaultUser].storeType); //1收藏商品 2海淘商城店铺 3吃喝玩乐店铺
    
    [NetworkManager requestPOSTWithURLStr:SeaShoppingNot_collect paramDic:dic finish:^(id responseObject) {
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE) {
            [self.dataArr removeObjectsAtIndexes:insets];
            [self.tableview deleteRowsAtIndexPaths:[self.tableview indexPathsForSelectedRows] withRowAnimation:UITableViewRowAnimationFade];
            [EasyShowTextView showErrorText:responseObject[@"message"]];
        }else{
            
            [EasyShowTextView showErrorText:responseObject[@"message"]];
        }
        
    } enError:^(NSError *error) {
        [EasyShowTextView showErrorText:error.localizedDescription];
    }];
}

- (UIView *)editingView{
    if (!_editingView) {
        _editingView = [[UIView alloc] init];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.backgroundColor = MAIN_COLOR;
        [button setTitle:@"取消收藏" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(p__buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_editingView addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.bottom.equalTo(_editingView);
            make.width.equalTo(_editingView).multipliedBy(1);
        }];
        
    }
    return _editingView;
}
#pragma mark -- getters and setters
- (UITableView *)tableview{
    if (!_tableview) {
        _tableview = [[UITableView alloc] init];
        _tableview.dataSource      = self;
        _tableview.delegate        = self;
        _tableview.backgroundColor = [UIColor groupTableViewBackgroundColor];
        _tableview.tableFooterView = [[UIView alloc] init];
        _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableview.separatorColor = [UIColor whiteColor];
        [self.tableview registerNib:[UINib nibWithNibName:mneCollectionStoreTableViewCell bundle:nil] forCellReuseIdentifier:mneCollectionStoreTableViewCell];
    }
    return _tableview;
}

-(NSMutableArray*)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}
@end
