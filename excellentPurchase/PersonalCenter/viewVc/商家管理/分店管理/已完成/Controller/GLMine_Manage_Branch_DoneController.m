//
//  GLMine_Manager_Branch_DoneController.m
//  excellentPurchase
//
//  Created by 龚磊 on 2018/1/24.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "GLMine_Manage_Branch_DoneController.h"
#import "GLMine_Manage_Branch_DoneCell.h"
#import "GLMine_Manage_Branch_DoneModel.h"

@interface GLMine_Manage_Branch_DoneController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong)NSMutableArray *models;

@end

@implementation GLMine_Manage_Branch_DoneController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"GLMine_Manage_Branch_DoneCell" bundle:nil] forCellReuseIdentifier:@"GLMine_Manage_Branch_DoneCell"];
}

#pragma mark -UITableviewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.models.count;
}

-(UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    GLMine_Manage_Branch_DoneCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GLMine_Manage_Branch_DoneCell"];
    cell.selectionStyle = 0;
    
    cell.model = self.models[indexPath.row];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 172;
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
            model.picName = [NSString stringWithFormat:@"我的店%zd",i];
            model.account = [NSString stringWithFormat:@"100%zd",i];
            model.type = [NSString stringWithFormat:@"%zd",i];
            model.month_Money = [NSString stringWithFormat:@"111%zd",i];
            model.total_Money = [NSString stringWithFormat:@"222%zd",i];
            
            [_models addObject:model];
        }
    }
    return _models;
}


@end
