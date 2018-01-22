//
//  GLMine_Message_LogisticsController.m
//  excellentPurchase
//
//  Created by 龚磊 on 2018/1/20.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "GLMine_Message_LogisticsController.h"
#import "GLMine_Message_LogisticsCell.h"
#import "GLMine_Message_LogisticsModel.h"

@interface GLMine_Message_LogisticsController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong)NSMutableArray *models;


@end

@implementation GLMine_Message_LogisticsController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"物流信息";
    [self.tableView registerNib:[UINib nibWithNibName:@"GLMine_Message_LogisticsCell" bundle:nil] forCellReuseIdentifier:@"GLMine_Message_LogisticsCell"];
}

#pragma mark - UITableViewDelegate UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.models.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GLMine_Message_LogisticsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GLMine_Message_LogisticsCell" forIndexPath:indexPath];
   
    cell.model = self.models[indexPath.row];
    cell.selectionStyle = 0;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    self.hidesBottomBarWhenPushed = YES;
    
    //    GLMine_Team_UnderlingDetailController *vc = [[GLMine_Team_UnderlingDetailController alloc] init];
    //    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark -懒加载
- (NSMutableArray *)models{
    if (!_models) {
        _models = [NSMutableArray array];
        for (int i = 0; i < 8; i ++) {
            GLMine_Message_LogisticsModel *model = [[GLMine_Message_LogisticsModel alloc] init];
            model.status = @"已签收";
            model.picName = [NSString stringWithFormat:@"%zd",i];
            model.goodsName = [NSString stringWithFormat:@"毛衣%zd",i];
            model.date = [NSString stringWithFormat:@"2018-01-0%zd",i];
            model.orderNumber = [NSString stringWithFormat:@"1000000%zd",i];
            [_models addObject:model];
        }
    }
    return _models;
}

@end
