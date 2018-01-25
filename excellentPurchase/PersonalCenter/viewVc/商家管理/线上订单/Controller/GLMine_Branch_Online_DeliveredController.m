//
//  GLMine_Branch_Online_DeliveredController.m
//  excellentPurchase
//
//  Created by 龚磊 on 2018/1/25.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "GLMine_Branch_Online_DeliveredController.h"
#import "GLMine_Branch_OnlineOrderCell.h"
#import "GLMine_Branch_AchievementModel.h"
#import "GLMine_Branch_OnlineHeader.h"
#import "GLMine_Branch_OnlineFooter.h"
#import "GLMine_Seller_OrderDetailController.h"//订单详情

@interface GLMine_Branch_Online_DeliveredController ()<UITableViewDelegate,UITableViewDataSource,GLMine_Branch_OnlineFooterDelegate,GLMine_Branch_OnlineHeaderDelegate>

@property (nonatomic, strong)UITableView *tableView;

//@property (nonatomic, strong)GLMine_Branch_OnlineHeader *headerV;
//
//@property (nonatomic, strong)GLMine_Branch_OnlineFooter *footerV;

@property (nonatomic, strong)NSMutableArray *models;

@end

@implementation GLMine_Branch_Online_DeliveredController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.tableView];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"GLMine_Branch_OnlineOrderCell" bundle:nil] forCellReuseIdentifier:@"GLMine_Branch_OnlineOrderCell"];
}

#pragma mark - GLMine_Branch_OnlineHeaderDelegate 订单详情
- (void)toOrderDetail:(NSInteger)section{
    
    self.hidesBottomBarWhenPushed = YES;
    GLMine_Seller_OrderDetailController *vc = [[GLMine_Seller_OrderDetailController alloc] init];
    vc.type = 3;//1:已下单 2:待发货 3:已发货
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - GLMine_Branch_OnlineFooterDelegate

- (void)cancelOrder:(NSInteger)section{
    NSLog(@"--取消订单-%zd",section);
}

- (void)ensureOrder:(NSInteger)section{
    NSLog(@"--确认订单-%zd",section);
}


#pragma mark -UITableviewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 2;
}

-(UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    GLMine_Branch_OnlineOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GLMine_Branch_OnlineOrderCell"];
    cell.selectionStyle = 0;
    //    cell.model = self.models[indexPath.row];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 120;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    NSString *ID = @"onlineOrderHeaderView";
    
    GLMine_Branch_OnlineHeader *headerview = [tableView dequeueReusableHeaderFooterViewWithIdentifier:ID];
    
    if (!headerview) {
        headerview = [[GLMine_Branch_OnlineHeader alloc] initWithReuseIdentifier:ID];
    }
    headerview.delegate = self;
    return headerview;
    
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{

    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UIScreenWidth, 0.001)];

    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 55;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.001;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //    self.hidesBottomBarWhenPushed = YES;
    //    GLMine_Team_MemberDataController *dataVC = [[GLMine_Team_MemberDataController alloc] init];
    //    [self.navigationController pushViewController:dataVC animated:YES];
    
}

#pragma mark - 懒加载
- (NSMutableArray *)models{
    if (!_models) {
        _models = [NSMutableArray array];
        
        for (int i = 0; i < 2; i ++) {
            
            GLMine_Branch_AchievementModel *model = [[GLMine_Branch_AchievementModel alloc] init];
            model.date = [NSString stringWithFormat:@"2018-01-0%zd",i];
            model.price = @"3333";
            model.remark = @"d搭建浪费时间代理费家拉设计费加啊;地方家拉设计费静安寺防火卷帘撒回复";
            model.submitDate = @"2018-01-02";
            
            //            model.type = self.type;
            [_models addObject:model];
        }
    }
    return _models;
}

#pragma 懒加载
- (UITableView *)tableView{
    
    if (!_tableView) {
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, UIScreenWidth, UIScreenHeight - SafeAreaTopHeight - 50) style:UITableViewStyleGrouped];
        _tableView.backgroundColor = YYSRGBColor(245, 245, 245, 1);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
    }
    return _tableView;
}
@end
