//
//  LBVoucherCenterViewController.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/1/11.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "LBVoucherCenterViewController.h"
#import "GLMine_PaySucessController.h"//付款状态
#import "LBVoucherCenterRecoderViewController.h"

#import <AlipaySDK/AlipaySDK.h>
#import "WXApi.h"

@interface LBVoucherCenterViewController ()<UITextFieldDelegate>
{
    BOOL _isAgreeProtocol;
}
@property (weak, nonatomic) IBOutlet UIView *contentView;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UITextField *accountTF;//账号
@property (weak, nonatomic) IBOutlet UITextField *moneyTF;//金额
@property (weak, nonatomic) IBOutlet UIButton *weixinPayBtn;//微信支付标志
@property (weak, nonatomic) IBOutlet UIButton *alipayBtn;//支付宝支付标志
@property (weak, nonatomic) IBOutlet UIImageView *signImageV;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;

@property (nonatomic, assign)NSInteger payType;//1微信支付 2支付宝支付

@property (nonatomic, assign)BOOL isHaveDian;

@end

@implementation LBVoucherCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = NO;
    /**
     *支付宝成功 回调
     */
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(Alipaysucess) name:@"Alipaysucess" object:nil];
    
    /**
     *微信支付成功 回调
     */
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(wxpaysucess) name:@"wxpaysucess" object:nil];
    
    [self setNav];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyBoardDismiss)];
    [self.contentView addGestureRecognizer:tap];
    
}

- (void)keyBoardDismiss{
    [self.view endEditing:YES];
}

#pragma mark - 设置导航栏
- (void)setNav{
    
    self.navigationItem.title = @"充值中心";
    
    UIButton *button=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 80, 44)];
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;//右对齐
    
    [button setTitle:@"记录" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont systemFontOfSize:13]];
    button.backgroundColor = [UIColor clearColor];
    [button addTarget:self action:@selector(record) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    
}

- (void)record{
    
    self.hidesBottomBarWhenPushed = YES;
    
    LBVoucherCenterRecoderViewController *vc = [[LBVoucherCenterRecoderViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    
}

/**
 支付宝支付成功回调
 */
-(void)Alipaysucess{
    [self pushsucessVc];
}

/**
 微信支付成功回调
 */
-(void)wxpaysucess{
    [self pushsucessVc];
}

-(void)pushsucessVc{
    
//    self.hidesBottomBarWhenPushed = YES;
//    GLMine_PaySucessController *vc =[[GLMine_PaySucessController alloc]init];
//    vc.type = 1;
//    vc.piece =  [NSString stringWithFormat:@"¥ %@",self.datadic[@"order_money"]];
//    vc.odernum =  [NSString stringWithFormat:@"%@",self.datadic[@"order_num"]];
//    vc.method = self.payStr;
//    [self.navigationController pushViewController:vc animated:YES];
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(void)pushFailVc{
    self.hidesBottomBarWhenPushed = YES;
    GLMine_PaySucessController *vc =[[GLMine_PaySucessController alloc]init];
    vc.type = 2;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)payTypeChoose:(UITapGestureRecognizer *)tap {
    
    [self.weixinPayBtn setImage:[UIImage imageNamed:@"pay-select-n"] forState:UIControlStateNormal];
    [self.alipayBtn setImage:[UIImage imageNamed:@"pay-select-n"] forState:UIControlStateNormal];
    
    switch (tap.view.tag) {
        case 11:
        {
            
            [self.weixinPayBtn setImage:[UIImage imageNamed:@"pay-select-y"] forState:UIControlStateNormal];
            self.payType = 1;
            
        }
            break;
        case 12:
        {
            
            [self.alipayBtn setImage:[UIImage imageNamed:@"pay-select-y"] forState:UIControlStateNormal];
            self.payType = 2;
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
        self.submitBtn.backgroundColor = MAIN_COLOR;
    }else{
        self.submitBtn.backgroundColor = [UIColor lightGrayColor];
        self.signImageV.image = [UIImage imageNamed:@"greetselect-n"];
    }
}


#pragma mark - 须知
- (IBAction)toProtocol:(id)sender {
    
}

#pragma mark - 确认充值
- (IBAction)submit:(id)sender {
    
    [self.view endEditing:YES];
    
    if(self.moneyTF.text.length == 0){
        [EasyShowTextView showInfoText:@"请填写充值金额"];
        return;
    }
    
    if(self.payType == 0){
        [EasyShowTextView showInfoText:@"请填写充值金额"];
        return;
    }
    
    if(!_isAgreeProtocol){
        [EasyShowTextView showInfoText:@"请先同意承诺书"];
        return;
    }
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"app_handler"] = @"ADD";
    dict[@"uid"] = [UserModel defaultUser].uid;
    dict[@"token"] = [UserModel defaultUser].token;
    dict[@"account"] = self.accountTF.text;
    dict[@"money"] = self.moneyTF.text;
    dict[@"type"] = @(self.payType);//1微信支付 2支付宝支付
    
    [EasyShowLodingView showLoding];
    self.submitBtn.backgroundColor = [UIColor lightGrayColor];
    self.submitBtn.enabled = NO;
    [NetworkManager requestPOSTWithURLStr:kuser_recharge paramDic:dict finish:^(id responseObject) {
        
        [EasyShowLodingView hidenLoding];
        self.submitBtn.backgroundColor = MAIN_COLOR;
        self.submitBtn.enabled = YES;
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE) {
            
            if(self.payType == 2){//支付宝支付
                
                [[AlipaySDK defaultService]payOrder:responseObject[@"data"][@"aliPay"] fromScheme:@"excellentAlipay" callback:^(NSDictionary *resultDic) {
                    
                    NSInteger orderState = [resultDic[@"resultStatus"] integerValue];
                    if (orderState == 9000) {
                        self.hidesBottomBarWhenPushed = YES;
                        [self pushsucessVc];
                        
                    }else{
                        NSString *returnStr;
                        switch (orderState) {
                            case 8000:
                                returnStr=@"订单正在处理中";
                                break;
                            case 4000:
                                returnStr=@"订单支付失败";
                                break;
                            case 6001:
                                returnStr=@"订单取消";
                                break;
                            case 6002:
                                returnStr=@"网络连接出错";
                                break;
                            default:
                                break;
                        }
                        
                        [EasyShowTextView showErrorText:returnStr];
                    }
                }];
                
            }else{//微信支付
                
                //调起微信支付
                PayReq* req = [[PayReq alloc] init];
                req.openID=responseObject[@"data"][@"wxPay"][@"appid"];
                req.partnerId = responseObject[@"data"][@"wxPay"][@"partnerid"];
                req.prepayId = responseObject[@"data"][@"wxPay"][@"prepayid"];
                req.nonceStr = responseObject[@"data"][@"wxPay"][@"noncestr"];
                req.timeStamp = [responseObject[@"data"][@"wxPay"][@"timestamp"] intValue];
                req.package = responseObject[@"data"][@"wxPay"][@"package"];
                req.sign = responseObject[@"data"][@"wxPay"][@"sign"];
                [WXApi sendReq:req];
            }
            
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
