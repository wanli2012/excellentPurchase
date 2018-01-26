//
//  LBRegisterViewController.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/1/10.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "LBRegisterViewController.h"
#import <VerifyCode/NTESVerifyCodeManager.h>


@interface LBRegisterViewController ()<UITextFieldDelegate,NTESVerifyCodeManagerDelegate>
{
    BOOL _isAgreeProtocol;
}

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewW;//Scrollvive contentview的宽度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewHeight;

@property (weak, nonatomic) IBOutlet UITextField *recommendTF;//推荐人
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;//手机号
@property (weak, nonatomic) IBOutlet UITextField *codeTF;//验证码
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;//密码
@property (weak, nonatomic) IBOutlet UITextField *ensureTF;//确认密码
@property (weak, nonatomic) IBOutlet UIButton *signBtn;//同意标志
@property (weak, nonatomic) IBOutlet UIButton *getCodeBtn;//获取验证码
@property (weak, nonatomic) IBOutlet UITextField *groupTypeTF;//身份类型

@property (nonatomic, copy)NSString *validate;//极验证
@property(nonatomic,strong)NTESVerifyCodeManager *manager;


@end

@implementation LBRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}

-(void)updateViewConstraints{
    [super updateViewConstraints];
    
    self.contentViewW.constant = UIScreenWidth - 70;
    self.contentViewHeight.constant = 360;
}

/**
 身份类型选择
 */
- (IBAction)groupTypeChoose:(id)sender {
    

}

/**
 获取验证码
 */
- (IBAction)getCode:(id)sender {
    
    if (self.phoneTF.text.length <=0 ) {
        [EasyShowTextView showInfoText:@"请输入手机号码"];
        return;
    }else{
        if (![predicateModel valiMobile:self.phoneTF.text]) {
            [EasyShowTextView showInfoText:@"手机号格式不对"];
            return;
        }
    }
    
    [self startTime];//获取倒计时
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"app_handler"] = @"SEARCH";
    dic[@"phone"] = self.phoneTF.text;
    
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
                self.getCodeBtn.titleLabel.font = [UIFont systemFontOfSize:13];
            });
            
        }else{
            
            int seconds = timeout % 61;
            NSString *strTime = [NSString stringWithFormat:@" %.2d秒后重新发送 ", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.getCodeBtn setTitle:[NSString stringWithFormat:@"%@",strTime] forState:UIControlStateNormal];
                self.getCodeBtn.userInteractionEnabled = NO;
                self.getCodeBtn.backgroundColor = YYSRGBColor(184, 184, 184, 1);
                self.getCodeBtn.titleLabel.font = [UIFont systemFontOfSize:11];
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
    
}

/**
 返回登录
 */
- (IBAction)back:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 是否同意协议
 */
- (IBAction)isAgreeProtocol:(id)sender {
    _isAgreeProtocol = !_isAgreeProtocol;
    
    if (_isAgreeProtocol) {
        [self.signBtn setImage:[UIImage imageNamed:@"choice"] forState:UIControlStateNormal];
    }else{
        [self.signBtn setImage:[UIImage imageNamed:@"nochoice"] forState:UIControlStateNormal];
    }
}

#pragma mark - 注册
/**
 注册
 */
- (IBAction)registe:(id)sender {
    
    if (self.phoneTF.text.length <=0 ) {

        [EasyShowTextView showInfoText:@"请输入手机号码" inView:[UIApplication sharedApplication].keyWindow];
        
        return;
    }else{
        if (![predicateModel valiMobile:self.phoneTF.text]) {
            [EasyShowTextView showInfoText:@"手机号格式不对" inView:[UIApplication sharedApplication].keyWindow];
            return;
        }
    }
    
    if (self.passwordTF.text.length <= 0) {

        [EasyShowTextView showInfoText:@"密码不能为空" inView:[UIApplication sharedApplication].keyWindow];
        return;
    }
    if (self.passwordTF.text.length < 6 || self.passwordTF.text.length > 12) {
        
        [EasyShowTextView showInfoText:@"请输入6-12位密码" inView:[UIApplication sharedApplication].keyWindow];
        return;
    }
    
    if ([predicateModel checkIsHaveNumAndLetter:self.passwordTF.text] != 3) {
        
        [EasyShowTextView showInfoText:@"密码须包含数字和字母" inView:[UIApplication sharedApplication].keyWindow];
        return;
    }
    
    if (self.ensureTF.text.length <= 0) {

        [EasyShowTextView showInfoText:@"请输入确认密码"inView:[UIApplication sharedApplication].keyWindow];
        return;
    }
    
    if (![self.passwordTF.text isEqualToString:self.ensureTF.text]) {

        [EasyShowTextView showInfoText:@"两次输入的密码不一致" inView:[UIApplication sharedApplication].keyWindow];
        return;
    }
    
    if (self.codeTF.text.length <= 0) {

        [EasyShowTextView showInfoText:@"请输入验证码" inView:[UIApplication sharedApplication].keyWindow];
        return;
    }
    
    if(!_isAgreeProtocol){
        [EasyShowTextView showInfoText:@"请先同意注册协议" inView:[UIApplication sharedApplication].keyWindow];
        return;
    }
    
//    NSString *encryptsecret = [RSAEncryptor encryptString:self.passwordTF.text publicKey:public_RSA];
    self.manager = [NTESVerifyCodeManager sharedInstance];
    if (self.manager) {
        
        // 如果需要了解组件的执行情况,则实现回调
        self.manager.delegate = self;
        
        // captchaid的值是每个产品从后台生成的,比如 @"a05f036b70ab447b87cc788af9a60974"
        NSString *captchaid = CAPTCHAID;
        [self.manager configureVerifyCode:captchaid timeout:10.0];
        
        // 设置透明度
        self.manager.alpha = 0.7;
        
        // 设置frame
        self.manager.frame = CGRectNull;
        
        // 显示验证码
        [self.manager openVerifyCodeView:nil];
    }
}

//确认注册
- (void)sureSubmit{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"phone"] = self.phoneTF.text;
    dict[@"password"] = self.passwordTF.text;
    dict[@"yzm"] = self.codeTF.text;
    dict[@"app_handler"] = @"ADD";
    dict[@"user_name"] = @"ZY16932075";
    dict[@"validate"] = self.validate;
    
    //    _loadV = [LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
    [NetworkManager requestPOSTWithURLStr:kREGISTER_URL paramDic:dict finish:^(id responseObject) {
        //        [_loadV removeloadview];
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE) {
            
            [EasyShowTextView showSuccessText:@"注册成功"];
            
            [UIView animateWithDuration:0.3 animations:^{
                
                [self.navigationController popViewControllerAnimated:YES];
            }];
            
        }else{
            [EasyShowTextView showErrorText:responseObject[@"message"]];
        }
        
    } enError:^(NSError *error) {
        //        [_loadV removeloadview];
        [EasyShowTextView showErrorText:error.localizedDescription];
        
    }];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if (textField == self.recommendTF) {
        [self.phoneTF becomeFirstResponder];
    }else if(textField == self.phoneTF){
        [self.codeTF becomeFirstResponder];
    }else if(textField == self.codeTF){
        [self.passwordTF becomeFirstResponder];
    }else if(textField == self.passwordTF){
        [self.ensureTF becomeFirstResponder];
    }else if(textField == self.ensureTF){
        [self.view endEditing:YES];
    }
    
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
        if (textField == self.phoneTF || textField == self.codeTF) {
            if (range.length == 1 && string.length == 0) {
    
                return YES;
            }
            
            if(![predicateModel inputShouldNumber:string]){
    
                [EasyShowTextView showInfoText:@"此处只能输入数字！"];
                return NO;
            }
    
        }else if(textField == self.passwordTF){
            if (range.length == 1 && string.length == 0) {
    
                return YES;
            }
    
            if(![predicateModel inputShouldLetterOrNum:string]){
    
                [EasyShowTextView showInfoText:@"密码只能是数字或字母"];
    
                return NO;
            }
        }
    
    
    return YES;
}

#pragma mark - NTESVerifyCodeManagerDelegate
/**
 * 验证码组件初始化完成
 */
- (void)verifyCodeInitFinish{
    
}

/**
 * 验证码组件初始化出错
 *
 * @param message 错误信息
 */
- (void)verifyCodeInitFailed:(NSString *)message{
    [EasyShowTextView showErrorText:message];
}

/**
 * 完成验证之后的回调
 *
 * @param result 验证结果 BOOL:YES/NO
 * @param validate 二次校验数据，如果验证结果为false，validate返回空
 * @param message 结果描述信息
 *
 */
- (void)verifyCodeValidateFinish:(BOOL)result validate:(NSString *)validate message:(NSString *)message{
    
    if (result == YES) {
        self.validate = validate;
        [self sureSubmit];
    }
    
}

/**
 * 关闭验证码窗口后的回调
 */
- (void)verifyCodeCloseWindow{
    //用户关闭验证后执行的方法
    
}

/**
 * 网络错误
 *
 * @param error 网络错误信息
 */
- (void)verifyCodeNetError:(NSError *)error{
    //用户关闭验证后执行的方法
    [EasyShowTextView showErrorText:error.localizedDescription];
}

@end
