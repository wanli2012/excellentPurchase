//
//  GLMine_MyWalletController.m
//  excellentPurchase
//
//  Created by 龚磊 on 2018/1/25.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "GLMine_MyWalletController.h"
#import "LBSetUpTableViewCell.h"

@interface GLMine_MyWalletController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong)UITableView *tableView;

@end

@implementation GLMine_MyWalletController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.tableView];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"LBSetUpTableViewCell" bundle:nil] forCellReuseIdentifier:@"LBSetUpTableViewCell"];
}

#pragma mark -UITableviewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 2;
}

-(UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    LBSetUpTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LBSetUpTableViewCell"];
    cell.selectionStyle = 0;
    
    if (indexPath.row == 0) {
        cell.titleLb.text = @"转赠";
    }else if(indexPath.row == 1){
        cell.titleLb.text = @"发红包";
    }else{
        cell.titleLb.text = @"充值中心";
    }
    
    //    cell.model = self.models[indexPath.row];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 120;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //    self.hidesBottomBarWhenPushed = YES;
    //    GLMine_Team_MemberDataController *dataVC = [[GLMine_Team_MemberDataController alloc] init];
    //    [self.navigationController pushViewController:dataVC animated:YES];
    
}

#pragma mark - 懒加载
//- (NSMutableArray *)models{
//    if (!_models) {
//        _models = [NSMutableArray array];
//
//        for (int i = 0; i < 2; i ++) {
//
//            GLMine_Branch_AchievementModel *model = [[GLMine_Branch_AchievementModel alloc] init];
//            model.date = [NSString stringWithFormat:@"2018-01-0%zd",i];
//            model.price = @"3333";
//            model.remark = @"d搭建浪费时间代理费家拉设计费加啊;地方家拉设计费静安寺防火卷帘撒回复";
//            model.submitDate = @"2018-01-02";
//
//            //            model.type = self.type;
//            [_models addObject:model];
//        }
//    }
//    return _models;
//}

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
