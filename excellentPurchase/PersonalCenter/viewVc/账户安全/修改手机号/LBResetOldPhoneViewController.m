//
//  LBResetOldPhoneViewController.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/1/12.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "LBResetOldPhoneViewController.h"
#import "LBResetNewPhoneViewController.h"

@interface LBResetOldPhoneViewController ()

@end

@implementation LBResetOldPhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"修改绑定手机号";
    self.navigationController.navigationBar.hidden = NO;
}

- (IBAction)NextEvent:(UIButton *)sender {
    self.hidesBottomBarWhenPushed = YES;
    LBResetNewPhoneViewController *vc =[[LBResetNewPhoneViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}


@end
