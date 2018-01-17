//
//  GLMine_Team_TeamAchievementController.m
//  excellentPurchase
//
//  Created by 龚磊 on 2018/1/17.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "GLMine_Team_TeamAchievementController.h"
#import "GLMine_TeamAchievementCell.h"
#import "GLIdentifySelectController.h"

@interface GLMine_Team_TeamAchievementController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong)NSMutableArray *models;

@property (nonatomic, copy)NSString *group_id;

@property (nonatomic, strong)UIButton *rightBtn;

@end

@implementation GLMine_Team_TeamAchievementController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setNav];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"GLMine_TeamAchievementCell" bundle:nil] forCellReuseIdentifier:@"GLMine_TeamAchievementCell"];
    
}

/**
 导航栏设置
 */
- (void)setNav{
    self.navigationItem.title = @"团队业绩";
    
    UIButton *button=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 80, 44)];
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;//右对齐
    
    [button setTitle:@"筛选" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont systemFontOfSize:13]];
    button.backgroundColor = [UIColor clearColor];
    [button addTarget:self action:@selector(filter) forControlEvents:UIControlEventTouchUpInside];
    self.rightBtn = button;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.rightBtn];
}

/**
 筛选
 */
- (void)filter{
  
    self.hidesBottomBarWhenPushed = YES;
    GLIdentifySelectController *idSelectVC = [[GLIdentifySelectController alloc] init];
    idSelectVC.selectIndex = [self.group_id integerValue];
    __weak typeof(self) weakSelf = self;
    idSelectVC.block = ^(NSString *name,NSString *group_id) {
        
        [weakSelf.rightBtn setTitle:name forState:UIControlStateNormal];
        weakSelf.group_id = group_id;
        
    };
    
    [self.navigationController pushViewController:idSelectVC animated:YES];
}

#pragma mark - UITableViewDelegate UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.models.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GLMine_TeamAchievementCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GLMine_TeamAchievementCell" forIndexPath:indexPath];
    
    cell.model = self.models[indexPath.row];
    cell.selectionStyle = 0;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

#pragma mark - 懒加载
- (NSMutableArray *)models{
    if (!_models) {
        _models = [NSMutableArray array];
        for (int i = 0; i < 10 ; i ++) {
            GLMine_TeamAchievementModel *model = [[GLMine_TeamAchievementModel alloc] init];
            model.name = [NSString stringWithFormat:@"磊哥%zd",i];
            model.picName = [NSString stringWithFormat:@"磊哥%zd",i];
            model.ID = [NSString stringWithFormat:@"DY1000%zd",i];
            model.consume = [NSString stringWithFormat:@"778%zd",i];
            model.type = [NSString stringWithFormat:@"%zd",i%3];
            [_models addObject:model];
        }
    }
    return _models;
}

@end
