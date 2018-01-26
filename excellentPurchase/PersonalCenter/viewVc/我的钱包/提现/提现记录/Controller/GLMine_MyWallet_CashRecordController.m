//
//  GLMine_MyWallet_CashRecordController.m
//  excellentPurchase
//
//  Created by 龚磊 on 2018/1/26.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "GLMine_MyWallet_CashRecordController.h"
#import "GLMine_MyWallet_CashRecordCell.h"

@interface GLMine_MyWallet_CashRecordController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation GLMine_MyWallet_CashRecordController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"提现记录";
    [self.tableView registerNib:[UINib nibWithNibName:@"GLMine_MyWallet_CashRecordCell" bundle:nil] forCellReuseIdentifier:@"GLMine_MyWallet_CashRecordCell"];
}

#pragma mark -UITableviewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 8;
}

-(UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    GLMine_MyWallet_CashRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GLMine_MyWallet_CashRecordCell"];
    
    cell.selectionStyle = 0;
    
//    cell.model = self.models[indexPath.row];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    tableView.rowHeight = UITableViewAutomaticDimension;
    tableView.estimatedRowHeight = 44;
    
    return tableView.rowHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    self.hidesBottomBarWhenPushed = YES;
//    GLMine_Team_MemberDataController *dataVC = [[GLMine_Team_MemberDataController alloc] init];
//    [self.navigationController pushViewController:dataVC animated:YES];
    
}



@end
