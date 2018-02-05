//
//  LBVoucherCenterViewController.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/1/11.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "LBVoucherCenterViewController.h"

@interface LBVoucherCenterViewController ()<UITextFieldDelegate>
{
    BOOL _isAgreeProtocol;
}

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UITextField *accountTF;//账号
@property (weak, nonatomic) IBOutlet UITextField *moneyTF;//金额
@property (weak, nonatomic) IBOutlet UIButton *weixinPayBtn;//微信支付标志
@property (weak, nonatomic) IBOutlet UIButton *alipayBtn;//支付宝支付标志
@property (weak, nonatomic) IBOutlet UIImageView *signImageV;

@property (nonatomic, assign)NSInteger payType;//1微信支付 2支付宝支付

@property (nonatomic, assign)BOOL isHaveDian;

@end

@implementation LBVoucherCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"充值中心";
    

}

- (IBAction)payTypeChoose:(UITapGestureRecognizer *)tap {
    
    [self.weixinPayBtn setImage:[UIImage imageNamed:@"pay-select-n"] forState:UIControlStateNormal];
    [self.alipayBtn setImage:[UIImage imageNamed:@"pay-select-n"] forState:UIControlStateNormal];
    
    
    switch (tap.view.tag) {
        case 11:
        {
        
            [self.weixinPayBtn setImage:[UIImage imageNamed:@"pay-select-y"] forState:UIControlStateNormal];
            
        }
            break;
        case 12:
        {
           
            [self.alipayBtn setImage:[UIImage imageNamed:@"pay-select-y"] forState:UIControlStateNormal];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - 是否同意须知
- (IBAction)isAgreeProtocol:(id)sender {
    _isAgreeProtocol =! _isAgreeProtocol;
    
    if(_isAgreeProtocol){
        self.signImageV.image = [UIImage imageNamed:@"greetselect-y"];
    }else{
        self.signImageV.image = [UIImage imageNamed:@"greetselect-n"];
    }
}


#pragma mark - 须知
- (IBAction)toProtocol:(id)sender {
    
}

#pragma mark - 确认充值
- (IBAction)submit:(id)sender {
    //kuser_recharge
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"app_handler"] = @"ADD";
    dict[@"account"] = self.accountTF.text;
    dict[@"uid"] = [UserModel defaultUser].uid;
    dict[@"token"] = [UserModel defaultUser].token;
    dict[@"money"] = self.moneyTF.text;
    dict[@"type"] = @(self.payType);

//    [NetworkManager requestPOSTWithURLStr:kREGISTER_URL paramDic:dict finish:^(id responseObject) {
//        //        [_loadV removeloadview];
//        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE) {
//
//            [EasyShowTextView showSuccessText:@"注册成功"];
//
//            [UIView animateWithDuration:0.3 animations:^{
//
//                [self.navigationController popViewControllerAnimated:YES];
//            }];
//
//        }else{
//            [EasyShowTextView showErrorText:responseObject[@"message"]];
//        }
//
//    } enError:^(NSError *error) {
//
//        //[_loadV removeloadview];
//        [EasyShowTextView showErrorText:error.localizedDescription];
//
//    }];
    
}

#pragma mark - UITextfieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == self.accountTF) {
        [self.moneyTF becomeFirstResponder];
    }else{
        [self.view endEditing:YES];
    }
    
    return YES;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{

    if (textField == self.accountTF) {
        
    }
    if (textField == self.moneyTF) {
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
                [EasyShowTextView showInfoText:@"您的输入格式不正确"];
                return NO;
            }
            
            // 只能有一个小数点
            if (self.isHaveDian && single == '.') {
                
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
                        
                        [EasyShowTextView showInfoText:@"第二个字符需要是小数点"];
                        return NO;
                    }
                }else{
                    if (![string isEqualToString:@"."]) {
                        
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
                        
                        [EasyShowTextView showInfoText:@"小数点后最多有两位小数"];
                        return NO;
                    }
                }
            }
        }
    }
    
    
    return YES;
}


@end
