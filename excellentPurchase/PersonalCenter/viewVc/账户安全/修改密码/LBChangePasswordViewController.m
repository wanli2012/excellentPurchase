//
//  LBChangePasswordViewController.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/1/12.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "LBChangePasswordViewController.h"

@interface LBChangePasswordViewController ()

@property (weak, nonatomic) IBOutlet UITextField *originalPasswordTF;//原密码
@property (weak, nonatomic) IBOutlet UITextField *passwordNewTF;//新密码
@property (weak, nonatomic) IBOutlet UITextField *ensurePasswordTF;//确认密码
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;


@end

@implementation LBChangePasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = self.naviStr;
    self.navigationController.navigationBar.hidden = NO;

}

/**
 提交
 */
- (IBAction)submit:(id)sender {
    
    
    if (self.originalPasswordTF.text.length <= 0 ) {
        [EasyShowTextView showInfoText:@"请输入原密码"];
        return;
    }
    
    if(self.passwordNewTF.text.length <= 0 ) {
        [EasyShowTextView showInfoText:@"请输入新密码"];
        return;
    }
    
    if(![self.passwordNewTF.text isEqualToString:self.ensurePasswordTF.text]) {
        [EasyShowTextView showInfoText:@"确认密码和新密码不一致"];
        return;
    }
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"app_handler"] = @"UPDATE";
    dic[@"uid"] = [UserModel defaultUser].uid;
    dic[@"token"] = [UserModel defaultUser].token;
    
    NSString *url;
    
    if([self.naviStr isEqualToString:@"修改密码"]){
        
        dic[@"old_pass"] = self.originalPasswordTF.text;
        dic[@"password"] = self.passwordNewTF.text;
        url = kUpdate_Password_URL;
        
    }else if([self.naviStr isEqualToString:@"重置二级密码"]){
        
        dic[@"old_pass"] = self.originalPasswordTF.text;
        dic[@"two_pwd"] = self.passwordNewTF.text;
        dic[@"sure_pwd"] = self.ensurePasswordTF.text;
        url = kReset_Second_Password_URL;
        
    }
    
    self.submitBtn.enabled = NO;
    self.submitBtn.backgroundColor = [UIColor grayColor];
    [EasyShowLodingView showLodingText:@"正在请求..."];
    
    [NetworkManager requestPOSTWithURLStr:url paramDic:dic finish:^(id responseObject) {
        
        [EasyShowLodingView hidenLoding];
        self.submitBtn.enabled = YES;
        self.submitBtn.backgroundColor = MAIN_COLOR;
        
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE) {
            [EasyShowTextView showSuccessText:@"修改成功"];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [EasyShowTextView showErrorText:responseObject[@"message"]];
        }
        
    } enError:^(NSError *error) {
        [EasyShowLodingView hidenLoding];
        self.submitBtn.enabled = YES;
        self.submitBtn.backgroundColor = MAIN_COLOR;
        [EasyShowTextView showErrorText:error.localizedDescription];
    }];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if (textField == self.originalPasswordTF) {
        [self.passwordNewTF becomeFirstResponder];
    }else if(textField == self.passwordNewTF){
        [self.ensurePasswordTF becomeFirstResponder];
    }else if(textField == self.ensurePasswordTF){
        [self.view endEditing:YES];
    }
    
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if (range.length == 1 && string.length == 0) {
        
        return YES;
    }
    
    if ([self.naviStr isEqualToString:@"修改密码"]) {
        if ([predicateModel IsChinese:string]) {
            [self.view endEditing:YES];
            [EasyShowTextView showInfoText:@"此处不能输入汉字"];
            return NO;
        }
    }else{
        if(![predicateModel inputShouldNumber:string]){
            [self.view endEditing:YES];
            [EasyShowTextView showInfoText:@"此处只能输入数字"];
            return NO;
        }
    }
    
    return YES;
}


@end
