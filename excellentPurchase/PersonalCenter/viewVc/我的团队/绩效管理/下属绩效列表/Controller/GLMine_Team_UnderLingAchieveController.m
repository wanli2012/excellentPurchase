//
//  GLMine_Team_UnderLingAchieveController.m
//  excellentPurchase
//
//  Created by 龚磊 on 2018/1/19.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "GLMine_Team_UnderLingAchieveController.h"
#import "GLMine_Team_UnderlingAchieveModel.h"
#import "GLMine_Team_UnderlingAchieveCell.h"

@interface GLMine_Team_UnderLingAchieveController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong)NSMutableArray *models;

@end

@implementation GLMine_Team_UnderLingAchieveController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"下属绩效列表";
    
    [self.tableView registerNib:[UINib nibWithNibName:@"GLMine_Team_UnderlingAchieveCell" bundle:nil] forCellReuseIdentifier:@"GLMine_Team_UnderlingAchieveCell"];
    
}

#pragma mark - UITableViewDelegate UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.models.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GLMine_Team_UnderlingAchieveCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GLMine_Team_UnderlingAchieveCell" forIndexPath:indexPath];
    
    cell.model = self.models[indexPath.row];
    cell.selectionStyle = 0;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

#pragma mark - 懒加载
- (NSMutableArray *)models{
    if (!_models) {
        _models = [NSMutableArray array];
        
        for (int i = 0; i < 9 ; i ++) {
            GLMine_Team_UnderlingAchieveModel *model = [[GLMine_Team_UnderlingAchieveModel alloc] init];
            model.money = [NSString stringWithFormat:@"100%zd",i];
            model.date = [NSString stringWithFormat:@"2018-09-0%zd",i];
           
            [_models addObject:model];
        }
    }
    return _models;
}

@end
