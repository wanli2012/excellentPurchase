//
//  LBSetUpViewController.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/1/12.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "LBSetUpViewController.h"
#import "LBSetUpTableViewCell.h"
#import "LBAboutUsViewController.h"
#import "LBAccountSecurityViewController.h"
#import "LBSwitchAccountViewController.h"

@interface LBSetUpViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableview;

/**
 退出
 */
@property (weak, nonatomic) IBOutlet UIButton *exitBt;

/**
 版本
 */
@property (weak, nonatomic) IBOutlet UILabel *versionLb;

/**
 数据
 */
@property (strong, nonatomic) NSArray *dataArr;

@end

static NSString *setUpTableViewCell = @"LBSetUpTableViewCell";

@implementation LBSetUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"设置";
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
    
    if ([self.dataArr[indexPath.row] isEqualToString:@"账户管理"]) {
        cell.headimage.hidden = NO;
        cell.arrowImage.hidden = NO;
        cell.cacheLB.hidden = YES;
    }else if ([self.dataArr[indexPath.row] isEqualToString:@"清除缓存"]){
        cell.headimage.hidden = YES;
        cell.arrowImage.hidden = YES;
        cell.cacheLB.hidden = NO;
    }else{
        cell.headimage.hidden = YES;
        cell.arrowImage.hidden = NO;
        cell.cacheLB.hidden = YES;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([self.dataArr[indexPath.row] isEqualToString:@"账户管理"]) {
        self.hidesBottomBarWhenPushed = YES;
        LBSwitchAccountViewController *vc =[[LBSwitchAccountViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([self.dataArr[indexPath.row] isEqualToString:@"安全管理"]){
        self.hidesBottomBarWhenPushed = YES;
        LBAccountSecurityViewController *vc =[[LBAccountSecurityViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([self.dataArr[indexPath.row] isEqualToString:@"清除缓存"]){
        
    }else if ([self.dataArr[indexPath.row] isEqualToString:@"关于"]){
        self.hidesBottomBarWhenPushed = YES;
        LBAboutUsViewController *vc =[[LBAboutUsViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];

    }else if ([self.dataArr[indexPath.row] isEqualToString:@"检查版本更新"]){
        
    }
}

-(void)updateViewConstraints{
    [super updateViewConstraints];
    self.exitBt.layer.cornerRadius = 4;
    self.exitBt.layer.borderWidth = 0.5;
    self.exitBt.layer.borderColor = YYSRGBColor(254, 102, 102, 1).CGColor;
}

-(NSArray*)dataArr{
    if (!_dataArr) {
        _dataArr = [NSArray arrayWithObjects:@"账户管理",@"安全管理",@"清除缓存",@"关于",@"检查版本更新", nil];
    }
    return _dataArr;
}
@end
