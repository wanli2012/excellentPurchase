//
//  GLMine_Cart_PayController.m
//  excellentPurchase
//
//  Created by 龚磊 on 2018/1/23.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "GLMine_Cart_PayController.h"
#import "GLMine_Cart_PayCell.h"
#import "GLMine_Cart_PayModel.h"

@interface GLMine_Cart_PayController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong)NSMutableArray *models;

@end

@implementation GLMine_Cart_PayController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"付款";
    [self.tableView registerNib:[UINib nibWithNibName:@"GLMine_Cart_PayCell" bundle:nil] forCellReuseIdentifier:@"GLMine_Cart_PayCell"];
    
}

#pragma mark - UITableViewDelegate UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.models.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GLMine_Cart_PayCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GLMine_Cart_PayCell" forIndexPath:indexPath];
    
    cell.model = self.models[indexPath.row];
    cell.selectionStyle = 0;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 75;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    for (int i = 0; i < 3; i ++) {
        
        GLMine_Cart_PayModel *model = self.models[i];
        
        if (i == indexPath.row) {
            
            model.isSelected = YES;
        }else{
            model.isSelected = NO;
        }
    }
    
    [tableView reloadData];
}

#pragma mark - 懒加载
- (NSMutableArray *)models{
    if (!_models) {
        _models = [NSMutableArray array];
        
        NSArray *picArr = @[@"pay-zjifubao",@"pay-weixin",@"pay_jifen"];
        NSArray *titleArr = @[@"支付宝支付",@"微信支付",@"余额支付"];
        NSArray *detailArr = @[@"推荐已安装支付宝的用户使用",@"推荐已安装微信的用户使用",@"余额不足"];
        
        for (int i = 0; i < 3; i ++) {
            
            GLMine_Cart_PayModel *model = [[GLMine_Cart_PayModel alloc] init];
            model.picName = picArr[i];
            model.title = titleArr[i];
            model.detail = detailArr[i];
            model.isSelected = NO;
            
            [_models addObject:model];
        }
        
    }
    return _models;
}


@end
