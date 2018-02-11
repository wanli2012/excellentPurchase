//
//  GLMine_Team_OpenMakerController.m
//  excellentPurchase
//
//  Created by 龚磊 on 2018/1/19.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "GLMine_Team_OpenMakerController.h"
#import "GLIdentifySelectController.h"//身份选择
//#import "GLMine_Team_StaffingController.h"//人员配置
#import "GLMine_Team_StaffingTabelController.h"//人员配置
#import "GLMine_Team_OpenSetModel.h"

///地址选择
#import "CZHAddressPickerView.h"
#import "AddressPickerHeader.h"

@interface GLMine_Team_OpenMakerController ()<UITextFieldDelegate>
{
    BOOL _isAgreeProtocol;//是否同意协议
}

@property (weak, nonatomic) IBOutlet UITextField *phoneTF;//手机号
@property (weak, nonatomic) IBOutlet UITextField *codeTF;//验证码
@property (weak, nonatomic) IBOutlet UITextField *staffingTF;//人员配置
@property (weak, nonatomic) IBOutlet UILabel *subordinateLabel;//下级
@property (weak, nonatomic) IBOutlet UILabel *remainderLabel;//剩余人数
@property (weak, nonatomic) IBOutlet UITextField *groupTypeTF;//身份类型
@property (weak, nonatomic) IBOutlet UITextField *areaTF;//地区

@property (weak, nonatomic) IBOutlet UITextField *passWordTF;//密码
@property (weak, nonatomic) IBOutlet UITextField *ensurePwdTF;//确认密码
@property (weak, nonatomic) IBOutlet UIImageView *signImageV;//同意标记
@property (weak, nonatomic) IBOutlet UIButton *getCodeBtn;//获取验证码
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;//提交按钮
@property (weak, nonatomic) IBOutlet UIView *setView;//设置人员view
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *setViewHeight;//设置人员view高度

@property (nonatomic, strong)NSArray *areaDataArr;//三级列表数据
@property (strong, nonatomic)NSString *provinceStrId;
@property (strong, nonatomic)NSString *cityStrId;
@property (strong, nonatomic)NSString *countryStrId;

@property (strong, nonatomic)NSString *provinceStr;
@property (strong, nonatomic)NSString *cityStr;
@property (strong, nonatomic)NSString *countryStr;

@property (nonatomic, copy)NSString *group_id;

@property (nonatomic, copy)NSString *citynumber;//市级服务中心人数
@property (nonatomic, copy)NSString *districtnumber;//区级服务中心人数
@property (nonatomic, copy)NSString *corenumber;//大区创客人数
@property (nonatomic, copy)NSString *regionnumber;//城市创客人数
@property (nonatomic, copy)NSString *makernumber;//创客人数


@property (nonatomic, assign)NSInteger selecctTypeIndex;//选中的身份下标

@property (nonatomic, strong)NSMutableArray *setModels;

@property (nonatomic, copy)NSArray *setArr;



@end

@implementation GLMine_Team_OpenMakerController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"开通创客";
    
    if([[UserModel defaultUser].group_id integerValue] == GROUP_GJTG){//高级创客身份
        self.setView.hidden = YES;
        self.setViewHeight.constant = 0;
    }
    
    [self requestStaffingPost];
}

#pragma mark - 请求下级可设置数据
- (void)requestStaffingPost{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"app_handler"] = @"SEARCH";
    dic[@"uid"] = [UserModel defaultUser].uid;
    dic[@"token"] = [UserModel defaultUser].token;
    
    [EasyShowLodingView showLodingText:@"正在请求数据"];
    [NetworkManager requestPOSTWithURLStr:kappend_subordinate paramDic:dic finish:^(id responseObject) {
        
        [EasyShowLodingView hidenLoding];
        
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE) {
            
            [self.setModels removeAllObjects];
            for (NSDictionary *dict in responseObject[@"data"][@"setup"]) {
                GLMine_Team_OpenSet_subModel *model = [GLMine_Team_OpenSet_subModel mj_objectWithKeyValues:dict];
                [self.setModels addObject:model];
            }
            
            if ([responseObject[@"data"][@"sub"] count] != 0) {
                
                self.subordinateLabel.text = responseObject[@"data"][@"sub"][0][@"name"];
                self.remainderLabel.text = responseObject[@"data"][@"sub"][0][@"msg"];
                self.group_id = responseObject[@"data"][@"sub"][0][@"group_id"];
            }
            
        }else{
            [EasyShowTextView showErrorText:responseObject[@"message"]];
        }
        
    } enError:^(NSError *error) {
        [EasyShowLodingView hidenLoding];
        [EasyShowTextView showErrorText:error.localizedDescription];
    }];
}

- (IBAction)getCode:(id)sender {
    
    if (self.phoneTF.text.length <=0 ) {
        [EasyShowTextView showInfoText:@"请输入手机号码"];
        return;
    }else{
        if (![predicateModel valiMobile:self.phoneTF.text]) {
            [EasyShowTextView showInfoText:@"手机号格式不对"];
            return;
        }
    }
    
    [self startTime];//获取倒计时
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"app_handler"] = @"SEARCH";
    dic[@"phone"] = self.phoneTF.text;
    
    [NetworkManager requestPOSTWithURLStr:kGETCODE_URL paramDic:dic finish:^(id responseObject) {
        
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE) {
            [EasyShowTextView showSuccessText:@"发送成功"];
            return;
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
                self.getCodeBtn.backgroundColor = [UIColor groupTableViewBackgroundColor];
                [self.getCodeBtn setTitleColor:MAIN_COLOR forState:UIControlStateNormal];
                self.getCodeBtn.titleLabel.font = [UIFont systemFontOfSize:13];
            });
            
        }else{
            
            int seconds = timeout % 61;
            NSString *strTime = [NSString stringWithFormat:@" %.2d秒后重新发送 ", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.getCodeBtn setTitle:[NSString stringWithFormat:@"%@",strTime] forState:UIControlStateNormal];
                self.getCodeBtn.userInteractionEnabled = NO;
                self.getCodeBtn.backgroundColor = [UIColor groupTableViewBackgroundColor];
                [self.getCodeBtn setTitleColor:MAIN_COLOR forState:UIControlStateNormal];
                self.getCodeBtn.titleLabel.font = [UIFont systemFontOfSize:11];
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
    
}

/**
 人员配备
 */
- (IBAction)staffing:(id)sender {
    
    [self.view endEditing:YES];
    
    if (self.setModels.count == 0) {
        [EasyShowTextView showInfoText:@"没有可配置的数据"];
        return;
    }
    
    self.hidesBottomBarWhenPushed = YES;
    GLMine_Team_StaffingTabelController *vc= [[GLMine_Team_StaffingTabelController alloc] init];
    
    
    __block typeof(self) weakSelf = self;
    
    vc.block = ^(NSArray *arr) {
        weakSelf.staffingTF.text = @"已配置";
        weakSelf.setArr = arr;
        
        switch ([[UserModel defaultUser].group_id integerValue]) {
            case 2://省级代理
            {
                weakSelf.districtnumber = arr[0];
                weakSelf.corenumber = arr[1];
                weakSelf.regionnumber = arr[2];
                weakSelf.makernumber = arr[3];
                
            }
                break;
            case 3://市级代理
            {
                
                weakSelf.corenumber = arr[0];
                weakSelf.regionnumber = arr[1];
                weakSelf.makernumber = arr[2];
            }
                break;
            case 4://区级代理
            {
                weakSelf.regionnumber = arr[0];
                weakSelf.makernumber = arr[1];
            }
                break;
            case 5://大区创客
            {
                weakSelf.makernumber = arr[0];
            }
                break;
            case 6://城市创客
            {
                weakSelf.makernumber = @"1";
            }
                break;
                
            default:
                break;
        }
    };
    
    [vc.models removeAllObjects];
    
    for (int i = 0; i < self.setModels.count; i++) {
        
        GLMine_Team_OpenSet_subModel *setmodel = self.setModels[i];
        if (self.setArr.count == self.setModels.count) {
            
            setmodel.personNum = [self.setArr[i] integerValue];
        }
        
        [vc.models addObject:setmodel];
        
    }
    
    [self.navigationController pushViewController:vc animated:YES];
    
    
    
}

/**
 身份类型选择
 */
- (IBAction)group_typeChoose:(id)sender {
    
    self.hidesBottomBarWhenPushed = YES;
    GLIdentifySelectController *vc = [[GLIdentifySelectController alloc] init];
    
    vc.selectIndex = self.selecctTypeIndex;
    
    __block typeof(self) weakSelf = self;
    vc.block = ^(NSString *name, NSString *group_id,NSInteger selectIndex) {
        weakSelf.groupTypeTF.text = name;
        weakSelf.group_id = group_id;
        weakSelf.selecctTypeIndex = selectIndex;
    };
    
    [self.navigationController pushViewController:vc animated:YES];
}


/**
 地区选择
 */
- (IBAction)areaChoose:(id)sender {
    
    [self.view endEditing:YES];
    self.areaDataArr = [self readLocalFileWithName:@"provincesamy"];
    
    [self popAreaPicker];
    
}
// 读取本地JSON文件
- (NSArray *)readLocalFileWithName:(NSString *)name {
    // 获取文件路径
    NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:@"json"];
    // 将文件数据化
    NSData *data = [[NSData alloc] initWithContentsOfFile:path];
    // 对数据进行JSON格式化并返回字典形式
    return [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
}


#pragma mark - 弹出省市区三级列表
- (void)popAreaPicker{
    
    WeakSelf;
    [CZHAddressPickerView areaPickerViewWithDataArr:self.areaDataArr AreaDetailBlock:^(NSString *province, NSString *city, NSString *area, NSString *province_id, NSString *city_id, NSString *area_id) {
        
        weakSelf.provinceStrId = province_id;
        weakSelf.cityStrId = city_id;
        
        if ([NSString StringIsNullOrEmpty:area_id]) {
            weakSelf.countryStrId = @"";
        }else{
            weakSelf.countryStrId = area_id;
        }
        
        weakSelf.provinceStr = province;
        weakSelf.cityStr = city;
        if ([NSString StringIsNullOrEmpty:area]) {
            weakSelf.countryStr = @"";
        }else{
            weakSelf.countryStr = area;
        }
        
        weakSelf.areaTF.text = [NSString stringWithFormat:@"%@%@%@",weakSelf.provinceStr,weakSelf.cityStr,weakSelf.countryStr];
    }];
    
}
/**
 创客承诺书
 */
- (IBAction)makerPromise:(id)sender {
    
    self.hidesBottomBarWhenPushed = YES;
    LLWebViewController *webVC = [[LLWebViewController alloc] initWithUrl:kProtocol_URL];
    webVC.titilestr = @"服务条款";
    [self.navigationController pushViewController:webVC animated:YES];
}

/**
 是否同意创客承诺书
 */
- (IBAction)isAgreeProtocol:(id)sender {
    
    _isAgreeProtocol = !_isAgreeProtocol;
    
    if (_isAgreeProtocol) {
        self.signImageV.image = [UIImage imageNamed:@"greetselect-y"];
    }else{
        self.signImageV.image = [UIImage imageNamed:@"greetselect-n"];
    }
}

#pragma mark - 提交
/**
 提交
 */
- (IBAction)submit:(id)sender {
    if (![predicateModel valiMobile:self.phoneTF.text]) {
        [EasyShowTextView showInfoText:@"手机号输入不正确"];
        return;
    }
    if (self.codeTF.text.length == 0) {
        [EasyShowTextView showInfoText:@"请填写验证码"];
        return;
    }
    if (self.codeTF.text.length == 0) {
        [EasyShowTextView showInfoText:@"请填写验证码"];
        return;
    }
    
    if ([[UserModel defaultUser].group_id integerValue] != GROUP_GJTG) {
        
        if (self.staffingTF.text.length == 0) {
            [EasyShowTextView showInfoText:@"请设置人员配置"];
            return;
        }
    }
    
    if (self.subordinateLabel.text.length == 0) {
        [EasyShowTextView showInfoText:@"未找到你的下级"];
        return;
    }
 
    if (self.areaTF.text.length == 0) {
        [EasyShowTextView showInfoText:@"请选择地区"];
        return;
    }
    if (self.passWordTF.text.length == 0) {
        [EasyShowTextView showInfoText:@"请填写账号的密码"];
        return;
    }
    if (self.ensurePwdTF.text.length == 0) {
        [EasyShowTextView showInfoText:@"请确认密码"];
        return;
    }
    if (![self.ensurePwdTF.text isEqualToString:self.passWordTF.text]) {
        [EasyShowTextView showInfoText:@"两次密码不一致,请检查后重新输入"];
        return;
    }
    
    if (!_isAgreeProtocol) {
        [EasyShowTextView showInfoText:@"请先同意创客承诺书"];
        return;
    }
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"app_handler"] = @"ADD";
    dic[@"uid"] = [UserModel defaultUser].uid;
    dic[@"token"] = [UserModel defaultUser].token;
    dic[@"internacode"] = @"+86";//国际电话Code码 如中国 +86
    dic[@"append_phone"] = self.phoneTF.text;//手机号码
    dic[@"append_group_id"] = self.group_id;//要开通的用户组 id
    dic[@"password"] = self.passWordTF.text;//密码
    dic[@"confirmPass"] = self.ensurePwdTF.text;//确认密码
    dic[@"user_province"] = self.provinceStrId;//省 id
    dic[@"user_city"] = self.cityStrId;//市 id
    dic[@"user_area"] = self.countryStrId;//区 id
    dic[@"yzm"] = self.codeTF.text;//验证码
    dic[@"citynumber"] = self.citynumber;//市级服务中心人数
    dic[@"districtnumber"] =self.districtnumber;//区级服务中心人数
    dic[@"corenumber"] =self.corenumber;//大区创客人数
    dic[@"regionnumber"] = self.regionnumber;//城市创客人数
    dic[@"makernumber"] = self.makernumber;//创客人数
    
    [EasyShowLodingView showLodingText:@"提交中"];
    [NetworkManager requestPOSTWithURLStr:kappend_lower paramDic:dic finish:^(id responseObject) {
        
        [EasyShowLodingView hidenLoding];
        
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE) {
            
            [EasyShowTextView showSuccessText:@"提交成功"];
            [self.navigationController popViewControllerAnimated:YES];
            
        }else{
            [EasyShowTextView showErrorText:responseObject[@"message"]];
        }
        
    } enError:^(NSError *error) {
        [EasyShowLodingView hidenLoding];
        [EasyShowTextView showErrorText:error.localizedDescription];
    }];
    
}

#pragma mark - UITextFieldDelegate 输入限制 输入判断
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == self.phoneTF) {
        [self.codeTF becomeFirstResponder];
    } else if(textField == self.codeTF){
        [self.passWordTF becomeFirstResponder];
    }else if(textField == self.passWordTF){
        [self.ensurePwdTF becomeFirstResponder];
    }else if(textField == self.ensurePwdTF){
        [self.view endEditing:YES];
    }
    
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (textField == self.phoneTF) {
        if (range.length == 1 && string.length == 0) {
            
            return YES;
            
        }else if (![predicateModel inputShouldNumber:string]) {
            
            return NO;
        }
    }
    
    return YES;
}

#pragma mark - 懒加载

- (NSMutableArray *)setModels{
    if (!_setModels) {
        _setModels = [NSMutableArray array];
    }
    return _setModels;
}

@end
