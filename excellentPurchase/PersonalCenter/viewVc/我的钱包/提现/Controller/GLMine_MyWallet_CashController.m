//
//  GLMine_MyWallet_CashController.m
//  excellentPurchase
//
//  Created by 龚磊 on 2018/1/26.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "GLMine_MyWallet_CashController.h"
#import "GLMine_MyWallet_CashRecordController.h"//提交记录

@interface GLMine_MyWallet_CashController ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewHeight;//contentView高度

@property (weak, nonatomic) IBOutlet UILabel *bankNameLabel;//银行名
@property (weak, nonatomic) IBOutlet UILabel *cardNumLabel;//银行卡号
@property (weak, nonatomic) IBOutlet UIImageView *iconImageV;//银行icon

@property (weak, nonatomic) IBOutlet UIView *addCardView;//添加view

//@property (weak, nonatomic) IBOutlet UILabel *exchangeLabel;
//@property (weak, nonatomic) IBOutlet UIImageView *arrowImageV;

@end

@implementation GLMine_MyWallet_CashController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNav];
    
    self.contentViewHeight.constant = UIScreenHeight - SafeAreaTopHeight;
}

/**
 导航栏设置
 */
- (void)setNav{
    self.navigationItem.title = @"提现";
    
    UIButton *button=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 80, 44)];
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;//右对齐
    
    [button setTitle:@"记录" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont systemFontOfSize:13]];
    button.backgroundColor = [UIColor clearColor];
    [button addTarget:self action:@selector(record) forControlEvents:UIControlEventTouchUpInside];
//    self.rightBtn = button;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
}

/**
 记录
 */
- (void)record{

    self.hidesBottomBarWhenPushed = YES;
    GLMine_MyWallet_CashRecordController *idSelectVC = [[GLMine_MyWallet_CashRecordController alloc] init];
    [self.navigationController pushViewController:idSelectVC animated:YES];
}


@end
