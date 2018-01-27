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

#import "DropMenu.h"
#import "GLGroupModel.h"

@interface LBLoginViewController ()<UITextFieldDelegate>

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
    
    [NetworkManager requestPOSTWithURLStr:kGet_GroupList_URL paramDic:dic finish:^(id responseObject) {
        
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
    
    [DropMenu showMenu:arrM controlFrame:CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height + 5) MenuMaxHeight:150 cellHeight:30 andReturnBlock:^(NSString *selectName, NSString *type_id) {
        
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
    
    [NetworkManager requestPOSTWithURLStr:kLOGIN_URL paramDic:dict finish:^(id responseObject) {
        
//        [_loadV removeloadview];
        
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE) {
            
            [EasyShowTextView showSuccessText:responseObject[@"message"]];
            
            [UserModel defaultUser].loginstatus = YES;
            
            [usermodelachivar achive];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshInterface" object:nil];
            
            [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
            
        }else if([responseObject[@"code"] integerValue] == 412){
//            self.serviceNumLabel.hidden = NO;
//            self.serviceNumLabel.text = [NSString stringWithFormat:@"客服电话:%@",[UserModel defaultUser].user_server];
            
            [EasyShowTextView showErrorText:responseObject[@"message"]];
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
