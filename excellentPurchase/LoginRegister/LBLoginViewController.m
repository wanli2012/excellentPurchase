//
//  LBLoginViewController.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/1/10.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "LBLoginViewController.h"

@interface LBLoginViewController ()
@property (weak, nonatomic) IBOutlet UIView *accountView;//用户名view
@property (weak, nonatomic) IBOutlet UIView *passwordView;//密码view
@property (weak, nonatomic) IBOutlet UIView *identifyView;//身份view
@property (weak, nonatomic) IBOutlet UIButton *loginBt;//登录按钮

@end

@implementation LBLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
}

/**
 注册
 */
- (IBAction)registerEvent:(UITapGestureRecognizer *)sender {
    
}
/**
忘记密码
 */
- (IBAction)forgetSecretEvent:(UITapGestureRecognizer *)sender {
}

/**
 展示身份信息

 */
- (IBAction)showIdentifyListEvent:(UIButton *)sender {
}

/**
 密码是否可见

 */
- (IBAction)showSecretEvent:(UIButton *)sender {
    sender.selected = !sender.selected;
}

-(void)updateViewConstraints{
    [super updateViewConstraints];
    
    self.accountView.layer.cornerRadius = 3;
    self.passwordView.layer.cornerRadius = 3;
    self.identifyView.layer.cornerRadius = 3;
    self.loginBt.layer.cornerRadius = 3;
    
}

@end
