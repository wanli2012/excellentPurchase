//
//  GLIdentifySelectController.m
//  excellentPurchase
//
//  Created by 龚磊 on 2018/1/17.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "GLIdentifySelectController.h"
#import "GLIdentifySelectCell.h"
#import "GLIdentifySelectModel.h"

@interface GLIdentifySelectController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong)NSMutableArray *models;

@end

@implementation GLIdentifySelectController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"身份选择";
    
    [self.tableView registerNib:[UINib nibWithNibName:@"GLIdentifySelectCell" bundle:nil] forCellReuseIdentifier:@"GLIdentifySelectCell"];
    
    //请求数据
    [self requestPost];
}

//请求数据
- (void)requestPost {
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"app_handler"] = @"SEARCH";
    dic[@"type"] = @"1";
    
    [EasyShowLodingView showLodingText:@"正在请求数据"];
    [NetworkManager requestPOSTWithURLStr:kGet_GroupList_URL paramDic:dic finish:^(id responseObject) {
        
        [EasyShowLodingView hidenLoding];
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE) {
            for (NSDictionary *dict in responseObject[@"data"]) {
                
                GLIdentifySelectModel *model = [GLIdentifySelectModel mj_objectWithKeyValues:dict];
                [self.models addObject:model];
                
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

#pragma mark - UITableViewDelegate UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.models.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GLIdentifySelectCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GLIdentifySelectCell" forIndexPath:indexPath];
    
    GLIdentifySelectModel *model = self.models[indexPath.row];
    if (indexPath.row == self.selectIndex) {
        model.isSelected = YES;
    }
    
    cell.model = model;
    cell.selectionStyle = 0;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GLIdentifySelectModel *model = self.models[indexPath.row];
    self.block(model.group_name,model.group_id,indexPath.row);
    [self.navigationController popViewControllerAnimated:YES];
    
}

#pragma mark - 懒加载
- (NSMutableArray *)models{
    if (!_models) {
        _models = [NSMutableArray array];
        
    }
    return _models;
}

@end
