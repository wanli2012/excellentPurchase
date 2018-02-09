//
//  LBFasterLoginViewController.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/1/27.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "LBFasterLoginViewController.h"

#import "DropMenu.h"
#import "GLGroupModel.h"

@interface LBFasterLoginViewController ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *navigation;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *logoH;

@property (weak, nonatomic) IBOutlet UITextField *phoneTF;//手机号
@property (weak, nonatomic) IBOutlet UITextField *codeTF;//验证码
@property (weak, nonatomic) IBOutlet UITextField *groupTypeTF;//身份

@property (weak, nonatomic) IBOutlet UIButton *loginBtn;//登录按钮
@property (weak, nonatomic) IBOutlet UIButton *getCodeBtn;//获取按钮
@property (weak, nonatomic) IBOutlet UIView *identifyView;//身份选择View

@property (nonatomic, strong)NSMutableArray *groupModels;//身份类型数组
@property (nonatomic, copy)NSString *group_id;//用户组id

@end

@implementation LBFasterLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}

//更新约束
-(void)updateViewConstraints{
    [super updateViewConstraints];
    //iphoneX
    if (UIScreenWidth == 812.0) {
        self.navigation.constant = 47;
        self.logoH.constant = 92;
    }
    
}

/**
 返回
 */
- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
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
 登录
 */
- (IBAction)login:(id)sender {
    
    [self.view endEditing:YES];
    
    if (self.phoneTF.text.length <=0 ) {
        
        [EasyShowTextView showInfoText:@"请输入手机号码"];
        return;
    }
    
    if (self.codeTF.text.length <= 0) {
        
        [EasyShowTextView showInfoText:@"请输入验证码"];
        return;
    }
    
    if (self.group_id <= 0) {
        
        [EasyShowTextView showInfoText:@"请选择身份"];
        return;
    }
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"app_handler"] = @"SEARCH";
    dict[@"phone"] = self.phoneTF.text;
    dict[@"group_id"] = self.group_id;
    dict[@"code"] = self.codeTF.text;
    
    self.loginBtn.enabled = NO;
    self.loginBtn.backgroundColor = [UIColor grayColor];
    [EasyShowLodingView showLodingText:@"登录中..."];
    
    [NetworkManager requestPOSTWithURLStr:kfast_login paramDic:dict finish:^(id responseObject) {
        
        [EasyShowLodingView hidenLoding];
        self.loginBtn.enabled = YES;
        self.loginBtn.backgroundColor = MAIN_COLOR;
        
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE) {
            
            [EasyShowTextView showSuccessText:responseObject[@"message"]];
            
            [UserModel defaultUser].loginstatus = YES;
            
            [UserModel defaultUser].token = [self judgeStringIsNull:responseObject[@"data"][@"token"]  andDefault:NO];
            [UserModel defaultUser].uid = [self judgeStringIsNull:responseObject[@"data"][@"uid"]   andDefault:NO];
            [UserModel defaultUser].user_name = [self judgeStringIsNull:responseObject[@"data"][@"user_name"] andDefault:NO];
            [UserModel defaultUser].group_id = [self judgeStringIsNull:responseObject[@"data"][@"group_id"] andDefault:NO];
            [UserModel defaultUser].group_name = [self judgeStringIsNull:responseObject[@"data"][@"group_name"] andDefault:NO];
            [UserModel defaultUser].phone = [self judgeStringIsNull:responseObject[@"data"][@"phone"] andDefault:NO];
            [UserModel defaultUser].pic = [self judgeStringIsNull:responseObject[@"data"][@"pic"] andDefault:NO];
            [UserModel defaultUser].truename = [self judgeStringIsNull:responseObject[@"data"][@"truename"] andDefault:NO];
            [UserModel defaultUser].im_id = [self judgeStringIsNull:responseObject[@"data"][@"im_id"] andDefault:NO];
            [UserModel defaultUser].im_token = [self judgeStringIsNull:responseObject[@"data"][@"im_token"] andDefault:NO];
            [UserModel defaultUser].nick_name = [self judgeStringIsNull:responseObject[@"data"][@"nick_name"] andDefault:NO];
            [UserModel defaultUser].rzstatus = [self judgeStringIsNull:responseObject[@"data"][@"rzstatus"] andDefault:NO];
            [UserModel defaultUser].del = [self judgeStringIsNull:responseObject[@"data"][@"del"] andDefault:NO];
            [UserModel defaultUser].tjr_group = [self judgeStringIsNull:responseObject[@"data"][@"tjr_group"] andDefault:NO];
            [UserModel defaultUser].tjr_name = [self judgeStringIsNull:responseObject[@"data"][@"tjr_name"] andDefault:NO];
            [UserModel defaultUser].mark = [self judgeStringIsNull:responseObject[@"data"][@"mark"] andDefault:YES];
            [UserModel defaultUser].balance = [self judgeStringIsNull:responseObject[@"data"][@"balance"] andDefault:YES];
            [UserModel defaultUser].keti_bean = [self judgeStringIsNull:responseObject[@"data"][@"keti_bean"] andDefault:YES];
            [UserModel defaultUser].shopping_voucher = [self judgeStringIsNull:responseObject[@"data"][@"shopping_voucher"] andDefault:YES];
            [UserModel defaultUser].cion_price = [self judgeStringIsNull:responseObject[@"data"][@"cion_price"] andDefault:YES];
            [UserModel defaultUser].voucher_ratio = [self judgeStringIsNull:responseObject[@"data"][@"voucher_ratio"] andDefault:YES];
            
            [usermodelachivar achive];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshInterface" object:nil];
            
            [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
            
        }else{
            [EasyShowTextView showErrorText:responseObject[@"message"]];
        }
        
    } enError:^(NSError *error) {
        
        self.loginBtn.enabled = YES;
        self.loginBtn.backgroundColor = MAIN_COLOR;
        
        [EasyShowLodingView hidenLoding];
        [EasyShowTextView showErrorText:error.localizedDescription];
    }];
}

//判空 给数字设置默认值
- (NSString *)judgeStringIsNull:(id )sender andDefault:(BOOL)isNeedDefault{
    
    NSString *str = [NSString stringWithFormat:@"%@",sender];
    
    if ([NSString StringIsNullOrEmpty:str]) {
        
        if (isNeedDefault) {
            return @"0.00";
        }else{
            return @"";
            
        }
    }else{
        return str;
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
    
    [DropMenu showMenu:arrM controlFrame:CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height + 5) MenuMaxHeight:150 cellHeight:30 isHaveMask:NO andReturnBlock:^(NSString *selectName, NSString *type_id) {
        
        self.groupTypeTF.text = selectName;
        self.group_id = type_id;
        
    }];
}
#pragma mark - 懒加载
- (NSMutableArray *)groupModels{
    if (!_groupModels) {
        _groupModels = [NSMutableArray array];
        
    }
    return _groupModels;
}

@end
