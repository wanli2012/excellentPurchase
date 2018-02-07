//
//  LBDonationViewController.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/1/11.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "LBDonationViewController.h"
#import "GLIdentifySelectModel.h"
#import "IQKeyboardManager.h"

#import "ValuePickerView.h"
#import "HHPayPasswordView.h"

#import "LBDonationRecoderViewController.h"//转赠记录

@interface LBDonationViewController ()<UITextFieldDelegate,HHPayPasswordViewDelegate>
{
    BOOL _isAgreeProtocol;
}

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *signImageV;//是否同意标志
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;//提交
@property (weak, nonatomic) IBOutlet UILabel *integralLabel;//积分
@property (weak, nonatomic) IBOutlet UILabel *coinLabel;//优购币

@property (weak, nonatomic) IBOutlet UITextField *receiveManTF;//接收人TF
@property (weak, nonatomic) IBOutlet UITextField *moneyTF;//金额

@property (weak, nonatomic) IBOutlet UITextField *donationTypeTF;//转赠类型
@property (weak, nonatomic) IBOutlet UITextField *receiveManGroupTypeTF;//接收人身份


@property (nonatomic, assign)BOOL isHaveDian;

@property (nonatomic, copy)NSString *group_id;//被转赠人group_id
@property (nonatomic, assign)NSInteger type;//货币类型 1优购币 2积分

@property (nonatomic, strong)NSMutableArray *donationTypeArr;//转赠类型
@property (nonatomic, strong)NSMutableArray *groupArr;//身份类型

@property (nonatomic, strong)ValuePickerView *pickerView;

@end

@implementation LBDonationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNav];
    
}

#pragma mark - 设置导航栏
- (void)setNav{
    
    self.navigationItem.title = @"转赠";
    
    UIButton *button=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 80, 44)];
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;//右对齐
    
    [button setTitle:@"记录" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont systemFontOfSize:13]];
    button.backgroundColor = [UIColor clearColor];
    [button addTarget:self action:@selector(record) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    
}

//记录
- (void)record{
    
    self.hidesBottomBarWhenPushed = YES;
    
    LBDonationRecoderViewController *vc = [[LBDonationRecoderViewController alloc] init];
    
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [IQKeyboardManager sharedManager].enable = YES;
}
#pragma mark - 确认转赠
- (IBAction)submit:(id)sender {
    
    [self.view endEditing:YES];
    if ([self.moneyTF.text floatValue] == 0.0) {
        [EasyShowTextView showInfoText:@"请填写转赠金额"];
        return;
    }
    if(self.receiveManTF.text.length == 0){
        [EasyShowTextView showInfoText:@"请填写接收人ID或者手机号"];
        return;
    }
    if (self.type == 0) {
        [EasyShowTextView showInfoText:@"请选择转赠类型"];
        return;
    }
    if (self.group_id == 0) {
        [EasyShowTextView showInfoText:@"请选择接收人身份类型"];
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
    dict[@"obtain_user"] = self.receiveManTF.text;
    dict[@"numbers"] = self.moneyTF.text;
    dict[@"type"] = @(self.type);//货币类型 1优购币 2积分’,
    dict[@"group_id"] = self.group_id;
    dict[@"password"] = password;
    
    [EasyShowLodingView showLoding];
    [NetworkManager requestPOSTWithURLStr:kgive paramDic:dict finish:^(id responseObject) {
        
        [EasyShowLodingView hidenLoding];
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE) {
//
//            [EasyShowTextView showInfoText:responseObject[@"message"]];
            [self.navigationController popViewControllerAnimated:YES];
            
        }else{
            
//            [EasyShowTextView showErrorText:responseObject[@"message"]];
        }
        
    } enError:^(NSError *error) {
        
        [EasyShowLodingView hidenLoding];
        [EasyShowTextView showErrorText:error.localizedDescription];
    }];
}

#pragma mark - 是否同意协议
- (IBAction)isAgreeProtocol:(id)sender {
    _isAgreeProtocol =! _isAgreeProtocol;
    
    if(_isAgreeProtocol){
        self.signImageV.image = [UIImage imageNamed:@"greetselect-y"];
    }else{
        self.signImageV.image = [UIImage imageNamed:@"greetselect-n"];
    }
    
}

#pragma mark - 充值须知
- (IBAction)toProtocol:(id)sender {
    
}

#pragma mark - 转赠类型选择
- (IBAction)donationTypeChoose:(id)sender {
    
    NSMutableArray *arrM = [NSMutableArray array];
    
    [arrM addObject:@"优购币"];
    [arrM addObject:@"积分"];
    
    self.pickerView.dataSource = arrM;
    
    self.pickerView.pickerTitle = @"转赠类型";
    
    __weak typeof(self) weakSelf = self;//货币类型 1优购币 2积分
    
    self.pickerView.valueDidSelect = ^(NSString *value){
        
        NSArray * stateArr = [value componentsSeparatedByString:@"/"];
        NSInteger index = [stateArr[1] integerValue];

        weakSelf.type = index + 1;
        weakSelf.donationTypeTF.text = stateArr[0];
       
    };
    
    [self.pickerView show];
    
}

#pragma mark - 身份类型选择
- (IBAction)group_TypeChoose:(id)sender {
    
    [self.view endEditing:YES];
    
    if(self.groupArr.count != 0){
        [self popIdentifyChoose];
        return;
    }
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"app_handler"] = @"SEARCH";
    dic[@"type"] = @"1";//1:获取全部用户身份(除副总) 2:会员/商家
    
    [EasyShowLodingView showLodingText:@"正在请求数据"];
    [NetworkManager requestPOSTWithURLStr:kGet_GroupList_URL paramDic:dic finish:^(id responseObject) {
        
        [EasyShowLodingView hidenLoding];
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE) {
            for (NSDictionary *dict in responseObject[@"data"]) {
                
                GLIdentifySelectModel *model = [GLIdentifySelectModel mj_objectWithKeyValues:dict];
                [self.groupArr addObject:model];
                
            }
            [self popIdentifyChoose];
        }else{
            [EasyShowTextView showErrorText:responseObject[@"message"]];
        }
        
    } enError:^(NSError *error) {
        [EasyShowLodingView hidenLoding];
        [EasyShowTextView showErrorText:error.localizedDescription];
    }];
}

- (void)popIdentifyChoose{
    
    NSMutableArray *arrM = [NSMutableArray array];
    for (GLIdentifySelectModel *model in self.groupArr) {
        [arrM addObject:model.group_name];
    }
    
    self.pickerView.dataSource = arrM;
    
    self.pickerView.pickerTitle = @"身份类型";
    
    __weak typeof(self) weakSelf = self;
    
    self.pickerView.valueDidSelect = ^(NSString *value){
        
        NSArray * stateArr = [value componentsSeparatedByString:@"/"];
        NSInteger index = [stateArr[1] integerValue];
        
        GLIdentifySelectModel *model = weakSelf.groupArr[index];
        weakSelf.group_id = model.group_id;
        weakSelf.receiveManGroupTypeTF.text = stateArr[0];
        
    };
    
    [self.pickerView show];
}

#pragma mark - UITextfieldDelegate
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

#pragma mark - 懒加载
-(NSMutableArray *)donationTypeArr{
    
    if (!_donationTypeArr) {
        _donationTypeArr = [NSMutableArray array];
    }
    
    return _donationTypeArr;
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
