//
//  GLMine_Manage_Branch_FailedController.m
//  excellentPurchase
//
//  Created by 龚磊 on 2018/1/24.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "GLMine_Manage_Branch_FailedController.h"
#import "GLMine_Manage_Branch_FailedCell.h"
#import "GLMine_Manage_Branch_DoneModel.h"
#import "GLMine_Management_ResubmitController.h"

@interface GLMine_Manage_Branch_FailedController ()<GLMine_Manage_Branch_FailedCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong)NSMutableArray *models;
@property (nonatomic, assign)NSInteger page;

@end

@implementation GLMine_Manage_Branch_FailedController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"GLMine_Manage_Branch_FailedCell" bundle:nil] forCellReuseIdentifier:@"GLMine_Manage_Branch_FailedCell"];
    [self setupNpdata];//设置无数据的时候展示
    WeakSelf;
    [LBDefineRefrsh defineRefresh:self.tableView headerrefresh:^{
        [weakSelf postRequest:YES];
    } footerRefresh:^{
        [weakSelf postRequest:NO];
    }];
    
    self.page = 1;
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

- (void)postRequest:(BOOL)isRefresh {
    
    if (isRefresh) {
        self.page = 1;
    }else{
        self.page ++;
    }
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"app_handler"] = @"SEARCH";
    dic[@"uid"] = [UserModel defaultUser].uid;
    dic[@"token"] = [UserModel defaultUser].token;
    dic[@"page"] = @(self.page);
    dic[@"status"] = @"2";//查询的状态 1审核中 2申请失败 3已完成 4已冻结
    
    [NetworkManager requestPOSTWithURLStr:kstore_son_list paramDic:dic finish:^(id responseObject) {
        [LBDefineRefrsh dismissRefresh:self.tableView];
        [EasyShowLodingView hidenLoding];
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE) {
            
            if (isRefresh == YES) {
                [self.models removeAllObjects];
            }
            for (NSDictionary *dict in responseObject[@"data"][@"page_data"]) {
                GLMine_Manage_Branch_DoneModel *model = [GLMine_Manage_Branch_DoneModel mj_objectWithKeyValues:dict];
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

#pragma mark - GLMine_Manage_Branch_ApplyCellDelegate  重新申请
- (void)applyAgain:(NSInteger)index{

    GLMine_Manage_Branch_DoneModel *model = self.models[index];
    
    self.hidesBottomBarWhenPushed = YES;
    GLMine_Management_ResubmitController *vc = [[GLMine_Management_ResubmitController alloc] init];
    vc.sid = model.sid;
    
    [self.navigationController pushViewController:vc animated:YES];
    
}

#pragma mark -UITableviewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.models.count;
}

-(UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    GLMine_Manage_Branch_FailedCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GLMine_Manage_Branch_FailedCell"];
    cell.selectionStyle = 0;
    GLMine_Manage_Branch_DoneModel *model = self.models[indexPath.row];
    model.index = indexPath.row;
    
    cell.model = model;
    cell.delegate = self;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    tableView.rowHeight = UITableViewAutomaticDimension;
//    tableView.estimatedRowHeight = 44;
//    return tableView.rowHeight;
    
    return 114;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

#pragma mark -懒加载
- (NSMutableArray *)models{
    if (!_models) {
        _models = [NSMutableArray array];

    }
    return _models;
}

@end
