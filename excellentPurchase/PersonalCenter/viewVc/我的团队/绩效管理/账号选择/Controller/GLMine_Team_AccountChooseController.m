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
@property (nonatomic, strong)NSMutableArray *selectArr;

@end

@implementation GLMine_Team_AccountChooseController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.selectAllBtn horizontalCenterTitleAndImage:5];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"GLMine_Team_AccountChooseCell" bundle:nil] forCellReuseIdentifier:@"GLMine_Team_AccountChooseCell"];
    
    self.navigationItem.title = @"账号选择";
}

/**
 保存
 */
- (IBAction)save:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 全选 或 全部取消

 */
- (IBAction)selectAll:(UIButton *)sender {
    if(self.models.count == 0){
        //[MBProgressHUD showError:@"暂无可选商品"];
        return;
    }
    sender.selected = !sender.selected;
//    float  num = 0;
    [self.selectArr removeAllObjects];
    
    if (sender.selected) {
        for (int i = 0; i < self.models.count; i++) {
            GLMine_Team_AccountChooseModel *model = self.models[i];
            model.isSelected = YES;
//            num = num + [model.marketprice floatValue] * [model.num floatValue];
            
        }
        [self.selectAllBtn setImage:[UIImage imageNamed:@"MyTeam_Select-y2"] forState:UIControlStateNormal];
    }else{
        [self.selectAllBtn setImage:[UIImage imageNamed:@"MyTeam_select-n2"] forState:UIControlStateNormal];
        [self.selectArr removeAllObjects];
        
        if (self.models.count == 0) {
            
            return;
        }
        for (int i = 0; i < self.models.count; i++) {
            GLMine_Team_AccountChooseModel *model = self.models[i];
            model.isSelected = NO;
        }
    }
    
//    self.totalPriceLabel.text = [NSString stringWithFormat:@"总计:¥ %.2f",num];
    
    [self.tableView reloadData];
}

#pragma mark - UITableViewDelegate UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.models.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GLMine_Team_AccountChooseCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GLMine_Team_AccountChooseCell" forIndexPath:indexPath];
    
//    GLMine_Team_AccountChooseModel *model = self.models[indexPath.row];
//    if (indexPath.row == self.selectIndex) {
//        model.isSelected = YES;
//    }
    
    cell.model = self.models[indexPath.row];
    cell.selectionStyle = 0;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GLMine_Team_AccountChooseModel *model = self.models[indexPath.row];
    model.isSelected = !model.isSelected;
//
//    [self.tableView reloadData];
    
    [self.selectArr removeAllObjects];
    
    BOOL  b = NO;
//    float  num = 0;
    
    for (int i = 0; i < self.models.count; i++) {
        GLMine_Team_AccountChooseModel *model = self.models[i];
        
        if (model.isSelected == NO) {
            b = YES;
            
        }else{
//            num = num + [model.marketprice floatValue] * [model.num floatValue];
            [self.selectArr addObject:model];
        }
    }
    
    if (b == YES) {
        
        self.selectAllBtn.selected = NO;
        [self.selectAllBtn setImage:[UIImage imageNamed:@"MyTeam_select-n2"] forState:UIControlStateNormal];
    }else{
        
        self.selectAllBtn.selected = YES;
        [self.selectAllBtn setImage:[UIImage imageNamed:@"MyTeam_Select-y2"] forState:UIControlStateNormal];
    }
//    self.totalPriceLabel.text = [NSString stringWithFormat:@"总计:¥ %.2f",num];
    
//    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:indexPath.row inSection:0], nil] withRowAnimation:UITableViewRowAnimationNone];
    
    [self.tableView reloadData];

    
}

#pragma mark - 懒加载
- (NSMutableArray *)models{
    if (!_models) {
        _models = [NSMutableArray array];
        
        NSArray *arr = @[@"全部",@"会员",@"商家",@"城市创客",@"大区创客",@"省级服务中心",@"市级服务中心",@"区级服务中心"];
        
        for (int i = 0; i < 8 ; i ++) {
            GLMine_Team_AccountChooseModel *model = [[GLMine_Team_AccountChooseModel alloc] init];
            
            model.account = arr[i];
            
            model.idNumber = [NSString stringWithFormat:@"DY102300%zd",i];
            
            model.isSelected = NO;
            
            [_models addObject:model];
        }
    }
    return _models;
}

- (NSMutableArray *)selectArr {
    if (_selectArr == nil) {
        _selectArr = [NSMutableArray array];
    }
    return _selectArr;
}



@end
