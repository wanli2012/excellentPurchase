//
//  LBMineCenterAddAdreassViewController.m
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/3/30.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "LBMineCenterAddAdreassViewController.h"

///地址选择
#import "CZHAddressPickerView.h"
#import "AddressPickerHeader.h"

@interface LBMineCenterAddAdreassViewController ()<UITextFieldDelegate>
{
    BOOL      _ishidecotr;//判断是否隐藏弹出控制器
}

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentVH;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentVW;

@property (weak, nonatomic) IBOutlet UITextField *nameTf;//收货人

@property (weak, nonatomic) IBOutlet UITextField *phoneTf;//手机号

@property (weak, nonatomic) IBOutlet UITextField *provinceTf;//地区(省市区)

@property (weak, nonatomic) IBOutlet UITextField *adressTf;//详细地址

@property (weak, nonatomic) IBOutlet UIButton *savebutoon;//保存按钮

@property (weak, nonatomic) IBOutlet UISwitch *is_defaultSwith;

@property (assign, nonatomic)NSInteger  isdeualt;//默认为0 不设为默认
@property (strong, nonatomic)NSString *adressID;
@property (strong, nonatomic)NSString *provinceStrId;
@property (strong, nonatomic)NSString *cityStrId;
@property (strong, nonatomic)NSString *countryStrId;

@property (strong, nonatomic)NSString *provinceStr;
@property (strong, nonatomic)NSString *cityStr;
@property (strong, nonatomic)NSString *countryStr;

@property (nonatomic, strong)NSArray *dataArr;

@end

@implementation LBMineCenterAddAdreassViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.hidden = NO;
    
    self.navigationItem.title = @"新增收货地址";
    
    if(_isEdit){//编辑
        
        self.isdeualt = [self.model.is_default boolValue];
        self.adressID = self.model.address_id;
        self.provinceStr = self.model.address_province;
        self.cityStr = self.model.address_city;
        self.countryStr = self.model.address_area;
        
        self.nameTf.text = self.model.truename;
        self.phoneTf.text = self.model.phone;
        
        if (self.model.chinese_area.length == 0) {
            self.provinceTf.text = [NSString stringWithFormat:@"%@%@",self.model.chinese_province,self.model.chinese_city];
        }else{
            self.provinceTf.text = [NSString stringWithFormat:@"%@%@%@",self.model.chinese_province,self.model.chinese_city,self.model.chinese_area];
        }
        
        self.adressTf.text = self.model.address_address;
        
        if (self.isdeualt) {
            [self.is_defaultSwith setOn:YES];
        }else{
            [self.is_defaultSwith setOn:NO];
        }
        
    }else{//添加
        
        self.isdeualt = 0;
        self.adressID = @"";
        self.provinceStrId = @"";
        self.cityStrId = @"";
        self.countryStrId = @"";
    }
    
}

#pragma mark - 地区选择
/**
 地区选择
 */
- (IBAction)areaChoose:(id)sender {
    
    [self.view endEditing:YES];

    self.dataArr = [self readLocalFileWithName:@"provincesamy"];
  
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
    [CZHAddressPickerView areaPickerViewWithDataArr:self.dataArr AreaDetailBlock:^(NSString *province, NSString *city, NSString *area, NSString *province_id, NSString *city_id, NSString *area_id) {
        weakSelf.provinceTf.text = [NSString stringWithFormat:@"%@%@%@",province,city,area];
        weakSelf.provinceStrId = province_id;
        weakSelf.cityStrId = city_id;
        weakSelf.countryStrId = area_id;
        
        weakSelf.provinceStr = province;
        weakSelf.cityStr = city;
        weakSelf.countryStr = area;
        
    }];
}

/**
 设置默认地址
 */
- (IBAction)isDefaultAddress:(UISwitch *)sender {
    
    if (sender.isOn) {
        self.isdeualt = YES;
    }else {
        self.isdeualt = NO;
    }
}

/**
 保存 或 删除
 */
- (IBAction)saveOrDelete:(id)sender {
    
    [self.view endEditing:YES];
    if (self.nameTf.text.length <= 0) {
        [EasyShowTextView showInfoText:@"请输入收货人姓名"];
        return;
    }
    if (self.nameTf.text.length < 2 || self.nameTf.text.length > 15) {
        
        [EasyShowTextView showInfoText:@"请输入2-15位名字"];
        return;
    }
    
    if (self.phoneTf.text.length <= 0) {
        
        [EasyShowTextView showInfoText:@"请输入电话号码"];
        return;
    }
    if (![predicateModel valiMobile:self.phoneTf.text]) {
        
        [EasyShowTextView showInfoText:@"请输入正确的电话号码"];
        return;
    }
    if (self.provinceTf.text.length <= 0) {
        
        [EasyShowTextView showInfoText:@"请选择省市区"];
        return;
    }
    if (self.adressTf.text.length <= 0) {
        [EasyShowTextView showInfoText:@"请输入详细地址"];
        return;
    }

    [EasyShowLodingView showLodingText:@"请求中"];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"uid"] = [UserModel defaultUser].uid;
    dic[@"token"] = [UserModel defaultUser].token;
    dic[@"truename"] = self.nameTf.text;
    dic[@"province"] = self.provinceStrId;
    dic[@"city"] = self.cityStrId;
    dic[@"area"] = self.countryStrId;
    dic[@"is_default"] = @(self.isdeualt);
    dic[@"phone"] = self.phoneTf.text;
    dic[@"address"] = self.adressTf.text;
    
    if (_isEdit) {//编辑
        
        dic[@"app_handler"] = @"UPDATE";
        dic[@"address_id"] = self.adressID;
        
    }else{//添加
        
        dic[@"app_handler"] = @"ADD";
        
    }
    
    [NetworkManager requestPOSTWithURLStr:kAddressed paramDic:dic finish:^(id responseObject) {
        [EasyShowLodingView hidenLoding];
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE) {
            
            [[NSNotificationCenter defaultCenter]postNotificationName:@"refreshReceivingAddress" object:nil];
            [EasyShowTextView showSuccessText:responseObject[@"message"]];
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
    
    if (textField == self.nameTf) {
        [self.phoneTf becomeFirstResponder];
    }else if(textField == self.phoneTf){
        [self.adressTf becomeFirstResponder];
    }else if(textField == self.adressTf){
        [self.view endEditing:YES];
    }
    return YES;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if (range.length == 1 && string.length == 0) {
        
        return YES;
    }
    
    if (textField == self.phoneTf) {
        
        if(![predicateModel inputShouldNumber:string]){
            
            [EasyShowTextView showInfoText:@"此处只能输入数字！"];
            return NO;
        }
    }
    
    return YES;
}

-(void)updateViewConstraints{
    
    [super updateViewConstraints];
    self.contentVH.constant = 310;
    self.contentVW.constant = UIScreenWidth;
    
    self.savebutoon.layer.cornerRadius = 4;
    self.savebutoon.clipsToBounds=YES;
    
}


@end
