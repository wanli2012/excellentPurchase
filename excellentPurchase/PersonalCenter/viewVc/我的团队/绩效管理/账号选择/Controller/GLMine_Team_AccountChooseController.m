//
//  GLMine_Team_AccountChooseController.m
//  excellentPurchase
//
//  Created by 龚磊 on 2018/1/18.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "GLMine_Team_AccountChooseController.h"
#import "GLMine_Team_AccountChooseCell.h"
#import "GLMine_Team_AccountChooseModel.h"

@interface GLMine_Team_AccountChooseController ()

@property (weak, nonatomic) IBOutlet UIButton *selectAllBtn;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong)NSMutableArray *models;
@property (nonatomic, strong)NSMutableArray *selectuidArr;
@property (nonatomic, strong)NSMutableArray *selectNameArr;

@end

@implementation GLMine_Team_AccountChooseController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.selectAllBtn horizontalCenterTitleAndImage:5];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"GLMine_Team_AccountChooseCell" bundle:nil] forCellReuseIdentifier:@"GLMine_Team_AccountChooseCell"];
    
    self.navigationItem.title = @"账号选择";
    
    WeakSelf;
    [LBDefineRefrsh defineRefresh:self.tableView headerrefresh:^{
        [weakSelf postRequest:YES];
    }];
    
    [self postRequest:YES];
}

//请求数据
-(void)postRequest:(BOOL)isRefresh{
  
    [EasyShowLodingView showLodingText:@"数据请求中"];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"app_handler"] = @"SEARCH";
    dic[@"uid"] = [UserModel defaultUser].uid;
    dic[@"token"] = [UserModel defaultUser].token;
    dic[@"group_id"] = [UserModel defaultUser].group_id;
    
    [NetworkManager requestPOSTWithURLStr:keamset_list paramDic:dic finish:^(id responseObject) {
        
        [LBDefineRefrsh dismissRefresh:self.tableView];
        [EasyShowLodingView hidenLoding];
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE) {
            
            if(isRefresh){
                [self.models removeAllObjects];
            }
            
            for (NSDictionary *dict in responseObject[@"data"]) {
                GLMine_Team_AccountChooseModel *model = [GLMine_Team_AccountChooseModel mj_objectWithKeyValues:dict];
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


/**
 保存
 */
- (IBAction)save:(id)sender {
    if (self.selectuidArr.count <= 0) {
        [EasyShowTextView showInfoText:@"请选择帐号"];
        return;
    }
    if (self.retureSelecteArr) {
        self.retureSelecteArr(self.selectuidArr,self.selectNameArr);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 全选 或 全部取消

 */
- (IBAction)selectAll:(UIButton *)sender {
    if(self.models.count == 0){
        return;
    }
    sender.selected = !sender.selected;
    [self.selectuidArr removeAllObjects];
    [self.selectNameArr removeAllObjects];
    
    if (sender.selected) {
        for (int i = 0; i < self.models.count; i++) {
            GLMine_Team_AccountChooseModel *model = self.models[i];
            model.isSelected = YES;
            [self.selectuidArr addObject:model.uid];
            if ([NSString StringIsNullOrEmpty:model.truename]) {
                 [self.selectNameArr addObject:model.nickname];
            }else{
                 [self.selectNameArr addObject:model.truename];
            }
        }
        [self.selectAllBtn setImage:[UIImage imageNamed:@"MyTeam_Select-y2"] forState:UIControlStateNormal];
    }else{
        [self.selectAllBtn setImage:[UIImage imageNamed:@"MyTeam_select-n2"] forState:UIControlStateNormal];
        [self.selectuidArr removeAllObjects];
        
        if (self.models.count == 0) {
            
            return;
        }
        for (int i = 0; i < self.models.count; i++) {
            GLMine_Team_AccountChooseModel *model = self.models[i];
            model.isSelected = NO;
        }
    }
    
    [self.tableView reloadData];
}

#pragma mark - UITableViewDelegate UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.models.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GLMine_Team_AccountChooseCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GLMine_Team_AccountChooseCell" forIndexPath:indexPath];
        cell.selectionStyle = 0;
        cell.model = self.models[indexPath.row];

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GLMine_Team_AccountChooseModel *model = self.models[indexPath.row];
    model.isSelected = !model.isSelected;

    [self.selectuidArr removeAllObjects];
    [self.selectNameArr removeAllObjects];
    
    BOOL  b = NO;
    
    for (int i = 0; i < self.models.count; i++) {
        GLMine_Team_AccountChooseModel *model = self.models[i];
        
        if (model.isSelected == NO) {
            b = YES;
            
        }else{
            [self.selectuidArr addObject:model.uid];
            if ([NSString StringIsNullOrEmpty:model.truename]) {
                [self.selectNameArr addObject:model.nickname];
            }else{
                [self.selectNameArr addObject:model.truename];
            }
        }
    }
    
    if (b == YES) {
        
        self.selectAllBtn.selected = NO;
        [self.selectAllBtn setImage:[UIImage imageNamed:@"MyTeam_select-n2"] forState:UIControlStateNormal];
    }else{
        
        self.selectAllBtn.selected = YES;
        [self.selectAllBtn setImage:[UIImage imageNamed:@"MyTeam_Select-y2"] forState:UIControlStateNormal];
    }
    
    [self.tableView reloadData];

    
}

#pragma mark - 懒加载
- (NSMutableArray *)models{
    if (!_models) {
        _models = [NSMutableArray array];
    }
    return _models;
}

- (NSMutableArray *)selectuidArr {
    if (_selectuidArr == nil) {
        _selectuidArr = [NSMutableArray array];
    }
    return _selectuidArr;
}
- (NSMutableArray *)selectNameArr {
    if (_selectNameArr == nil) {
        _selectNameArr = [NSMutableArray array];
    }
    return _selectNameArr;
}

@end
