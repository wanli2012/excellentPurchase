//
//  LBRegisterViewController.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/1/10.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "LBRegisterViewController.h"
#import "GLMine_Team_OpenSellerController.h"//商家注册
#import "LLWebViewController.h"//web页面

#import "DropMenu.h"
#import "GLGroupModel.h"
//扫码
#import "LBXScanView.h"
#import "LBXScanResult.h"
#import "LBXScanWrapper.h"
#import "SubLBXScanViewController.h"

@interface LBRegisterViewController ()<UITextFieldDelegate>
{
    BOOL _isAgreeProtocol;
}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *navigation;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *logoH;
@property (weak, nonatomic) IBOutlet UILabel *loginLb;

@property (weak, nonatomic) IBOutlet UIView *identifyView;

@property (weak, nonatomic) IBOutlet UITextField *recommendTF;//推荐人
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;//手机号
@property (weak, nonatomic) IBOutlet UITextField *codeTF;//验证码
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;//密码
@property (weak, nonatomic) IBOutlet UITextField *ensureTF;//确认密码
@property (weak, nonatomic) IBOutlet UIButton *signBtn;//同意标志
@property (weak, nonatomic) IBOutlet UIButton *getCodeBtn;//获取验证码
@property (weak, nonatomic) IBOutlet UITextField *groupTypeTF;//身份类型
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;//注册按钮

@property (nonatomic, copy)NSString *group_id;
@property (nonatomic, strong)NSMutableArray *groupModels;//身份类型数组


@end

@implementation LBRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
     self.loginLb.attributedText = [self addoriginstr:self.loginLb.text specilstr:@[@"登录"]];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

-(void)updateViewConstraints{
    [super updateViewConstraints];
    //iphoneX
    if (UIScreenWidth == 812.0) {
        self.navigation.constant = 47;
        self.logoH.constant = 92;
    }
}

#pragma mark - 扫描
- (IBAction)scan:(id)sender {
    //设置扫码区域参数
    LBXScanViewStyle *style = [[LBXScanViewStyle alloc]init];
    style.centerUpOffset = 60;
    style.xScanRetangleOffset = 30;
    
    if ([UIScreen mainScreen].bounds.size.height <= 480 )
    {
        //3.5inch 显示的扫码缩小
        style.centerUpOffset = 40;
        style.xScanRetangleOffset = 20;
    }
    
    style.alpa_notRecoginitonArea = 0.6;
    
    style.photoframeAngleStyle = LBXScanViewPhotoframeAngleStyle_Inner;
    style.photoframeLineW = 2.0;
    style.photoframeAngleW = 16;
    style.photoframeAngleH = 16;
    
    style.isNeedShowRetangle = NO;
    
    style.anmiationStyle = LBXScanViewAnimationStyle_NetGrid;
    
    //使用的支付宝里面网格图片
    UIImage *imgFullNet = [UIImage imageNamed:@"CodeScan.bundle/qrcode_scan_full_net"];
    
    style.animationImage = imgFullNet;
    
    [self openScanVCWithStyle:style];
}

- (void)openScanVCWithStyle:(LBXScanViewStyle*)style
{
    self.hidesBottomBarWhenPushed = YES;
    SubLBXScanViewController *vc = [SubLBXScanViewController new];
    vc.style = style;
    
    __weak typeof(self) weakself = self;
    vc.retureCode = ^(NSString *codeStr){
        
        NSArray *arr = [codeStr componentsSeparatedByString:@"="];
        if (arr.count >= 2) {
            weakself.recommendTF.text = arr[1];
        }
        
    };
    
    [self.navigationController pushViewController:vc animated:YES];
    self.hidesBottomBarWhenPushed = NO;
    
}

/**
 身份类型选择
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
    
    [DropMenu showMenu:arrM controlFrame:CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height + 5) MenuMaxHeight:150 cellHeight:40 isHaveMask:NO andReturnBlock:^(NSString *selectName, NSString *type_id) {
        
        self.groupTypeTF.text = selectName;
        self.group_id = type_id;
        
    }];
    
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
                self.getCodeBtn.backgroundColor = [UIColor whiteColor];
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
        [self.signBtn setImage:[UIImage imageNamed:@"greetselect-y"] forState:UIControlStateNormal];
        self.submitBtn.backgroundColor = MAIN_COLOR;
        self.submitBtn.enabled = YES;
    }else{
        [self.signBtn setImage:[UIImage imageNamed:@"greetselect-n"] forState:UIControlStateNormal];
        self.submitBtn.backgroundColor = [UIColor groupTableViewBackgroundColor];
        self.submitBtn.enabled = NO;
    }
}

#pragma mark - 跳转到服务条款
- (IBAction)toProtocol:(id)sender {
    
    self.hidesBottomBarWhenPushed = YES;
    LLWebViewController *webVC = [[LLWebViewController alloc] initWithUrl:kProtocol_URL];
    webVC.titilestr = @"服务条款";
    [self.navigationController pushViewController:webVC animated:YES];
    
}

#pragma mark - 商户注册
- (IBAction)sellerRegister:(id)sender {
    
    self.hidesBottomBarWhenPushed = YES;
    GLMine_Team_OpenSellerController *vc = [[GLMine_Team_OpenSellerController alloc] init];
    vc.pushType = 2;
    [self.navigationController pushViewController:vc animated:YES];
    
}

#pragma mark - 注册
/**注册*/
- (IBAction)registe:(id)sender {
    
    [self.view endEditing:YES];
    
    self.group_id = @"9";

    if (self.phoneTF.text.length <=0 ) {

        [EasyShowTextView showInfoText:@"请输入手机号码"];
        
        return;
    }else{
        if (![predicateModel valiMobile:self.phoneTF.text]) {
            [EasyShowTextView showInfoText:@"手机号格式不对"];
            return;
        }
    }
    
    if (self.passwordTF.text.length <= 0) {

        [EasyShowTextView showInfoText:@"密码不能为空" ];
        return;
    }
    if (self.passwordTF.text.length < 6 || self.passwordTF.text.length > 12) {
        
        [EasyShowTextView showInfoText:@"请输入6-12位密码"];
        return;
    }
    
    if ([predicateModel checkIsHaveNumAndLetter:self.passwordTF.text] != 3) {
        
        [EasyShowTextView showInfoText:@"密码须包含数字和字母"];
        return;
    }
    
    if (self.ensureTF.text.length <= 0) {

        [EasyShowTextView showInfoText:@"请输入确认密码"];
        return;
    }
        
    if (![self.passwordTF.text isEqualToString:self.ensureTF.text]) {
        
        [EasyShowTextView showInfoText:@"两次输入的密码不一致"];
        return;
    }
    
    if (self.codeTF.text.length <= 0) {
        
        [EasyShowTextView showInfoText:@"请输入验证码"];
        return;
    }
    
    if(!_isAgreeProtocol){
        [EasyShowTextView showInfoText:@"请先同意注册协议"];
        return;
    }
    
     [self sureSubmit];
    
}

//确认注册
- (void)sureSubmit{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"phone"] = self.phoneTF.text;
    dict[@"password"] = [RSAEncryptor encryptString:self.passwordTF.text publicKey:public_RSA];
    dict[@"yzm"] = self.codeTF.text;
    dict[@"app_handler"] = @"ADD";
    dict[@"user_name"] = self.recommendTF.text;
    dict[@"group_id"] = self.group_id;
    
    self.submitBtn.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.submitBtn.enabled = NO;
    
    [NetworkManager requestPOSTWithURLStr:kREGISTER_URL paramDic:dict finish:^(id responseObject) {
        //        [_loadV removeloadview];
        self.submitBtn.backgroundColor = MAIN_COLOR;
        self.submitBtn.enabled = YES;
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE) {
            
            [EasyShowTextView showSuccessText:@"注册成功"];
            
            [UIView animateWithDuration:0.3 animations:^{
                
                [self.navigationController popViewControllerAnimated:YES];
            }];
            
        }else{
            [EasyShowTextView showErrorText:responseObject[@"message"]];
        }
        
    } enError:^(NSError *error) {
        
        self.submitBtn.backgroundColor = MAIN_COLOR;
        self.submitBtn.enabled = NO;
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
    
                [EasyShowTextView showInfoText:@"密码只能是数字和字母的组合"];
    
                return NO;
            }
        }
    
    
    return YES;
}



-(NSMutableAttributedString*)addoriginstr:(NSString*)originstr specilstr:(NSArray*)specilstrArr{
    
    NSMutableAttributedString *noteStr = [[NSMutableAttributedString alloc] initWithString:originstr];
    for (int i = 0; i < specilstrArr.count; i++) {
        NSRange rang = [originstr rangeOfString:specilstrArr[i]];
        [noteStr addAttributes:@{NSForegroundColorAttributeName:LBHexadecimalColor(0x333333)} range:rang];
        [noteStr addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} range:rang];
    }
    
    
    return noteStr;
    
}

#pragma mark - 懒加载
- (NSMutableArray *)groupModels{
    if (!_groupModels) {
        _groupModels = [NSMutableArray array];
        
    }
    return _groupModels;
}


@end
