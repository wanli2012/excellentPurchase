//
//  GLMine_PropertyController.m
//  excellentPurchase
//
//  Created by 龚磊 on 2018/1/23.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "GLMine_PropertyController.h"
#import "GLMine_PropertyCell.h"

@interface GLMine_PropertyController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, copy)NSArray *titlesArr;
@property (nonatomic, copy)NSArray *valuesArr;

@end

@implementation GLMine_PropertyController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"我的资产";

    self.titlesArr = @[@"积分",@"余额",@"购物券",@"优宝",@"优宝单价",@"昨日营业额总量",@"新增积分总量",@"昨日优购币转化"];
    self.valuesArr = @[@"23222",@"11",@"0",@"1",@"1",@"2",@"3",@"4444"];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"GLMine_PropertyCell" bundle:nil] forCellReuseIdentifier:@"GLMine_PropertyCell"];
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = NO;
    
}

#pragma mark - UITableViewDelegate UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.titlesArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GLMine_PropertyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GLMine_PropertyCell" forIndexPath:indexPath];
    cell.titleLabel.text = self.titlesArr[indexPath.row];
    cell.valueLabel.text = self.valuesArr[indexPath.row];
//    cell.model = self.models[indexPath.row];
    cell.selectionStyle = 0;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

@end
