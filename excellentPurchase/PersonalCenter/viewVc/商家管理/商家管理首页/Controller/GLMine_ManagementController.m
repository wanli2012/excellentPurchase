//
//  GLMine_ManagementController.m
//  excellentPurchase
//
//  Created by 龚磊 on 2018/1/23.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "GLMine_ManagementController.h"
#import "GLMine_ManagementCell.h"

@interface GLMine_ManagementController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftViewWidth;

@end

@implementation GLMine_ManagementController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"商家管理";
    
    self.leftViewWidth.constant = UIScreenWidth - 60;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"GLMine_ManagementCell" bundle:nil] forCellReuseIdentifier:@"GLMine_ManagementCell"];
    
}

#pragma mark - UITableViewDelegate UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 7;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GLMine_ManagementCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GLMine_ManagementCell" forIndexPath:indexPath];
    
//    cell.model = self.models[indexPath.row];
    cell.selectionStyle = 0;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 75;
}


@end
