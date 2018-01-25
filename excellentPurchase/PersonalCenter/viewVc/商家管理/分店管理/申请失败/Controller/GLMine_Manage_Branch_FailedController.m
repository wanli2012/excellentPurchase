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

@interface GLMine_Manage_Branch_FailedController ()<GLMine_Manage_Branch_FailedCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong)NSMutableArray *models;

@end

@implementation GLMine_Manage_Branch_FailedController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"GLMine_Manage_Branch_FailedCell" bundle:nil] forCellReuseIdentifier:@"GLMine_Manage_Branch_FailedCell"];
}

#pragma mark - GLMine_Manage_Branch_ApplyCellDelegate
//重新申请
- (void)applyAgain:(NSInteger)index{
    NSLog(@"重新申请 --- %zd",index);
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
    
    tableView.rowHeight = UITableViewAutomaticDimension;
    tableView.estimatedRowHeight = 44;
    return tableView.rowHeight;
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
        for (int i = 0; i < 7; i ++) {
            
            GLMine_Manage_Branch_DoneModel *model = [[GLMine_Manage_Branch_DoneModel alloc] init];
            model.storeName = @"小仙女的店";
            model.picName = [NSString stringWithFormat:@"我的店%zd",i];
            model.account = [NSString stringWithFormat:@"100%zd",i];
            if(i == 3){
                
                model.reason = @"代理费婚纱礼服经理说的返利哈三联的返回拉师傅拉还是是的发发发";
            }else{
                model.reason = @"代理费婚纱礼服经理";
            }
            
            [_models addObject:model];
        }
    }
    return _models;
}

@end
