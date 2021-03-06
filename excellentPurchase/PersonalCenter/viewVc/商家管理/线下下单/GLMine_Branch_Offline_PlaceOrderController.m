//
//  GLMine_Branch_Offline_PlaceOrderController.m
//  excellentPurchase
//
//  Created by 龚磊 on 2018/1/25.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "GLMine_Branch_Offline_PlaceOrderController.h"
#import "GLMine_Team_UploadLicenseController.h"


@interface GLMine_Branch_Offline_PlaceOrderController ()<UITextFieldDelegate>
{
    BOOL _isAgreeProtocol;
}

@property (weak, nonatomic) IBOutlet UITextField *IDNumberTF;//ID号
@property (weak, nonatomic) IBOutlet UITextField *consumeTF;//消费金额
@property (weak, nonatomic) IBOutlet UITextField *noProfitTF;//奖励金额
@property (weak, nonatomic) IBOutlet UILabel *checkCodeLabel;//校验码
@property (weak, nonatomic) IBOutlet UIButton *buildBtn;//生成按钮
@property (weak, nonatomic) IBOutlet UIImageView *signImageV;//协议同意标志
@property (weak, nonatomic) IBOutlet UITextField *proofTF;//打款凭证

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewHeight;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;//提交按钮

@property (nonatomic, copy)NSString *proofUrl;//凭证图片url
@property (nonatomic, copy)NSString *line_id;//线下订单id

@property (nonatomic, assign)BOOL isHaveDian;

@end

@implementation GLMine_Branch_Offline_PlaceOrderController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"线下下单";
    self.contentViewHeight.constant = UIScreenHeight - SafeAreaTopHeight;
    
    self.IDNumberTF.text = self.model.user_name;
    self.consumeTF.text = self.model.line_money;
    self.noProfitTF.text = self.model.line_rl_money;
    self.proofUrl = self.model.line_dkpz_pic;
    self.line_id = self.model.line_id;
    
    
    if([UserModel defaultUser].checkCode.length == 0){
        [UserModel defaultUser].checkCode = [self getRandomStringWithNum:6];
    }
    self.checkCodeLabel.text = [UserModel defaultUser].checkCode;
    
    if(self.proofUrl.length != 0){
        self.proofTF.text = @"已上传";
    }
}


#pragma mark - 重新生成 校验码
- (IBAction)rebuild:(id)sender {

    [UserModel defaultUser].checkCode = [self getRandomStringWithNum:6];

    self.checkCodeLabel.text = [UserModel defaultUser].checkCode;
    
}

- (NSString *)getRandomStringWithNum:(NSInteger)num
{
    NSString *string = [[NSString alloc]init];
    for (int i = 0; i < num; i++) {
        int number = arc4random() % 36;
        if (number < 10) {
            int figure = arc4random() % 10;
            NSString *tempString = [NSString stringWithFormat:@"%d", figure];
            string = [string stringByAppendingString:tempString];
        }else {
            int figure = (arc4random() % 26) + 65;
            char character = figure;
            NSString *tempString = [NSString stringWithFormat:@"%c", character];
            string = [string stringByAppendingString:tempString];
        }
    }
    return string;
}

#pragma mark - 上传打卡款凭证
- (IBAction)uploadProof:(id)sender {

    WeakSelf;
    self.hidesBottomBarWhenPushed = YES;
    GLMine_Team_UploadLicenseController *uploadVC = [[GLMine_Team_UploadLicenseController alloc] init];
    uploadVC.firstUrl = self.proofUrl;
    
    uploadVC.block = ^(NSString *firstUrl) {
        
        weakSelf.proofUrl = firstUrl;
        if(self.proofUrl.length != 0){
            self.proofTF.text = @"已上传";
        }
        
    };
    
    [self.navigationController pushViewController:uploadVC animated:YES];
    
}

#pragma mark -  是否同意协议

- (IBAction)isAgreeProtocol:(id)sender {
    _isAgreeProtocol = !_isAgreeProtocol;
    if(_isAgreeProtocol){
        self.signImageV.image = [UIImage imageNamed:@"greetselect-y"];
        self.submitBtn.backgroundColor = MAIN_COLOR;
        self.submitBtn.enabled = YES;
    }else{
        self.signImageV.image = [UIImage imageNamed:@"greetselect-n"];
        self.submitBtn.backgroundColor = [UIColor lightGrayColor];
        self.submitBtn.enabled = NO;
    }
}

/*
 商家协议
*/
- (IBAction)sellerProtocol:(id)sender {

    self.hidesBottomBarWhenPushed = YES;
    LLWebViewController *webVC = [[LLWebViewController alloc] initWithUrl:kProtocol_URL];
    webVC.titilestr = @"服务条款";
    [self.navigationController pushViewController:webVC animated:YES];
}

#pragma mark - 提交
- (IBAction)submit:(id)sender {
    
    [self.view endEditing:YES];
    if (self.IDNumberTF.text.length == 0) {
        [EasyShowTextView showInfoText:@"请填写用户ID号"];
        return;
    }
    
    if (self.consumeTF.text.length == 0) {
        [EasyShowTextView showInfoText:@"请填写消费金额"];
        return;
    }
    if (self.noProfitTF.text.length == 0) {
        [EasyShowTextView showInfoText:@"请填写奖励金额"];
        return;
    }
    if (self.proofUrl.length == 0) {
        [EasyShowTextView showInfoText:@"请上传打款凭证"];
        return;
    }
    
    [self sureSubmit];
    
}
- (void)sureSubmit{
    
    self.submitBtn.backgroundColor = [UIColor lightGrayColor];
    self.submitBtn.enabled = NO;
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    dic[@"uid"] = [UserModel defaultUser].uid;
    dic[@"token"] = [UserModel defaultUser].token;
    dic[@"order_money"] = self.consumeTF.text;
    dic[@"rl_money"] = self.noProfitTF.text;
    dic[@"user_name"] = self.IDNumberTF.text;
    dic[@"dkpz"] = self.proofUrl;
    dic[@"ylxx"] = self.checkCodeLabel.text;
    
    NSString *url;
    if(self.type == 1){//1:线下下单 2:线下订单失败 重新下单
        url = kstore_commit;
        dic[@"app_handler"] = @"ADD";
    }else{
        dic[@"app_handler"] = @"UPDATE";
        dic[@"line_id"] = self.line_id;
        url = kagain_commit_order;
    }
    
    [EasyShowLodingView showLoding];

    [NetworkManager requestPOSTWithURLStr:url paramDic:dic finish:^(id responseObject) {
        [EasyShowLodingView hidenLoding];
        self.submitBtn.backgroundColor = MAIN_COLOR;
        self.submitBtn.enabled = YES;
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE) {
            
            [EasyShowTextView showSuccessText:@"提交成功"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"GLMine_RefreshNotification" object:nil];
            [self.navigationController popViewControllerAnimated:YES];
            
        }else{
            [EasyShowTextView showErrorText:responseObject[@"message"]];
        }
        
    } enError:^(NSError *error) {
        self.submitBtn.backgroundColor = MAIN_COLOR;
        self.submitBtn.enabled = YES;
        [EasyShowLodingView hidenLoding];
        [EasyShowTextView showErrorText:error.localizedDescription];
        
        
    }];
}
#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if (textField == self.IDNumberTF) {
        [self.consumeTF becomeFirstResponder];
    }else if(textField == self.consumeTF){
        [self.noProfitTF becomeFirstResponder];
    }else{
        [self.view endEditing:YES];
    }
    
    return YES;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if (range.length == 1 && string.length == 0) {
        
        return YES;
    }
    
    NSString *tem = [[string componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]componentsJoinedByString:@""];
    if (![string isEqualToString:tem]) {
        [EasyShowTextView showInfoText:@"标题中不能包含空格"];
        return NO;
        
    }
    
    if (textField == self.IDNumberTF) {
        if (![predicateModel inputShouldLetterOrNum:string]) {
            [EasyShowTextView showInfoText:@"用户ID只有数在和字母"];
            return NO;
        }
    }
    
    if (textField == self.consumeTF || textField == self.noProfitTF) {
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


-(NSMutableAttributedString*)addoriginstr:(NSString*)originstr specilstr:(NSArray*)specilstrArr{
    
    NSMutableAttributedString *noteStr = [[NSMutableAttributedString alloc] initWithString:originstr];
    for (int i = 0; i < specilstrArr.count; i++) {
        NSRange rang = [originstr rangeOfString:specilstrArr[i]];
        [noteStr addAttributes:@{NSForegroundColorAttributeName:LBHexadecimalColor(0x333333)} range:rang];
        [noteStr addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} range:rang];
    }
    
    
    return noteStr;
    
}

@end
