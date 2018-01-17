//
//  LBChangeSecondaryPasswordVc.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/1/12.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "LBChangeSecondaryPasswordVc.h"
#import "LBSetUpTableViewCell.h"
#import "LBFindSecondPassWordViewController.h"
#import "LBChangePasswordViewController.h"

@interface LBChangeSecondaryPasswordVc ()

@property (weak, nonatomic) IBOutlet UITableView *tableview;
/**
 数据
 */
@property (strong, nonatomic) NSArray *dataArr;

@end

static NSString *setUpTableViewCell = @"LBSetUpTableViewCell";

@implementation LBChangeSecondaryPasswordVc

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"修改二级密码";
    self.navigationController.navigationBar.hidden = NO;
    //注册cell
    [self.tableview registerNib:[UINib nibWithNibName:setUpTableViewCell bundle:nil] forCellReuseIdentifier:setUpTableViewCell];
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    LBSetUpTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:setUpTableViewCell forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.titleLb.text = self.dataArr[indexPath.row];
    
    cell.headimage.hidden = YES;
    cell.arrowImage.hidden = NO;
    cell.cacheLB.hidden = YES;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([self.dataArr[indexPath.row] isEqualToString:@"重置二级密码"]) {
        self.hidesBottomBarWhenPushed = YES;
        LBFindSecondPassWordViewController *vc =[[LBFindSecondPassWordViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([self.dataArr[indexPath.row] isEqualToString:@"找回二级密码"]){
        self.hidesBottomBarWhenPushed = YES;
        LBChangePasswordViewController *vc =[[LBChangePasswordViewController alloc]init];
        vc.naviStr = @"重置二级密码";
        [self.navigationController pushViewController:vc animated:YES];
    }
}


-(NSArray*)dataArr{
    if (!_dataArr) {
        _dataArr = [NSArray arrayWithObjects:@"重置二级密码",@"找回二级密码", nil];
    }
    return _dataArr;
}
@end
