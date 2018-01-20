//
//  GLMine_Team_MemberListController.m
//  excellentPurchase
//
//  Created by 龚磊 on 2018/1/19.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "GLMine_Team_MemberListController.h"
#import "GLMine_Team_AchieveManageCell.h"
#import "GLMine_Team_AchieveManageModel.h"

#import "GLMine_Team_MemberDataController.h"

@interface GLMine_Team_MemberListController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong)NSMutableArray *models;

@end

@implementation GLMine_Team_MemberListController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"GLMine_Team_AchieveManageCell" bundle:nil] forCellReuseIdentifier:@"GLMine_Team_AchieveManageCell"];
}

#pragma mark -UITableviewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.models.count;
}

-(UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    GLMine_Team_AchieveManageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GLMine_Team_AchieveManageCell"];
    cell.selectionStyle = 0;
    cell.model = self.models[indexPath.row];

    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 90;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.hidesBottomBarWhenPushed = YES;
    GLMine_Team_MemberDataController *dataVC = [[GLMine_Team_MemberDataController alloc] init];
    [self.navigationController pushViewController:dataVC animated:YES];
}

#pragma mark - 懒加载
- (NSMutableArray *)models{
    if (!_models) {
        _models = [NSMutableArray array];
        for (int i = 0; i < 10; i ++) {
            GLMine_Team_AchieveManageModel *model = [[GLMine_Team_AchieveManageModel alloc] init];
            model.picName = [NSString stringWithFormat:@"图片%zd",i];
            model.name =[NSString stringWithFormat:@"磊哥%zd",i];
            model.IDNumber = [NSString stringWithFormat:@"10000%zd",i];
            model.group_id = [NSString stringWithFormat:@"会员%zd",i];
            model.phone = [NSString stringWithFormat:@"1851336612%zd",i];
            model.date = [NSString stringWithFormat:@"2018-01-%zd",i];
            
            model.setType = @"未布置";
            model.done_Achieve = @"1000";
            
            model.cellType = i%2;
            [_models addObject:model];
            
        }
    }
    return _models;
}

@end
