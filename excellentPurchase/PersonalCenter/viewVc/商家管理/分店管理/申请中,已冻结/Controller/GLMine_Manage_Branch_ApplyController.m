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

@end

@implementation GLMine_Manage_Branch_ApplyController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"GLMine_Manage_Branch_ApplyCell" bundle:nil] forCellReuseIdentifier:@"GLMine_Manage_Branch_ApplyCell"];
}

#pragma mark - GLMine_Manage_Branch_ApplyCellDelegate
//取消申请
- (void)cancelApply:(NSInteger)index{
    NSLog(@"取消申请 --- %zd",index);
}
//解冻账号
- (void)unfrezzAccount:(NSInteger)index{
    NSLog(@"解冻账号 --- %zd",index);
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
        for (int i = 0; i < 7; i ++) {
            
            GLMine_Manage_Branch_DoneModel *model = [[GLMine_Manage_Branch_DoneModel alloc] init];
            model.storeName = @"小仙女的店";
            model.picName = [NSString stringWithFormat:@"我的店%zd",i];
            model.account = [NSString stringWithFormat:@"100%zd",i];
            
            [_models addObject:model];
        }
    }
    return _models;
}

@end
