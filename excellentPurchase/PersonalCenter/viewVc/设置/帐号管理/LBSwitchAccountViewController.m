//
//  LBSwitchAccountViewController.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/1/12.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "LBSwitchAccountViewController.h"
#import "LBSwitchAccountTableViewCell.h"

@interface LBSwitchAccountViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableview;

@end

static NSString *switchAccountTableViewCell = @"LBSwitchAccountTableViewCell";

@implementation LBSwitchAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"帐号管理";
    self.navigationController.navigationBar.hidden = NO;
    //注册cell
    [self.tableview registerNib:[UINib nibWithNibName:switchAccountTableViewCell bundle:nil] forCellReuseIdentifier:switchAccountTableViewCell];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 4;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    LBSwitchAccountTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:switchAccountTableViewCell forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
}
@end
