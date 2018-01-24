//
//  GLMine_ManagementController.m
//  excellentPurchase
//
//  Created by 龚磊 on 2018/1/23.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "GLMine_ManagementController.h"
#import "GLMine_Manage_BranchController.h"//分店管理

@interface GLMine_ManagementController ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewWidth;
@property (weak, nonatomic) IBOutlet UIView *todayView;//当天
@property (weak, nonatomic) IBOutlet UIView *monthView;//当月

@end

@implementation GLMine_ManagementController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"商家管理";
    self.contentViewWidth.constant = UIScreenWidth * 2 - 50.0/750.0 * UIScreenWidth;
    
    self.todayView.layer.shadowColor = [UIColor blackColor].CGColor;//shadowColor阴影颜色
    self.todayView.layer.shadowOffset = CGSizeMake(0,0);//
    self.todayView.layer.shadowOpacity = 0.2;//阴影透明度，默认0
    self.todayView.layer.shadowRadius = 6;//阴影半径，默认3
    
    self.monthView.layer.shadowColor = [UIColor blackColor].CGColor;//shadowColor阴影颜色
    self.monthView.layer.shadowOffset = CGSizeMake(0,0);
    self.monthView.layer.shadowOpacity = 0.2;//阴影透明度，默认0
    self.monthView.layer.shadowRadius = 6;//阴影半径，默认3

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = NO;
}

#pragma mark - 六块主功能
/**
 线上订单
 */
- (IBAction)orderOnline:(id)sender {
    NSLog(@"线上订单");
}

/**
 线下订单
 */
- (IBAction)orderOffline:(id)sender {
    NSLog(@"线下订单");
}

/**
 业绩查询
  */
- (IBAction)queryAchievement:(id)sender {
    NSLog(@"业绩查询");
}

/**
 店铺装修
  */
- (IBAction)storeDecorate:(id)sender {
    NSLog(@"店铺装修");
}

/**
 分店管理
  */
- (IBAction)branchManage:(id)sender {

    self.hidesBottomBarWhenPushed = YES;
    GLMine_Manage_BranchController *vc = [[GLMine_Manage_BranchController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

/**
 收款二维码
  */
- (IBAction)incomeCode:(id)sender {
    NSLog(@"收款二维码");
}

@end
