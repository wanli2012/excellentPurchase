//
//  LBLoginViewController.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/1/10.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "LBLoginViewController.h"
#import "BasetabbarViewController.h"
#import "LBRegisterViewController.h"//注册
#import "LBFasterLoginViewController.h"//快捷登录
#import "LBForgetSecretViewController.h"//忘记密码

#import "DropMenu.h"
#import "GLGroupModel.h"

@interface LBLoginViewController ()<UITextFieldDelegate>
{
    BOOL _isSaveAccount;//是否保存账号
}

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *navigation;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *logoH;
@property (weak, nonatomic) IBOutlet UILabel *registerLb;

@property (weak, nonatomic) IBOutlet UIView *accountView;//用户名view
@property (weak, nonatomic) IBOutlet UIView *passwordView;//密码view
@property (weak, nonatomic) IBOutlet UIView *identifyView;//身份view
@property (weak, nonatomic) IBOutlet UIButton *loginBt;//登录按钮

@property (weak, nonatomic) IBOutlet UITextField *accountTF;//账号
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;//密码
@property (weak, nonatomic) IBOutlet UITextField *group_idTF;//身份

@property (weak, nonatomic) IBOutlet UIButton *signBtn;//是否记住密码

@property (nonatomic, strong)NSMutableArray *groupModels;//身份类型数组
@property (nonatomic, copy)NSString *group_id;//用户组id

@end

@implementation LBLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.registerLb.attributedText = [self addoriginstr:self.registerLb.text specilstr:@[@"注册"]];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

/**
 是否记住账号
 */
- (IBAction)isSaveAccount:(id)sender {
    _isSaveAccount = !_isSaveAccount;
    if(_isSaveAccount){
        [self.signBtn setImage:[UIImage imageNamed:@"greetselect-y"] forState:UIControlStateNormal];
    }else{
        [self.signBtn setImage:[UIImage imageNamed:@"greetselect-n"] forState:UIControlStateNormal];
    }
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
    
    [DropMenu showMenu:arrM controlFrame:CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height + 5) MenuMaxHeight:150 cellHeight:40 isHaveMask:NO andReturnBlock:^(NSString *selectName, NSString *type_id) {
        self.group_idTF.text = selectName;
        self.group_id = type_id;
        
    }];

}


/**
 返回
 */
- (IBAction)back:(id)sender {
    
    [UserModel defaultUser].loginstatus = NO;
    [UserModel defaultUser].token = nil;
    [UserModel defaultUser].uid = nil;
    [usermodelachivar achive];
    [self dismissViewControllerAnimated:YES completion:nil];
    BasetabbarViewController *tabVC = [[BasetabbarViewController alloc] init];
    [UIApplication sharedApplication].keyWindow.rootViewController = tabVC;
    [tabVC setSelectedIndex:0];
    
}

/**
 注册
 */
- (IBAction)registerEvent:(UITapGestureRecognizer *)sender {
    self.hidesBottomBarWhenPushed = YES;
    LBRegisterViewController *registVC = [[LBRegisterViewController alloc] init];
    [self.navigationController pushViewController:registVC animated:YES];
}
/**
忘记密码
 */
- (IBAction)forgetSecretEvent:(UITapGestureRecognizer *)sender {
    
    self.hidesBottomBarWhenPushed = YES;
    LBForgetSecretViewController *forgetVC = [[LBForgetSecretViewController alloc] init];
    [self.navigationController pushViewController:forgetVC animated:YES];
    
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

/**
 快捷登录
 */
- (IBAction)fastLogin:(id)sender {
    self.hidesBottomBarWhenPushed = YES;
    LBFasterLoginViewController *fastVC = [[LBFasterLoginViewController alloc] init];
    [self.navigationController pushViewController:fastVC animated:YES];
}



-(void)updateViewConstraints{
    [super updateViewConstraints];
    
    //iphoneX
    if (UIScreenWidth == 812.0) {
        self.navigation.constant = 47;
        self.logoH.constant = 92;
    }
    
}

#pragma mark - 登录
- (IBAction)login:(id)sender {
    
    [self.view endEditing:YES];
    
    if (self.accountTF.text.length <=0 ) {
        
        [EasyShowTextView showInfoText:@"请输入手机号码"];
        return;
    }
    
    if (self.passwordTF.text.length <= 0) {
        
        [EasyShowTextView showInfoText:@"密码不能为空"];
        return;
    }
    
    if (self.passwordTF.text.length < 6 || self.passwordTF.text.length > 12) {
        
        [EasyShowTextView showInfoText:@"请输入6-12位密码"];
        return;
    }
    if (self.group_id <= 0) {
        
        [EasyShowTextView showInfoText:@"请选择身份"];
        return;
    }
    
//    _loadV=[LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
    
//    NSString *encryptsecret = [RSAEncryptor encryptString:self.passwordTF.text publicKey:public_RSA];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"app_handler"] = @"SEARCH";
    dict[@"phone"] = self.accountTF.text;
    dict[@"group_id"] = self.group_id;
    dict[@"password"] = self.passwordTF.text;
    
    self.loginBt.enabled = NO;
    self.loginBt.backgroundColor = [UIColor grayColor];
    [EasyShowLodingView showLodingText:@"登录中..."];
    
    [NetworkManager requestPOSTWithURLStr:kLOGIN_URL paramDic:dict finish:^(id responseObject) {
        
        [EasyShowLodingView hidenLoding];
        self.loginBt.enabled = YES;
        self.loginBt.backgroundColor = MAIN_COLOR;
        
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE) {
            
            [EasyShowTextView showSuccessText:responseObject[@"message"]];
            
            [UserModel defaultUser].loginstatus = YES;
            
            [UserModel defaultUser].token = [self judgeStr:responseObject[@"data"][@"token"]];
            [UserModel defaultUser].uid = [self judgeStr:responseObject[@"data"][@"uid"]];
            [UserModel defaultUser].user_name = [self judgeStr:responseObject[@"data"][@"user_name"]];
            [UserModel defaultUser].group_id = [self judgeStr:responseObject[@"data"][@"group_id"]];
            [UserModel defaultUser].group_name = [self judgeStr:responseObject[@"data"][@"group_name"]];
            
            [UserModel defaultUser].phone = [self judgeStr:responseObject[@"data"][@"phone"]];
            [UserModel defaultUser].pic = [self judgeStr:responseObject[@"data"][@"pic"]];
            [UserModel defaultUser].trueName = [self judgeStr:responseObject[@"data"][@"trueName"]];
            [UserModel defaultUser].im_id = [self judgeStr:responseObject[@"data"][@"im_id"]];
            [UserModel defaultUser].im_token = [self judgeStr:responseObject[@"data"][@"im_token"]];
            [UserModel defaultUser].nick_name = [self judgeStr:responseObject[@"data"][@"nick_name"]];
            [UserModel defaultUser].rzstatus = [self judgeStr:responseObject[@"data"][@"rzstatus"]];
            [UserModel defaultUser].del = [self judgeStr:responseObject[@"data"][@"del"]];
            [UserModel defaultUser].tjr_group = [self judgeStr:responseObject[@"data"][@"tjr_group"]];
            [UserModel defaultUser].tjr_name = [self judgeStr:responseObject[@"data"][@"tjr_name"]];
            [UserModel defaultUser].mark = [self judgeStr:responseObject[@"data"][@"mark"]];
            [UserModel defaultUser].balance = [self judgeStr:responseObject[@"data"][@"balance"]];
            [UserModel defaultUser].keti_bean = [self judgeStr:responseObject[@"data"][@"keti_bean"]];
            [UserModel defaultUser].shopping_voucher = [self judgeStr:responseObject[@"data"][@"shopping_voucher"]];
            [UserModel defaultUser].cion_price = [self judgeStr:responseObject[@"data"][@"cion_price"]];
            [UserModel defaultUser].voucher_ratio = [self judgeStr:responseObject[@"data"][@"voucher_ratio"]];

            [usermodelachivar achive];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshInterface" object:nil];
            
            [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
            
        }else{
            [EasyShowTextView showErrorText:responseObject[@"message"]];
        }
        
    } enError:^(NSError *error) {
        
        self.loginBt.enabled = YES;
        self.loginBt.backgroundColor = MAIN_COLOR;
        
        [EasyShowLodingView hidenLoding];
        [EasyShowTextView showErrorText:error.localizedDescription];
    }];
}

- (NSString *)judgeStr:(id )str{
    
    str = [NSString stringWithFormat:@"%@",str];
    
    if ([NSString StringIsNullOrEmpty:str]) {
        return @"";
    }else{
        return str;
    }
   
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == self.accountTF) {
        [self.passwordTF becomeFirstResponder];
    }else if(textField == self.passwordTF){
        [self.view endEditing:YES];
    }
    
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
//    if (textField == self.accountTF) {
//        if (range.length == 1 && string.length == 0) {
//
//            return YES;
//        }
//        if(![predicateModel inputShouldNumber:string]){
//
////            [EasyShowTextView showInfoText:@"此处只能输入数字！"];
//            return NO;
//        }
//
//    }else if(textField == self.passwordTF){
//        if (range.length == 1 && string.length == 0) {
//
//            return YES;
//        }
//
//        if(![predicateModel inputShouldLetterOrNum:string]){
//            
////            [EasyShowTextView showInfoText:@"密码只能是数字或字母"];
//
//            return NO;
//        }
//    }
    
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
