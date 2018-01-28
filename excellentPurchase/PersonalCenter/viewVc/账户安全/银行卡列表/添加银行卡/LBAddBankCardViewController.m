//
//  LBAddBankCardViewController.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/1/12.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "LBAddBankCardViewController.h"
#import "LBChooseBankTypeView.h"

@interface LBAddBankCardViewController ()
{
    BOOL _isDefault;//是否设为默认银行卡
}

@property (weak, nonatomic) IBOutlet UITextField *ownerTF;//持卡人
@property (weak, nonatomic) IBOutlet UITextField *bankNumberTF;//卡号
@property (weak, nonatomic) IBOutlet UITextField *bankTypeTF;//银行类型
@property (weak, nonatomic) IBOutlet UITextField *bankAddressTF;//银行地址
@property (weak, nonatomic) IBOutlet UITextField *codeTF;//验证码
@property (weak, nonatomic) IBOutlet UITextField *secondPasswordTF;//二级密码
@property (weak, nonatomic) IBOutlet UIButton *getCodeBtn;//获取验证码
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;//提交

@property (nonatomic, copy)NSString *bid;//所在银行id

@end

@implementation LBAddBankCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"添加银行卡";
    self.navigationController.navigationBar.hidden = NO;
    
}

/**
 选择银行卡类型
 */
- (IBAction)ChooseBankType:(UITapGestureRecognizer *)sender {
    [self.view endEditing:YES];
    
    
    
    [LBChooseBankTypeView areaPickerViewWithAreaBlock:^(NSString *bankType, NSString *bankcardType) {
        
    }];
    
}

/**
 获取验证码
 */
- (IBAction)getCode:(id)sender {
    
//    if (self.phoneTF.text.length <=0 ) {
//        [EasyShowTextView showInfoText:@"请输入手机号码"];
//        return;
//    }else{
//        if (![predicateModel valiMobile:self.phoneTF.text]) {
//            [EasyShowTextView showInfoText:@"手机号格式不对"];
//            return;
//        }
//    }
    
    [self startTime];//获取倒计时
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"app_handler"] = @"SEARCH";
    dic[@"uid"] = [UserModel defaultUser].uid;
    dic[@"token"] = [UserModel defaultUser].token;
    dic[@"name"] = self.ownerTF.text;
    dic[@"banknumber"] = self.bankNumberTF.text;
    dic[@"bid"] = self.bid;
    dic[@"bank_adderss"] = self.bankAddressTF.text;
    dic[@"is_default"] = @(_isDefault);
    dic[@"pwd"] = self.secondPasswordTF.text;
    dic[@"yzm"] = self.codeTF.text;
    
    [NetworkManager requestPOSTWithURLStr:kGETCODE_URL paramDic:dic finish:^(id responseObject) {
        
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE) {
            [self.navigationController popViewControllerAnimated:YES];
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
 提交
 */
- (IBAction)submit:(id)sender {
    
}

@end
