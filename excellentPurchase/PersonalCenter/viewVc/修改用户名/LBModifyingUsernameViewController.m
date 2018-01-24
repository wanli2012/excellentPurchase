//
//  LBModifyingUsernameViewController.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/1/10.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "LBModifyingUsernameViewController.h"

@interface LBModifyingUsernameViewController ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topContrait;
@property (weak, nonatomic) IBOutlet UITextField *nameTF;

@end

@implementation LBModifyingUsernameViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setNav];

}

/**
 导航栏设置
 */
- (void)setNav{
    
    self.topContrait.constant = SafeAreaTopHeight;
    self.navigationItem.title = @"修改用户名";
    
    UIButton *button=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 80, 44)];
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;//右对齐
    
    [button setTitle:@"保存" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont systemFontOfSize:13]];
    button.backgroundColor = [UIColor clearColor];
    [button addTarget:self action:@selector(save) forControlEvents:UIControlEventTouchUpInside];

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
}

/**
 保存
 */
- (void)save{

    self.block(self.nameTF.text);
    
    [self.navigationController popViewControllerAnimated:YES];

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

@end
