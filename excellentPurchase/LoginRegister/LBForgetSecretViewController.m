//
//  LBForgetSecretViewController.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/1/10.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "LBForgetSecretViewController.h"

#import "DropMenu.h"
#import "GLGroupModel.h"

@interface LBForgetSecretViewController ()
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;//手机号
@property (weak, nonatomic) IBOutlet UITextField *codeTF;//验证码
@property (weak, nonatomic) IBOutlet UITextField *passwordNewTF;//新密码
@property (weak, nonatomic) IBOutlet UITextField *ensureTF;//确认密码
@property (weak, nonatomic) IBOutlet UIButton *getCodeBtn;//获取
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;//提交
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topContrait;

@property (weak, nonatomic) IBOutlet UIView *identifyView;//身份view
@property (weak, nonatomic) IBOutlet UITextField *groupTypeTF;//身份

@property (nonatomic, strong)NSMutableArray *groupModels;//身份类型数组
@property (nonatomic, copy)NSString *group_id;//用户组id

@end

@implementation LBForgetSecretViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.navigationItem.title = @"忘记密码";
    self.topContrait.constant = SafeAreaTopHeight;
    
//    if (@available(iOS 11.0, *)) {
//        self.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAlways;
//    } else {
//        self.automaticallyAdjustsScrollViewInsets = YES;
//    }
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = NO;
}


/**
 身份选择
 */
- (IBAction)groupTypeChoose:(id)sender {
    if(self.groupModels.count != 0){
        [self popGroupChooseView];
        return;
    }
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"app_handler"] = @"SEARCH";
    dic[@"type"] = @"1";
    
    [EasyShowLodingView showLodingText:@"正在请求数据"];
    [NetworkManager requestPOSTWithURLStr:kGet_GroupList_URL paramDic:dic finish:^(id responseObject) {
        
        [EasyShowLodingView hidenLoding];
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE) {
            for (NSDictionary *dict in responseObject[@"data"]) {
                
                GLGroupModel *model = [GLGroupModel mj_objectWithKeyValues:dict];
                [self.groupModels addObject:model];
                
            }
            [self popGroupChooseView];
        }else{
            [EasyShowTextView showErrorText:responseObject[@"message"]];
        }
    } enError:^(NSError *error) {
        [EasyShowLodingView hidenLoding];
        [EasyShowTextView showErrorText:error.localizedDescription];
    }];
    
}
//弹出选择器
- (void)popGroupChooseView {
    
    UIWindow * window=[[[UIApplication sharedApplication] delegate] window];
    CGRect rect = [self.identifyView convertRect:self.identifyView.bounds toView:window];
    
    NSMutableArray *arrM = [NSMutableArray array];
    for (GLGroupModel *groupModel in self.groupModels) {
        
        DropMenuModel *model = [[DropMenuModel alloc] init];
        
        model.name = groupModel.group_name;
        model.type_id = groupModel.group_id;
        
        [arrM addObject:model];
    }
    
    [DropMenu showMenu:arrM controlFrame:CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height + 1) MenuMaxHeight:150 cellHeight:40 isHaveMask:YES andReturnBlock:^(NSString *selectName, NSString *type_id) {
        
        self.groupTypeTF.text = selectName;
        self.group_id = type_id;
        
    }];
}


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
    
    if (self.group_id.length == 0) {
        [EasyShowTextView showInfoText:@"请选择身份"];
        return;
    }
    
    if(self.phoneTF.text.length == 0){
        [EasyShowTextView showInfoText:@"请输入手机号"];
        return;
    }else {
        if (![predicateModel valiMobile:self.phoneTF.text]) {
            [EasyShowTextView showInfoText:@"手机号格式不对"];
            return;
        }
    }
    
    if(self.codeTF.text.length == 0){
        [EasyShowTextView showInfoText:@"请输入验证码"];
        return;
    }
    
    if(self.passwordNewTF.text.length == 0){
        [EasyShowTextView showInfoText:@"请输入密码"];
        return;
    }
  
    
    if(![self.passwordNewTF.text isEqualToString:self.ensureTF.text]){
        [EasyShowTextView showInfoText:@"两次输入的密码不一致"];
        return;
    }
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"app_handler"] = @"UPDATE";
    dic[@"phone"] = self.phoneTF.text;
    dic[@"group_id"] = self.group_id;
    dic[@"yzm"] = self.codeTF.text;
    dic[@"pwd"] = [RSAEncryptor encryptString:self.passwordNewTF.text publicKey:public_RSA];
    dic[@"sure_pwd"] = [RSAEncryptor encryptString:self.ensureTF.text publicKey:public_RSA];

    self.submitBtn.enabled = NO;
    self.submitBtn.backgroundColor = [UIColor grayColor];
    [EasyShowLodingView showLodingText:@"正在请求..."];
    
    [NetworkManager requestPOSTWithURLStr:kForget_Password_URL paramDic:dic finish:^(id responseObject) {
        
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
    
    if (textField == self.phoneTF) {
        [self.codeTF becomeFirstResponder];
    }else if(textField == self.codeTF){
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
    
    if([predicateModel IsChinese:string]){
        
        [self.view endEditing:YES];
        [EasyShowTextView showInfoText:@"此处不能输入汉字"];
        
        return NO;
    }
    
    return YES;
}

#pragma mark - 懒加载
- (NSMutableArray *)groupModels{
    if (!_groupModels) {
        _groupModels = [NSMutableArray array];
        
    }
    return _groupModels;
}

@end
