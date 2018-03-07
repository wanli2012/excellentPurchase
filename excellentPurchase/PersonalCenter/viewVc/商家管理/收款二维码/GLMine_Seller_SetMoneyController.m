//
//  GLMine_Seller_SetMoneyController.m
//  excellentPurchase
//
//  Created by 龚磊 on 2018/2/7.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "GLMine_Seller_SetMoneyController.h"
#import "GLMine_Seller_IncomeCodeController.h"//商家二维码

@interface GLMine_Seller_SetMoneyController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIButton *ensureBtn;//确定按钮
@property (weak, nonatomic) IBOutlet UITextField *moneyTF;//金额
@property (weak, nonatomic) IBOutlet UITextField *noProfitTF;//奖励金额

@property (nonatomic, assign)BOOL isHaveDian;

@end

@implementation GLMine_Seller_SetMoneyController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"设置金额";
    
}

- (IBAction)ensure:(id)sender {
    
    self.hidesBottomBarWhenPushed = YES;
    GLMine_Seller_IncomeCodeController *vc = [[GLMine_Seller_IncomeCodeController alloc] init];
    
    vc.moneyCount = self.moneyTF.text;
    vc.noProfitMoney = self.noProfitTF.text;
    
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == self.moneyTF) {
        [self.noProfitTF becomeFirstResponder];
    }else{
        [self.view endEditing:YES];
    }
    
    return YES;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
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
