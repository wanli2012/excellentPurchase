//
//  LBSendRedPackViewController.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/1/11.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "LBSendRedPackViewController.h"
#import "GLIdentifySelectModel.h"
#import "ValuePickerView.h"
#import "HHPayPasswordView.h"

@interface LBSendRedPackViewController ()<UITextFieldDelegate,HHPayPasswordViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *phonetf;
@property (weak, nonatomic) IBOutlet UITextField *identityTf;
@property (weak, nonatomic) IBOutlet UITextField *typetf;
@property (weak, nonatomic) IBOutlet UITextField *moneytf;
@property (weak, nonatomic) IBOutlet UIButton *sureBt;
@property (weak, nonatomic) IBOutlet UILabel *titileprotocol;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topconstrait;

@property (nonatomic, assign)BOOL isverification;//是否验证
@property (nonatomic, strong)NSMutableArray *groupArr;//类型
@property (nonatomic, copy)NSString *group_id;//被转赠人group_id
@property (nonatomic, assign)NSInteger type;//货币类型 1福宝 2积分
@property (nonatomic, strong)ValuePickerView *pickerView;

@end

@implementation LBSendRedPackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"发红包";
    self.titileprotocol.attributedText = [self addoriginstr:@"点击发红包，即表示已阅读并同意红包须知" specilstr:@[@"红包须知"]];
    
}
//点击协议
- (IBAction)tapgestureprotocol:(UITapGestureRecognizer *)sender {
    
    self.hidesBottomBarWhenPushed = YES;
    LLWebViewController *webVC = [[LLWebViewController alloc] initWithUrl:kProtocol_URL];
    webVC.titilestr = @"服务条款";
    [self.navigationController pushViewController:webVC animated:YES];
    
}
//同意协议
- (IBAction)agreeProtocol:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected == YES) {
        self.sureBt.backgroundColor = MAIN_COLOR;
        self.sureBt.userInteractionEnabled = YES;
    }else{
        self.sureBt.backgroundColor = LBHexadecimalColor(0xb3b3b3);
        self.sureBt.userInteractionEnabled = NO;
    }
}
//确认发送
- (IBAction)sureSend:(UIButton *)sender {
    
    if (self.phonetf.text.length <= 0) {
        [EasyShowTextView showInfoText:@"请填写获赠人"];
        return;
    }
    
    if (self.identityTf.text.length <= 0) {
        [EasyShowTextView showInfoText:@"请选择获赠人身份"];
        return;
    }
    
    if (self.typetf.text.length <= 0) {
        [EasyShowTextView showInfoText:@"请选择红包类型"];
        return;
    }
    
    if (self.moneytf.text.length <= 0) {
        [EasyShowTextView showInfoText:@"请填写红包额度"];
        return;
    }
    
    if ([self.moneytf.text integerValue]  <= 0) {
        [EasyShowTextView showInfoText:@"红包额度不能为0"];
        return;
    }
    
    if (self.type == 1) {//福宝
        if ([self.moneytf.text floatValue] > [[UserModel defaultUser].keti_bean floatValue]) {
            [EasyShowTextView showInfoText:@"福宝不足"];
            return;
        }
    }else{//积分
        if ([self.moneytf.text floatValue] > [[UserModel defaultUser].mark floatValue]) {
            [EasyShowTextView showInfoText:@"积分不足"];
            return;
        }
    }
    
    
    HHPayPasswordView *payPasswordView = [[HHPayPasswordView alloc] init];
    payPasswordView.delegate = self;
    [payPasswordView showInView:self.view];
    
    
}
//验证信息
- (IBAction)verificationevent:(UIButton *)sender {
    
    if ([NSString StringIsNullOrEmpty:self.phonetf.text]) {
        [EasyShowTextView showInfoText:@"请填写获赠人"];
        return;
    }
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"app_handler"] = @"SEARCH";
    dic[@"info"] = self.phonetf.text;
    dic[@"uid"] = [UserModel defaultUser].uid;
    dic[@"token"] = [UserModel defaultUser].token;
    
    self.isverification = NO;
    [self.groupArr removeAllObjects];
    [EasyShowLodingView showLodingText:@"正在请求数据"];
    [NetworkManager requestPOSTWithURLStr:kUserquery_info paramDic:dic finish:^(id responseObject) {
        self.isverification = YES;
        [EasyShowLodingView hidenLoding];
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE) {
            [EasyShowTextView showSuccessText:@"验证成功"];
            for (NSDictionary *dict in responseObject[@"data"]) {
                GLIdentifySelectModel *model = [GLIdentifySelectModel mj_objectWithKeyValues:dict];
                [self.groupArr addObject:model];
                
            }
            
        }else{
            [EasyShowTextView showErrorText:responseObject[@"message"]];
        }
        
    } enError:^(NSError *error) {
        [EasyShowLodingView hidenLoding];
        [EasyShowTextView showErrorText:error.localizedDescription];
    }];
}

#pragma mark - 转赠类型选择
- (IBAction)donationTypeChoose:(id)sender {
    
    [self.view endEditing:YES];
    
    NSMutableArray *arrM = [NSMutableArray array];
    
    [arrM addObject:@"福宝"];
    [arrM addObject:@"积分"];
    
    self.pickerView.dataSource = arrM;
    
    self.pickerView.pickerTitle = @"转赠类型";
    
    __weak typeof(self) weakSelf = self;//货币类型 1福宝 2积分
    
    self.pickerView.valueDidSelect = ^(NSString *value){
        
        NSArray * stateArr = [value componentsSeparatedByString:@"-"];
        NSInteger index = [stateArr[1] integerValue];
        
        weakSelf.type = index;
        weakSelf.typetf.text = stateArr[0];
        
    };
    
    [self.pickerView show];
    
}

#pragma mark - 身份类型选择
- (IBAction)group_TypeChoose:(id)sender {
    
    [self.view endEditing:YES];
    
    if (self.isverification == NO) {
        [EasyShowTextView showInfoText:@"请验证你的身份"];
        return;
    }else{
        if(self.groupArr.count != 0){
            [self popIdentifyChoose];
        }else{
            [EasyShowTextView showInfoText:@"暂无身份信息"];
        }
    }
    
}
- (void)popIdentifyChoose{
    
    NSMutableArray *arrM = [NSMutableArray array];
    for (GLIdentifySelectModel *model in self.groupArr) {
        [arrM addObject:[NSString stringWithFormat:@"%@(%@)",model.truename,model.group_name]];
    }
    
    self.pickerView.dataSource = arrM;
    
    self.pickerView.pickerTitle = @"身份类型";
    
    __weak typeof(self) weakSelf = self;
    
    self.pickerView.valueDidSelect = ^(NSString *value){
        NSArray * stateArr = [value componentsSeparatedByString:@"-"];
        NSInteger index = [stateArr[1] integerValue];
        
        if (index >= 1) {
            
            GLIdentifySelectModel *model = weakSelf.groupArr[index - 1];
            weakSelf.group_id = model.group_id;
        }else{
            weakSelf.group_id = @"";
            
        }
        
        weakSelf.identityTf.text = stateArr[0];
        
    };
    
    [self.pickerView show];
}
-(void)actionSure:(NSString *)password{
    if (password.length < 6) {
        [EasyShowTextView showInfoText:@"请输入二级密码"];
        return;
    }
}
-(void)passwordView:(HHPayPasswordView *)passwordView didFinishInputPayPassword:(NSString *)password{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"app_handler"] = @"ADD";
    dic[@"uid"] = [UserModel defaultUser].uid;
    dic[@"token"] = [UserModel defaultUser].token;
    dic[@"group_id"] = self.group_id;
    dic[@"obtain_user"] = self.phonetf.text;
    dic[@"numbers"] = self.moneytf.text;
    dic[@"password"] = [RSAEncryptor encryptString:password publicKey:public_RSA];
    dic[@"type"] = @(self.type);

    [NetworkManager requestPOSTWithURLStr:kRedEnvelopesend_red_gift paramDic:dic finish:^(id responseObject) {
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE) {
            [passwordView paySuccess];
            if (self.refreshdata) {
                self.refreshdata();
            }
            [self.navigationController popViewControllerAnimated: YES];
        }else{
            [passwordView payFailureWithPasswordError:YES withErrorLimit:2 message:responseObject[@"message"]];
        }
        
    } enError:^(NSError *error) {
        [passwordView payFailureWithPasswordError:YES withErrorLimit:2 message:error.localizedDescription];
    }];
}

-(NSMutableAttributedString*)addoriginstr:(NSString*)originstr specilstr:(NSArray*)specilstrArr{
    
    NSMutableAttributedString *noteStr = [[NSMutableAttributedString alloc] initWithString:originstr];
    for (int i = 0; i < specilstrArr.count; i++) {
        NSRange rang = [originstr rangeOfString:specilstrArr[i]];
        [noteStr addAttributes:@{NSForegroundColorAttributeName:MAIN_COLOR} range:rang];
        [noteStr addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} range:rang];
    }
    
    return noteStr;
    
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if (textField == _phonetf && [string isEqualToString:@"\n"]) {
        [self.moneytf becomeFirstResponder];
    }
    
    return YES;
}

-(void)updateViewConstraints{
    [super updateViewConstraints];
    self.topconstrait.constant = SafeAreaTopHeight;
}

-(NSMutableArray *)groupArr{
    
    if (!_groupArr) {
        _groupArr = [NSMutableArray array];
    }
    
    return _groupArr;
}
- (ValuePickerView *)pickerView{
    if (!_pickerView) {
        _pickerView = [[ValuePickerView alloc] init];
    }
    return _pickerView;
}

@end
