//
//  LBFinancialCenetrSaleViewController.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/1/22.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "LBFinancialCenetrSaleViewController.h"

@interface LBFinancialCenetrSaleViewController ()
//到账方式
@property (weak, nonatomic) IBOutlet UIButton *payOneBt;
@property (weak, nonatomic) IBOutlet UIButton *payTwoBt;
@property (weak, nonatomic) IBOutlet UIButton *payThreeBt;
@end

@implementation LBFinancialCenetrSaleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = NO;
    self.navigationItem.title = @"出售";
    
    
    
}

-(void)updateViewConstraints{
    [super updateViewConstraints];
    
    [self.payOneBt horizontalCenterTitleAndImage:5];
    [self.payTwoBt horizontalCenterTitleAndImage:5];
    [self.payThreeBt horizontalCenterTitleAndImage:5];

}


@end
