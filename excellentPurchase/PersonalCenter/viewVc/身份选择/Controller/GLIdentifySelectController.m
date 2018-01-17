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
    
    cell.model = self.models[indexPath.row];
    cell.selectionStyle = 0;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GLIdentifySelectModel *model = self.models[indexPath.row];
    self.block(model.title,model.group_id);
    [self.navigationController popViewControllerAnimated:YES];
    
}

#pragma mark - 懒加载
- (NSMutableArray *)models{
    if (!_models) {
        _models = [NSMutableArray array];
        
        NSArray *arr = @[@"全部",@"会员",@"商家",@"城市创客",@"大区创客",@"省级服务中心",@"市级服务中心",@"区级服务中心"];
        
        for (int i = 0; i < 8 ; i ++) {
            GLIdentifySelectModel *model = [[GLIdentifySelectModel alloc] init];
            
            model.title = arr[i];
           
            model.group_id = [NSString stringWithFormat:@"%zd",i];
            
            model.isSelected = NO;
            
            [_models addObject:model];
        }
    }
    return _models;
}

@end
