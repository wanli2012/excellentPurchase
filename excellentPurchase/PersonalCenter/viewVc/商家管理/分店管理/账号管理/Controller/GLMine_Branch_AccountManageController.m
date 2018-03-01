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
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"app_handler"] = @"UPDATE";
    dict[@"uid"] = [UserModel defaultUser].uid;
    dict[@"token"] = [UserModel defaultUser].token;
    dict[@"sid"] = self.sid;//商铺id
    dict[@"password"] = [RSAEncryptor encryptString:self.passwordNewTF.text publicKey:public_RSA];//新密码
    dict[@"confirmpass"] = [RSAEncryptor encryptString:self.ensureTF.text publicKey:public_RSA];//确认密码
    dict[@"paypassword"] = [RSAEncryptor encryptString:self.secondPwdTF.text publicKey:public_RSA];//二级密码
    
    [EasyShowLodingView showLoding];
    [NetworkManager requestPOSTWithURLStr:kstore_branch_acc paramDic:dict finish:^(id responseObject) {
        
        [EasyShowLodingView hidenLoding];
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE) {
            
            [EasyShowTextView showInfoText:@"修改成功"];
            [self.navigationController popViewControllerAnimated:YES];
            
        }else{
            
            [EasyShowTextView showErrorText:responseObject[@"message"]];
        }
        
    } enError:^(NSError *error) {
        
        [EasyShowLodingView hidenLoding];
        [EasyShowTextView showErrorText:error.localizedDescription];
    }];
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
