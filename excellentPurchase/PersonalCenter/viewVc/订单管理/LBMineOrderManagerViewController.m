//
//  LBMineOrderManagerViewController.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/1/22.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "LBMineOrderManagerViewController.h"
#import "LBMineOrderMainViewController.h"

@interface LBMineOrderManagerViewController ()

@end

@implementation LBMineOrderManagerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = NO;
    self.navigationItem.title = @" 订单管理";
    
}

/**
 淘淘商城订单

 @param sender <#sender description#>
 */
- (IBAction)tapgestureTmallOders:(UITapGestureRecognizer *)sender {
    
    self.hidesBottomBarWhenPushed = YES;
    LBMineOrderMainViewController *vc =[[LBMineOrderMainViewController alloc]init];
    vc.titilestr = @"淘淘订单";
    [self.navigationController pushViewController:vc animated:YES];
    
}

/**
 吃喝玩乐订单

 @param sender <#sender description#>
 */
- (IBAction)tapgestureEatOrders:(UITapGestureRecognizer *)sender {
    
    
}

@end
