//
//  GLMine_Manage_Branch_ApplyController.m
//  excellentPurchase
//
//  Created by 龚磊 on 2018/1/24.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "GLMine_Manage_Branch_ApplyController.h"
#import "GLMine_Manage_Branch_ApplyCell.h"
#import "GLMine_Manage_Branch_DoneModel.h"

@interface GLMine_Manage_Branch_ApplyController ()<GLMine_Manage_Branch_ApplyCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong)NSMutableArray *models;
@property (nonatomic, assign)NSInteger page;

@end

@implementation GLMine_Manage_Branch_ApplyController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"GLMine_Manage_Branch_ApplyCell" bundle:nil] forCellReuseIdentifier:@"GLMine_Manage_Branch_ApplyCell"];
    [self setupNpdata];//设置无数据的时候展示
    WeakSelf;
    [LBDefineRefrsh defineRefresh:self.tableView headerrefresh:^{
        [weakSelf postRequest:YES];
    } footerRefresh:^{
        [weakSelf postRequest:NO];
    }];
    
    self.page = 1;
    [self postRequest:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData) name:@"UnfreezeAccountNotification" object:nil];
}

- (void)refreshData{
    [self postRequest:YES];
}
- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
    dic[@"status"] = @(self.type);//查询的状态 1审核中 2申请失败 3已完成 4已冻结
    
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

#pragma mark - GLMine_Manage_Branch_ApplyCellDelegate
//取消申请
- (void)cancelApply:(NSInteger)index{
    NSLog(@"取消申请 --- %zd",index);
}

//解冻账号
- (void)unfrezzAccount:(NSInteger)index{

    WeakSelf;
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"你确定要解冻该账号吗?" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        GLMine_Manage_Branch_DoneModel *model = weakSelf.models[index];
        
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[@"app_handler"] = @"UPDATE";
        dict[@"uid"] = [UserModel defaultUser].uid;
        dict[@"token"] = [UserModel defaultUser].token;
        dict[@"sid"] = model.sid;//商铺id
        dict[@"type"] = @"1";//1解冻商铺 2冻结商户
        
        [EasyShowLodingView showLoding];
        [NetworkManager requestPOSTWithURLStr:kstore_branch_frozen paramDic:dict finish:^(id responseObject) {
            
            [EasyShowLodingView hidenLoding];
            if ([responseObject[@"code"] integerValue] == SUCCESS_CODE) {
                
                [EasyShowTextView showInfoText:@"解冻成功"];
                [weakSelf postRequest:YES];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"UnfreezeAccountNotification" object:nil];
                
            }else{
                
                [EasyShowTextView showErrorText:responseObject[@"message"]];
            }
            
        } enError:^(NSError *error) {
            
            [EasyShowLodingView hidenLoding];
            [EasyShowTextView showErrorText:error.localizedDescription];
        }];
        
    }];
    
    [alertVC addAction:cancel];
    [alertVC addAction:ok];
    [self presentViewController:alertVC animated:YES completion:nil];
}

#pragma mark -UITableviewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.models.count;
}

-(UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    GLMine_Manage_Branch_ApplyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GLMine_Manage_Branch_ApplyCell"];
    cell.selectionStyle = 0;
    cell.delegate = self;
    GLMine_Manage_Branch_DoneModel *model = self.models[indexPath.row];
    model.index = indexPath.row;
    
    if (self.type == 1) {//1:申请中 0:已冻结
        model.controllerType = 1;
    }else{
        model.controllerType = 2;
    }
    
    cell.model = model;
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    tableView.rowHeight = UITableViewAutomaticDimension;
//    tableView.estimatedRowHeight = 44;
    return 170;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //    self.hidesBottomBarWhenPushed = YES;
    //    GLMine_Team_MemberDataController *dataVC = [[GLMine_Team_MemberDataController alloc] init];
    //    [self.navigationController pushViewController:dataVC animated:YES];
    
}

#pragma mark -懒加载
- (NSMutableArray *)models{
    if (!_models) {
        _models = [NSMutableArray array];
        
    }
    return _models;
}

@end
