//
//  GLMine_Branch_AccountManageController.m
//  excellentPurchase
//
//  Created by 龚磊 on 2018/1/25.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "GLMine_Branch_AccountManageController.h"

@interface GLMine_Branch_AccountManageController ()<UITextFieldDelegate>
{
    BOOL _isAgressProtocol;
}

@property (weak, nonatomic) IBOutlet UIImageView *signImageV;
@property (weak, nonatomic) IBOutlet UITextField *passwordNewTF;
@property (weak, nonatomic) IBOutlet UITextField *ensureTF;
@property (weak, nonatomic) IBOutlet UITextField *secondPwdTF;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewHeight;

@end

@implementation GLMine_Branch_AccountManageController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"账号管理";
    
    self.contentViewHeight.constant = UIScreenHeight - SafeAreaTopHeight;
}

/**
 是否同意免责协议
 */
- (IBAction)isAgressProtocol:(id)sender {
    _isAgressProtocol = !_isAgressProtocol;
    if(_isAgressProtocol){
        self.signImageV.image = [UIImage imageNamed:@"greetselect-y"];
    }else{
       self.signImageV.image = [UIImage imageNamed:@"greetselect-n"];
    }
}

/**
 免责协议
 */
- (IBAction)reliefPromise:(id)sender {
    self.hidesBottomBarWhenPushed = YES;
    LLWebViewController *webVC = [[LLWebViewController alloc] initWithUrl:kProtocol_URL];
    webVC.titilestr = @"服务条款";
    [self.navigationController pushViewController:webVC animated:YES];
}

/**
 确认修改
 */
- (IBAction)save:(id)sender {
    
}

#pragma UITextFieldDelegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if (textField == self.passwordNewTF) {
        [self.ensureTF becomeFirstResponder];
    }else if(textField == self.ensureTF){
        [self.secondPwdTF becomeFirstResponder];
    }else{
        [self.view endEditing:YES];
    }
    
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    
    return YES;
}

@end
