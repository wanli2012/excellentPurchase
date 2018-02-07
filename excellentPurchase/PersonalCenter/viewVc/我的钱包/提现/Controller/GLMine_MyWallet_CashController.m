//
//  GLMine_MyWallet_CashController.m
//  excellentPurchase
//
//  Created by 龚磊 on 2018/1/26.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "GLMine_MyWallet_CashController.h"
#import "GLMine_MyWallet_CashRecordController.h"//提交记录
#import "LBBankCardListViewController.h"//银行卡列表

#import "HHPayPasswordView.h"
#import "IQKeyboardManager.h"

@interface GLMine_MyWallet_CashController ()<UITextFieldDelegate,HHPayPasswordViewDelegate>
{
    BOOL _isAgreeProtocol;
}

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewHeight;//contentView高度

@property (weak, nonatomic) IBOutlet UILabel *bankNameLabel;//银行名
@property (weak, nonatomic) IBOutlet UILabel *cardNumLabel;//银行卡号
@property (weak, nonatomic) IBOutlet UIImageView *iconImageV;//银行icon

@property (weak, nonatomic) IBOutlet UIView *addCardView;//添加view

@property (weak, nonatomic) IBOutlet UIImageView *signImageV;//同意标志
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;//金额
@property (weak, nonatomic) IBOutlet UITextField *moneyTF;//提现金额

@property (nonatomic, copy)NSString *bank_id;//所选银行卡的id

@property (nonatomic, assign)BOOL isHaveDian;

@end

@implementation GLMine_MyWallet_CashController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNav];
    
    self.contentViewHeight.constant = UIScreenHeight - SafeAreaTopHeight;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if (self.bank_id.length == 0) {
        self.addCardView.hidden = NO;
    }else{
        self.addCardView.hidden = YES;
    }
}

#pragma mark - 导航栏设置
- (void)setNav{
    
    self.navigationItem.title = @"提现";
    
    UIButton *button=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 80, 44)];
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;//右对齐
    
    [button setTitle:@"记录" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont systemFontOfSize:13]];
    button.backgroundColor = [UIColor clearColor];
    [button addTarget:self action:@selector(record) forControlEvents:UIControlEventTouchUpInside];

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
}

#pragma mark - 记录
- (void)record{

    self.hidesBottomBarWhenPushed = YES;
    GLMine_MyWallet_CashRecordController *idSelectVC = [[GLMine_MyWallet_CashRecordController alloc] init];
    [self.navigationController pushViewController:idSelectVC animated:YES];
}

#pragma mark - 银行卡选择
- (IBAction)bankCardChoose:(id)sender {

    WeakSelf;
    self.hidesBottomBarWhenPushed = YES;
    LBBankCardListViewController *vc = [[LBBankCardListViewController alloc] init];
    vc.pushType = 1;
    
    vc.block = ^(GLMine_CardModel *model) {
        weakSelf.bank_id = model.bank_id;
        weakSelf.bankNameLabel.text = model.bank_name;
        weakSelf.cardNumLabel.text = model.banknumber;
      
        //银行标识 1 中国农业银行 2 中国工商银行 3 中国建设银行 4 中国邮政银行 5 中国人民银行 6 中国民生银行 7 中国招商银行 8 中国银行 9 平安银行 10 交通银行 11 中信银行 12 兴业银行
        switch ([model.bank_icon integerValue]) {
            case 1:
            {
                weakSelf.iconImageV.image = [UIImage imageNamed:@"中国农业银行"];
            
            }
                break;
            case 2:
            {
                weakSelf.iconImageV.image = [UIImage imageNamed:@"中国工商银行"];
               
            }
                break;
            case 3:
            {
                weakSelf.iconImageV.image = [UIImage imageNamed:@"中国建设银行"];
                
            }
                break;
            case 4:
            {
                weakSelf.iconImageV.image = [UIImage imageNamed:@"中国邮政银行"];
                
            }
                break;
            case 8:
            {
                weakSelf.iconImageV.image = [UIImage imageNamed:@"中国银行"];
                
            }
                break;
                
            default:
            {
                weakSelf.iconImageV.image = [UIImage imageNamed:@"其他银行"];
                
            }
                break;
        }
    };
    
    
    [self.navigationController pushViewController:vc animated:YES];
    
}

#pragma mark - 创客承诺书
- (IBAction)toProtocol:(id)sender {
    
    NSLog(@"创客承诺书");
}

#pragma mark - 是否同意承诺书
- (IBAction)isAgreeProtocol:(id)sender {
    
    _isAgreeProtocol =! _isAgreeProtocol;
    
    if(_isAgreeProtocol){
        self.signImageV.image = [UIImage imageNamed:@"greetselect-y"];
    }else{
        self.signImageV.image = [UIImage imageNamed:@"greetselect-n"];
    }
}

#pragma mark - 提交
- (IBAction)submit:(id)sender {

    [self.view endEditing:YES];
    if ([self.moneyTF.text floatValue] == 0.0) {
        [EasyShowTextView showInfoText:@"请填写金额"];
        return;
    }
    
    if (self.bank_id.length == 0) {
        [EasyShowTextView showInfoText:@"请选择银行卡"];
        return;
    }
    
    if (!_isAgreeProtocol) {
        [EasyShowTextView showInfoText:@"请先同意协议"];
        return;
    }
    
    [IQKeyboardManager sharedManager].enable = NO;
    HHPayPasswordView *payPasswordView = [[HHPayPasswordView alloc] init];
    payPasswordView.delegate = self;
    [payPasswordView showInView:self.view];

}

-(void)passwordView:(HHPayPasswordView *)passwordView didFinishInputPayPassword:(NSString *)password{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"app_handler"] = @"ADD";
    dict[@"uid"] = [UserModel defaultUser].uid;
    dict[@"token"] = [UserModel defaultUser].token;
    dict[@"money"] = self.moneyTF.text;
    dict[@"bank_id"] = self.bank_id;
    dict[@"agreement"] = @"1";
    dict[@"paypswd"] = password;
    
    [EasyShowLodingView showLoding];
    [NetworkManager requestPOSTWithURLStr:kstore_balance paramDic:dict finish:^(id responseObject) {
        
        [EasyShowLodingView hidenLoding];
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE) {
            
            [EasyShowTextView showInfoText:responseObject[@"message"]];
            [self.navigationController popViewControllerAnimated:YES];
            
        }else{
            
            [EasyShowTextView showErrorText:responseObject[@"message"]];
        }
        
    } enError:^(NSError *error) {
        
        [EasyShowLodingView hidenLoding];
        [EasyShowTextView showErrorText:error.localizedDescription];
    }];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [self.view endEditing:YES];
    
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
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
