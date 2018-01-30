//
//  LBFinancialCenetrSaleViewController.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/1/22.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "LBFinancialCenetrSaleViewController.h"
#import "LBBankCardListViewController.h"//银行卡列表
#import "HHPayPasswordView.h"//密码框弹出
#import "IQKeyboardManager.h"

@interface LBFinancialCenetrSaleViewController ()<HHPayPasswordViewDelegate>
//到账方式
@property (weak, nonatomic) IBOutlet UIButton *payOneBt;//T+1
@property (weak, nonatomic) IBOutlet UIButton *payTwoBt;//T+3
@property (weak, nonatomic) IBOutlet UIButton *payThreeBt;//T+7

@property (weak, nonatomic) IBOutlet UILabel *myCoinLabel;//我的优购币
@property (weak, nonatomic) IBOutlet UIImageView *bankIconV;//银行图标
@property (weak, nonatomic) IBOutlet UILabel *bankNameLabel;//银行名
@property (weak, nonatomic) IBOutlet UILabel *bankNumberLabel;//卡号
@property (weak, nonatomic) IBOutlet UIButton *changeCardBtn;//换卡按钮

@property (weak, nonatomic) IBOutlet UITextField *sellNumTF;//出售数量
@property (weak, nonatomic) IBOutlet UIButton *ensureSellBtn;//确认出售按钮
@property (weak, nonatomic) IBOutlet UIImageView *signImageV;//标志

@property (nonatomic, assign)NSInteger payType;//类型1:T+1 2:T+2 3:T+3
@property (nonatomic, assign)BOOL isHaveDian;

@end

@implementation LBFinancialCenetrSaleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = NO;
    self.navigationItem.title = @"出售";

}

//到账时间选择
- (IBAction)payWayChoose:(UIButton *)sender {
    
    [self.payOneBt setImage:[UIImage imageNamed:@"unselect-sex"] forState:UIControlStateNormal];
    [self.payTwoBt setImage:[UIImage imageNamed:@"unselect-sex"] forState:UIControlStateNormal];
    [self.payThreeBt setImage:[UIImage imageNamed:@"unselect-sex"] forState:UIControlStateNormal];
    
    [sender setImage:[UIImage imageNamed:@"select-sex"] forState:UIControlStateNormal];
    
    if (sender == self.payOneBt) {//类型1:T+1 2:T+2 3:T+3
        self.payType = 1;
    }else if(sender == self.payTwoBt){
        self.payType = 2;
    }else if(sender == self.payThreeBt){
        self.payType = 3;
    }
    
}

//更换银行卡
- (IBAction)changeCard:(id)sender {
    
    self.hidesBottomBarWhenPushed = YES;
    LBBankCardListViewController *vc = [[LBBankCardListViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    
}

//更新约束
-(void)updateViewConstraints{
    [super updateViewConstraints];
    
    [self.payOneBt horizontalCenterTitleAndImage:5];
    [self.payTwoBt horizontalCenterTitleAndImage:5];
    [self.payThreeBt horizontalCenterTitleAndImage:5];
    
}

//确认出售
- (IBAction)ensureSell:(id)sender {
    //kwithdraw_cash
    
     [IQKeyboardManager sharedManager].enable = NO;
    
    HHPayPasswordView *payPasswordView = [[HHPayPasswordView alloc] init];
    payPasswordView.delegate = self;
    [payPasswordView showInView:self.view];
    
}

//出售请求
- (void)sellPost:(NSString *)secondPwd{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"app_handler"] = @"SEARCH";
    dic[@"uid"] = [UserModel defaultUser].uid;
    dic[@"token"] = [UserModel defaultUser].token;
    //    dic[@"bank_id"] = ;
    dic[@"back_money"] = self.sellNumTF.text;
    dic[@"back_choice"] = @(self.payType);
    dic[@"user_pwd"] = secondPwd;
    
    [EasyShowLodingView showLoding];
    [NetworkManager requestPOSTWithURLStr:kget_money_list paramDic:dic finish:^(id responseObject) {
        
        [EasyShowLodingView hidenLoding];
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE) {
            
            
        }else{
            [EasyShowTextView showErrorText:responseObject[@"message"]];
        }
        
        
        
    } enError:^(NSError *error) {
        
        [EasyShowLodingView hidenLoding];
        [EasyShowTextView showErrorText:error.localizedDescription];
        
        
    }];
}
#pragma mark - HHPayPasswordViewDelegate
- (void)passwordView:(HHPayPasswordView *)passwordView didFinishInputPayPassword:(NSString *)password{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"app_handler"] = @"SEARCH";
    dic[@"uid"] = [UserModel defaultUser].uid;
    dic[@"token"] = [UserModel defaultUser].token;
    //    dic[@"bank_id"] = ;
    dic[@"back_money"] = self.sellNumTF.text;
    dic[@"back_choice"] = @(self.payType);
    dic[@"user_pwd"] = password;
    
    [EasyShowLodingView showLoding];
    [NetworkManager requestPOSTWithURLStr:kget_money_list paramDic:dic finish:^(id responseObject) {
        [EasyShowLodingView hidenLoding];
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE) {
            
            
        }else{
            [EasyShowTextView showErrorText:responseObject[@"message"]];
        }
        
        
        [passwordView hide];
        [IQKeyboardManager sharedManager].enable = YES;
    } enError:^(NSError *error) {
        [passwordView hide];
         [IQKeyboardManager sharedManager].enable = YES;
        [EasyShowLodingView hidenLoding];
        [EasyShowTextView showErrorText:error.localizedDescription];
        
        
    }];
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    
        
//        if ([password isEqualToString:@"000000"]) {
//            [passwordView paySuccess];
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                [passwordView hide];
////                PaySuccessViewController *paySuccessVC = [[PaySuccessViewController alloc] init];
////                [self.navigationController pushViewController:paySuccessVC animated:YES];
//            });
//        }else{
//            [passwordView payFailureWithPasswordError:YES withErrorLimit:3];
//        }
//    });
    
}
/**
 点击确认
 */
- (void)actionSure{
    
}



#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if (textField == self.sellNumTF) {
        [self.view endEditing:YES];
    }
    
    return YES;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    /*
     * 不能输入.0-9以外的字符。
     * 设置输入框输入的内容格式
     * 只能有一个小数点
     * 小数点后最多能输入两位
     * 如果第一位是.则前面加上0.
     * 如果第一位是0则后面必须输入点，否则不能输入。
     */
    
    // 判断是否有小数点
    if ([textField.text containsString:@"."]) {
        self.isHaveDian = YES;
    }else{
        self.isHaveDian = NO;
    }
    
    if (string.length > 0) {
        
        //当前输入的字符
        unichar single = [string characterAtIndex:0];
        
        // 不能输入.0-9以外的字符
        if (!((single >= '0' && single <= '9') || single == '.' || single == '\n'))
        {
            [self.view endEditing:YES];
            [EasyShowTextView showInfoText:@"您的输入格式不正确"];
            return NO;
        }
        
        // 只能有一个小数点
        if (self.isHaveDian && single == '.') {
            
            [self.view endEditing:YES];
            [EasyShowTextView showInfoText:@"最多只能输入一个小数点"];
            return NO;
        }
        
        // 如果第一位是.则前面加上0.
        if ((textField.text.length == 0) && (single == '.')) {
            textField.text = @"0";
        }
        
        // 如果第一位是0则后面必须输入点，否则不能输入。
        if ([textField.text hasPrefix:@"0"]) {
            if (textField.text.length > 1) {
                NSString *secondStr = [textField.text substringWithRange:NSMakeRange(1, 1)];
                if (![secondStr isEqualToString:@"."]) {
                    
                    [self.view endEditing:YES];
                    [EasyShowTextView showInfoText:@"第二个字符需要是小数点"];
                    return NO;
                }
            }else{
                if (![string isEqualToString:@"."]) {
                    [self.view endEditing:YES];
                    [EasyShowTextView showInfoText:@"第二个字符需要是小数点"];
                    return NO;
                }
            }
        }
        
        // 小数点后最多能输入两位
        if (self.isHaveDian) {
            NSRange ran = [textField.text rangeOfString:@"."];
            // 由于range.location是NSUInteger类型的，所以这里不能通过(range.location - ran.location)>2来判断
            if (range.location > ran.location) {
                if ([textField.text pathExtension].length > 1) {
                    [self.view endEditing:YES];
                    [EasyShowTextView showInfoText:@"小数点后最多有两位小数"];
                    return NO;
                }
            }
        }
    }
    
    return YES;
}



@end
