//
//  GLMine_Branch_OfflineStatusController.m
//  excellentPurchase
//
//  Created by 龚磊 on 2018/1/25.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "GLMine_Branch_OfflineStatusController.h"
#import "GLMine_Branch_OfflineCell.h"
#import "GLMine_Branch_OfflineOrderModel.h"

#import "GLMine_Branch_Offline_PlaceOrderController.h"//线下下单

@interface GLMine_Branch_OfflineStatusController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong)UITableView *tableView;

@property (nonatomic, strong)NSMutableArray *models;

@end

@implementation GLMine_Branch_OfflineStatusController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.tableView];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"GLMine_Branch_OfflineCell" bundle:nil] forCellReuseIdentifier:@"GLMine_Branch_OfflineCell"];
}


#pragma mark - GLMine_Branch_OnlineFooterDelegate

- (void)cancelOrder:(NSInteger)section{
    NSLog(@"--取消订单-%zd",section);
}

- (void)ensureOrder:(NSInteger)section{
    NSLog(@"--确认订单-%zd",section);
}


#pragma mark -UITableviewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 2;
}

-(UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    GLMine_Branch_OfflineCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GLMine_Branch_OfflineCell"];
    cell.selectionStyle = 0;
    cell.model = self.models[indexPath.row];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 170;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(self.type == 2){
            self.hidesBottomBarWhenPushed = YES;
            GLMine_Branch_Offline_PlaceOrderController *vc = [[GLMine_Branch_Offline_PlaceOrderController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
    }
    
    
}

#pragma mark - 懒加载
- (NSMutableArray *)models{
    if (!_models) {
        _models = [NSMutableArray array];
        
        for (int i = 0; i < 2; i ++) {
            
            GLMine_Branch_OfflineOrderModel *model = [[GLMine_Branch_OfflineOrderModel alloc] init];
            model.date = [NSString stringWithFormat:@"2018-01-0%zd",i];
            model.orderNum = [NSString stringWithFormat:@"1000%zd",i];
            model.IDNum = @"233323";
            model.consume = @"333";
            model.noPorfit = @"33";
            
            model.type = self.type;
            [_models addObject:model];
        }
    }
    return _models;
}

#pragma 懒加载
- (UITableView *)tableView{
    
    if (!_tableView) {
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, UIScreenWidth, UIScreenHeight - SafeAreaTopHeight - 50) style:UITableViewStylePlain];
        
        _tableView.backgroundColor = YYSRGBColor(245, 245, 245, 1);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
    }
    return _tableView;
}

@end
