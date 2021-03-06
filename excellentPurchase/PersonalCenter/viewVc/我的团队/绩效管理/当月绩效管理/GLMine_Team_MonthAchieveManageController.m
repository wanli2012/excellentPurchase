//
//  GLMine_Team_MonthAchieveManageController.m
//  excellentPurchase
//
//  Created by 龚磊 on 2018/1/18.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "GLMine_Team_MonthAchieveManageController.h"
#import "GLIdentifySelectController.h"//身份选择
#import "GLMine_Team_AccountChooseController.h"//账号选择

@interface GLMine_Team_MonthAchieveManageController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *accountLabel;//账号
@property (weak, nonatomic) IBOutlet UITextField *achieveMoneyTF;//绩效金额

@property (nonatomic, copy)NSString *group_id;
@property (nonatomic, assign)BOOL isHaveDian;
@property (nonatomic, assign)NSInteger selectIndex;//选中身份下标

@end

@implementation GLMine_Team_MonthAchieveManageController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.navigationItem.title = @"当月绩效设置";
    
}

#pragma mark - 提交
- (IBAction)submit:(id)sender {

    if ([NSString StringIsNullOrEmpty:self.group_id]) {
        [EasyShowTextView showInfoText:@"请选择帐号"];
        return;
    }
    if ([NSString StringIsNullOrEmpty:self.achieveMoneyTF.text]) {
        [EasyShowTextView showInfoText:@"请输入绩效金额"];
        return;
    }
    
    if ([self.achieveMoneyTF.text floatValue] <= 0) {
        [EasyShowTextView showInfoText:@"输入绩效金额不能小于等于0"];
        return;
    }
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"app_handler"] = @"ADD";
    dic[@"uid"] = [UserModel defaultUser].uid;
    dic[@"token"] = [UserModel defaultUser].token;
    dic[@"set_uid"] = self.group_id;
    dic[@"money"] = self.achieveMoneyTF.text;
    
    [EasyShowLodingView showLoding];
    [NetworkManager requestPOSTWithURLStr:keamset_money paramDic:dic finish:^(id responseObject) {

        [EasyShowLodingView hidenLoding];
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE) {
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [EasyShowTextView showErrorText:responseObject[@"message"]];
        }

    } enError:^(NSError *error) {
       
        [EasyShowLodingView hidenLoding];
        [EasyShowTextView showErrorText:error.localizedDescription];
        
    }];
    
}

#pragma mark - 账号选择
- (IBAction)accountChoose:(id)sender {
    
    self.hidesBottomBarWhenPushed = YES;
    GLMine_Team_AccountChooseController *accountVC = [[GLMine_Team_AccountChooseController alloc] init];
    accountVC.retureSelecteArr = ^(NSMutableArray *uidarr,NSMutableArray *namearr) {
        self.accountLabel.text = [namearr componentsJoinedByString:@" "];
        self.group_id = [uidarr componentsJoinedByString:@","];
    };
    [self.navigationController pushViewController:accountVC animated:YES];
    
}
#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.view endEditing:YES];
    
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if (textField == self.achieveMoneyTF) {
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
//                [SVProgressHUD showErrorWithStatus:@"您的输入格式不正确"];
                return NO;
            }
            
            // 只能有一个小数点
            if (self.isHaveDian && single == '.') {
                
//                [SVProgressHUD showErrorWithStatus:@"最多只能输入一个小数点"];
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
                        
//                        [SVProgressHUD showErrorWithStatus:@"第二个字符需要是小数点"];
                        return NO;
                    }
                }else{
                    if (![string isEqualToString:@"."]) {
                        
//                        [SVProgressHUD showErrorWithStatus:@"第二个字符需要是小数点"];
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
                        
//                        [SVProgressHUD showErrorWithStatus:@"小数点后最多有两位小数"];
                        return NO;
                    }
                }
            }
        }
    }

    
    return YES;
}
@end
