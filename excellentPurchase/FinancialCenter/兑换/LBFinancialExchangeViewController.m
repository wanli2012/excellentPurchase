//
//  LBFinancialExchangeViewController.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/1/22.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "LBFinancialExchangeViewController.h"

@interface LBFinancialExchangeViewController ()<UITextFieldDelegate>
{
    BOOL _isAgreeProtocol;
}


@property (weak, nonatomic) IBOutlet UILabel *sumLabel;//优购劵总数
@property (weak, nonatomic) IBOutlet UITextField *exchangeNumTF;//兑换数量
@property (weak, nonatomic) IBOutlet UIImageView *signImageV;//标志
@property (weak, nonatomic) IBOutlet UIButton *ensureBtn;//确认兑换

@property (nonatomic, assign)BOOL isHaveDian;//是否有小数点了

@end

@implementation LBFinancialExchangeViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationController.navigationBar.hidden = NO;
    self.navigationItem.title = @"兑换";
    self.sumLabel.text = self.coupon;
}

/**
 兑换
 */
- (IBAction)exchange:(id)sender {
    
    [self.view endEditing:YES];
    
    if (self.exchangeNumTF.text.length == 0) {
        [EasyShowTextView showInfoText:@"请输入兑换数额"];
        return;
    }
    
    NSString *str = [NSString stringWithFormat:@"你确定要兑换%@购物劵吗?",self.exchangeNumTF.text];
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:str preferredStyle:UIAlertControllerStyleAlert];
    WeakSelf;
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        dic[@"app_handler"] = @"ADD";
        dic[@"uid"] = [UserModel defaultUser].uid;
        dic[@"token"] = [UserModel defaultUser].token;
        dic[@"sell_num"] = self.exchangeNumTF.text;
        
        weakSelf.ensureBtn.enabled = NO;
        weakSelf.ensureBtn.backgroundColor = [UIColor lightGrayColor];
        [EasyShowLodingView showLoding];
        [NetworkManager requestPOSTWithURLStr:ksell_mark paramDic:dic finish:^(id responseObject) {
            weakSelf.ensureBtn.enabled = YES;
            weakSelf.ensureBtn.backgroundColor = MAIN_COLOR;
            [EasyShowLodingView hidenLoding];
            if ([responseObject[@"code"] integerValue] == SUCCESS_CODE) {
                
                [EasyShowTextView showSuccessText:responseObject[@"message"]];
                [weakSelf.navigationController popViewControllerAnimated:YES];
                
            }else{
                [EasyShowTextView showErrorText:responseObject[@"message"]];
            }
            
        } enError:^(NSError *error) {
            
            weakSelf.ensureBtn.enabled = YES;
            weakSelf.ensureBtn.backgroundColor = MAIN_COLOR;
            [EasyShowLodingView hidenLoding];
            [EasyShowTextView showErrorText:error.localizedDescription];
            
        }];
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertVC addAction:ok];
    [alertVC addAction:cancel];
    
    [self presentViewController:alertVC animated:YES completion:nil];
    
}

/**
 兑换协议
 */
- (IBAction)toProtocol:(id)sender {
   
    self.hidesBottomBarWhenPushed = YES;
    LLWebViewController *webVC = [[LLWebViewController alloc] initWithUrl:kProtocol_URL];
    webVC.titilestr = @"服务条款";
    [self.navigationController pushViewController:webVC animated:YES];
}

/**
 是否同意兑换协议
 */
- (IBAction)isAgreeProtocol:(id)sender {
    _isAgreeProtocol = !_isAgreeProtocol;
    if (_isAgreeProtocol) {
        self.signImageV.image = [UIImage imageNamed:@"greetselect-y"];
        self.ensureBtn.userInteractionEnabled = YES;
        self.ensureBtn.backgroundColor = MAIN_COLOR;
    }else{
        self.signImageV.image = [UIImage imageNamed:@"greetselect-n"];
        self.ensureBtn.userInteractionEnabled = NO;
        self.ensureBtn.backgroundColor = [UIColor groupTableViewBackgroundColor];
    }
}


#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if (textField == self.exchangeNumTF) {
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
