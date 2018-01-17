//
//  LBAddBankCardViewController.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/1/12.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "LBAddBankCardViewController.h"
#import "LBChooseBankTypeView.h"

@interface LBAddBankCardViewController ()

@end

@implementation LBAddBankCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"添加银行卡";
    self.navigationController.navigationBar.hidden = NO;
    
}

/**
 选择银行卡类型
 */
- (IBAction)ChooseBankType:(UITapGestureRecognizer *)sender {
    [self.view endEditing:YES];
    [LBChooseBankTypeView areaPickerViewWithAreaBlock:^(NSString *bankType, NSString *bankcardType) {
        
    }];
    
}


@end
