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

@property (weak, nonatomic) IBOutlet UITextField *oldPhoneTF;//原手机号
@property (weak, nonatomic) IBOutlet UITextField *codeTF;//验证码
@property (weak, nonatomic) IBOutlet UIButton *getCodeBtn;//获取验证码

@property (weak, nonatomic) IBOutlet UIButton *nextBtn;//下一步

@end

@implementation LBResetOldPhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"修改绑定手机号";
    self.navigationController.navigationBar.hidden = NO;
    
}
//下一步
- (IBAction)NextEvent:(UIButton *)sender {
    
    
    [self.view endEditing:YES];
    
    if (self.oldPhoneTF.text.length == 0) {
        [EasyShowTextView showInfoText:@"请输入原手机号"];
        return;
    }else{
        if (![predicateModel valiMobile:self.oldPhoneTF.text]) {
            [EasyShowTextView showInfoText:@"手机号格式不对"];
            return;
        }
    }
    
    if (self.codeTF.text.length == 0) {
        [EasyShowTextView showInfoText:@"请输入验证码"];
        return;
    }
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"app_handler"] = @"UPDATE";
    dic[@"uid"] = [UserModel defaultUser].uid;
    dic[@"token"] = [UserModel defaultUser].token;
    dic[@"yzm"] = self.codeTF.text;
    
    self.nextBtn.enabled = NO;
    self.nextBtn.backgroundColor = [UIColor grayColor];
    [EasyShowLodingView showLodingText:@"正在请求..."];
    
    [NetworkManager requestPOSTWithURLStr:kUpdate_Phone_First_Password_URL paramDic:dic finish:^(id responseObject) {
        
        [EasyShowLodingView hidenLoding];
        self.nextBtn.enabled = YES;
        self.nextBtn.backgroundColor = MAIN_COLOR;
        
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE) {
            
            self.hidesBottomBarWhenPushed = YES;
            LBResetNewPhoneViewController *vc =[[LBResetNewPhoneViewController alloc]init];
            vc.concate = responseObject[@"data"][@"concate"];
            [self.navigationController pushViewController:vc animated:YES];
            
            
            return;
        }
        
    } enError:^(NSError *error) {
        [EasyShowLodingView hidenLoding];
        self.nextBtn.enabled = YES;
        self.nextBtn.backgroundColor = MAIN_COLOR;
        
        [EasyShowTextView showErrorText:error.localizedDescription];
    }];
}


/**
 获取验证码
 */
- (IBAction)getCode:(id)sender {
    
    if (self.oldPhoneTF.text.length <=0 ) {
        [EasyShowTextView showInfoText:@"请输入手机号码"];
        return;
    }else{
        if (![predicateModel valiMobile:self.oldPhoneTF.text]) {
            [EasyShowTextView showInfoText:@"手机号格式不对"];
            return;
        }
    }
    
    [self startTime];//获取倒计时
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"app_handler"] = @"SEARCH";
    dic[@"phone"] = self.oldPhoneTF.text;
    
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
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [self.getCodeBtn setTitle:@"重发验证码" forState:UIControlStateNormal];
                self.getCodeBtn.userInteractionEnabled = YES;
                self.getCodeBtn.backgroundColor = [UIColor whiteColor];
                self.getCodeBtn.backgroundColor = MAIN_COLOR;
                self.getCodeBtn.titleLabel.font = [UIFont systemFontOfSize:13];
            });
            
        }else{
            
            int seconds = timeout % 61;
            NSString *strTime = [NSString stringWithFormat:@" %.2d秒后重新发送 ", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.getCodeBtn setTitle:[NSString stringWithFormat:@"%@",strTime] forState:UIControlStateNormal];
                self.getCodeBtn.userInteractionEnabled = NO;
                self.getCodeBtn.backgroundColor = [UIColor lightGrayColor];
                self.getCodeBtn.titleLabel.font = [UIFont systemFontOfSize:11];
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
    
}
#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if (textField == self.oldPhoneTF) {
        [self.codeTF becomeFirstResponder];
    }else if(textField == self.codeTF){
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
