//
//  LBFindSecondPassWordViewController.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/1/12.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "LBFindSecondPassWordViewController.h"

@interface LBFindSecondPassWordViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstrait;
@property (weak, nonatomic) IBOutlet UITextField *codeTF;//验证码
@property (weak, nonatomic) IBOutlet UITextField *passwordNewTF;//密码
@property (weak, nonatomic) IBOutlet UITextField *ensureTF;//确认密码

@property (weak, nonatomic) IBOutlet UIButton *submitBtn;//提交按钮
@property (weak, nonatomic) IBOutlet UIButton *getCodeBtn;//获取验证码

@end

@implementation LBFindSecondPassWordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"找回二级密码";
    self.navigationController.navigationBar.hidden = NO;
}

-(void)updateViewConstraints{
    [super updateViewConstraints];
    self.topConstrait.constant = SafeAreaTopHeight;
}

/**
 获取验证码
 */
- (IBAction)getCode:(id)sender {
    
    [self startTime];//获取倒计时
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"app_handler"] = @"SEARCH";
    dic[@"phone"] = [UserModel defaultUser].phone;
    
    [NetworkManager requestPOSTWithURLStr:kGETCODE_URL paramDic:dic finish:^(id responseObject) {
        
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE) {
            [EasyShowTextView showSuccessText:@"发送成功"];
            return ;
        }
    } enError:^(NSError *error) {
        [EasyShowTextView showErrorText:error.localizedDescription];
    }];
    
}

//获取倒计时
-(void)startTime{
    
    __block int timeout = 60; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout==0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [self.getCodeBtn setTitle:@"重发验证码" forState:UIControlStateNormal];
                self.getCodeBtn.userInteractionEnabled = YES;
                self.getCodeBtn.backgroundColor = [UIColor whiteColor];
                self.getCodeBtn.titleLabel.font = [UIFont systemFontOfSize:13];
            });
            
        }else{
            
            int seconds = timeout % 61;
            NSString *strTime = [NSString stringWithFormat:@" %.2d秒后重新发送 ", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.getCodeBtn setTitle:[NSString stringWithFormat:@"%@",strTime] forState:UIControlStateNormal];
                self.getCodeBtn.userInteractionEnabled = NO;
                self.getCodeBtn.backgroundColor = [UIColor whiteColor];
                self.getCodeBtn.titleLabel.font = [UIFont systemFontOfSize:11];
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
    
}

- (IBAction)submit:(id)sender {
    
    [self.view endEditing:YES];
    
    if(self.codeTF.text.length == 0){
        [EasyShowTextView showInfoText:@"请输入验证码"];
        return;
    }
    
    if(self.passwordNewTF.text.length == 0){
        [EasyShowTextView showInfoText:@"请输入密码"];
        return;
    }
    if(self.passwordNewTF.text.length != 6){
        [EasyShowTextView showInfoText:@"二级密码只能是6位数字"];
        return;
    }
    
    if(![self.passwordNewTF.text isEqualToString:self.ensureTF.text]){
        [EasyShowTextView showInfoText:@"两次输入的密码不一致"];
        return;
    }
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"app_handler"] = @"UPDATE";
    dic[@"uid"] = [UserModel defaultUser].uid;
    dic[@"token"] = [UserModel defaultUser].token;
    dic[@"yzm"] = self.codeTF.text;
    dic[@"two_pwd"] = [RSAEncryptor encryptString:self.passwordNewTF.text publicKey:public_RSA];
    dic[@"sure_pwd"] = [RSAEncryptor encryptString:self.ensureTF.text publicKey:public_RSA];
    
//    NSString *url;
    
    self.submitBtn.enabled = NO;
    self.submitBtn.backgroundColor = [UIColor grayColor];
    [EasyShowLodingView showLodingText:@"正在请求..."];
    
    [NetworkManager requestPOSTWithURLStr:kForget_Second_Password_URL paramDic:dic finish:^(id responseObject) {
        
        [EasyShowLodingView hidenLoding];
        self.submitBtn.enabled = YES;
        self.submitBtn.backgroundColor = MAIN_COLOR;
        
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE) {
            [EasyShowTextView showSuccessText:@"找回成功"];
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
    
  if(textField == self.codeTF){
        [self.passwordNewTF becomeFirstResponder];
    }else if(textField == self.passwordNewTF){
        [self.ensureTF becomeFirstResponder];
    }else if(textField == self.ensureTF){
        [self.view endEditing:YES];
    }
    
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if (range.length == 1 && string.length == 0) {
        
        return YES;
    }
    
    if(![predicateModel inputShouldNumber:string]){
        
        [self.view endEditing:YES];
         [EasyShowTextView showInfoText:@"此处只能输入数字"];
    
        return NO;
    }
    
    return YES;
}

@end
