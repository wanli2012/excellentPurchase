//
//  LBImprovePersonalInformationViewController.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/1/10.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "LBImprovePersonalInformationViewController.h"
#import "LBUploadIdentityPictureViewController.h"

///地址选择
#import "CZHAddressPickerView.h"
#import "AddressPickerHeader.h"

@interface LBImprovePersonalInformationViewController ()

@property (weak, nonatomic) IBOutlet UITextField *IDTF;//身份证号码
@property (weak, nonatomic) IBOutlet UITextField *nameTF;//名字
@property (weak, nonatomic) IBOutlet UITextField *areaTF;//地区
@property (weak, nonatomic) IBOutlet UITextField *detailAddressTF;//详细地址
@property (weak, nonatomic) IBOutlet UILabel *uploadStatusLabel;//上传状态
@property (weak, nonatomic) IBOutlet UIButton *manBtn;//男
@property (weak, nonatomic) IBOutlet UIButton *womanBtn;//女
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *areaViewConstrait;//三级列表高度
@property (weak, nonatomic) IBOutlet UIView *areaView;//三级列表

@property (nonatomic, strong)NSArray *dataArr;

@property (strong, nonatomic)NSString *provinceStrId;
@property (strong, nonatomic)NSString *cityStrId;
@property (strong, nonatomic)NSString *countryStrId;

@property (strong, nonatomic)NSString *provinceStr;
@property (strong, nonatomic)NSString *cityStr;
@property (strong, nonatomic)NSString *countryStr;

@property (nonatomic, copy)NSString *user_sex;// 性别 0男 1女

@property (nonatomic, copy)NSString *faceUrl;//正面照url
@property (nonatomic, copy)NSString *oppositeUrl;//反面照url

@end

@implementation LBImprovePersonalInformationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"完善资料";
    
    self.user_sex = @"0";//默认选中男
    
    if([[UserModel defaultUser].group_id integerValue] == GROUP_USER){
        self.areaView.hidden = NO;
        self.areaViewConstrait.constant = 55;
    }else{
        self.areaView.hidden = YES;
        self.areaViewConstrait.constant = 0;
    }

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.faceUrl.length == 0 || self.oppositeUrl.length == 0) {
        self.uploadStatusLabel.hidden = YES;
    }else{
        self.uploadStatusLabel.hidden = NO;
    }
}

//上传身份照
- (IBAction)uploadidentitypictures:(UITapGestureRecognizer *)sender {
    self.hidesBottomBarWhenPushed = YES;
    LBUploadIdentityPictureViewController *vc =[[LBUploadIdentityPictureViewController alloc]init];
    vc.faceUrl = self.faceUrl;
    vc.oppositeUrl = self.oppositeUrl;
    WeakSelf;
    vc.block = ^(NSString *faceUrl, NSString *oppositeUrl) {
        weakSelf.faceUrl = faceUrl;
        weakSelf.oppositeUrl = oppositeUrl;
    };
    [self.navigationController pushViewController:vc animated:YES];
}

/**
 性别选择
 */
- (IBAction)sexChoose:(UIButton *)sender {
    
    if (sender == self.manBtn) {//user_sex 性别 0男 1女
        [self.manBtn setImage:[UIImage imageNamed:@"select-sex"] forState:UIControlStateNormal];
        [self.womanBtn setImage:[UIImage imageNamed:@"unselect-sex"] forState:UIControlStateNormal];
        self.user_sex = @"0";
    }else{
        [self.manBtn setImage:[UIImage imageNamed:@"unselect-sex"] forState:UIControlStateNormal];
        [self.womanBtn setImage:[UIImage imageNamed:@"select-sex"] forState:UIControlStateNormal];
        self.user_sex = @"1";
    }
}


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

#pragma mark - 保存数据
- (IBAction)save:(id)sender {
    
    [self.view endEditing:YES];
    
    if (self.nameTF.text.length < 2 || self.nameTF.text.length > 15) {
        [EasyShowTextView showInfoText:@"姓名请输入2-15位"];
        return;
    }
    if (self.IDTF.text.length == 0) {
        [EasyShowTextView showInfoText:@"请输入身份证号"];
        return;
    }
    
    if (self.IDTF.text.length != 15 && self.IDTF.text.length != 18) {
        [EasyShowTextView showInfoText:@"身份证号不合法"];
        return;
    }
    
    if (self.faceUrl.length == 0 || self.oppositeUrl.length == 0) {
        [EasyShowTextView showInfoText:@"请上传身份证正反面"];
        return;
    }
    
    if (self.detailAddressTF.text.length == 0) {
        [EasyShowTextView showInfoText:@"请输入详细地址"];
        return;
    }
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if([[UserModel defaultUser].group_id integerValue] == GROUP_USER){
        if (self.areaTF.text.length == 0) {
            [EasyShowTextView showInfoText:@"请选择地区"];
            return;
        }
        
        dict[@"province_id"] = self.provinceStrId;
        dict[@"city_id"] = self.cityStrId;
        dict[@"area_id"] = self.countryStrId;
        
    }
    
    dict[@"app_handler"] = @"UPDATE";
    dict[@"uid"] = [UserModel defaultUser].uid;
    dict[@"token"] = [UserModel defaultUser].token;
    dict[@"face_pic"] = self.faceUrl;
    dict[@"con_pic"] = self.oppositeUrl;
    dict[@"idcard"] = self.IDTF.text;
    dict[@"address"] = self.detailAddressTF.text;
    dict[@"user_sex"] = self.user_sex;
    dict[@"truename"] = self.nameTF.text;
    dict[@"type"] = @"1";//1 实名认证 2.修改个人信息
    
    [EasyShowLodingView showLoding];
    
    [NetworkManager requestPOSTWithURLStr:kperfect_get_info paramDic:dict finish:^(id responseObject) {
        [EasyShowLodingView hidenLoding];
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE) {
            
            [EasyShowTextView showSuccessText:@"资料完善成功"];
            
            if (self.block) {
                self.block(YES);
            }
            
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
    
    if (textField == self.nameTF) {
        [self.IDTF becomeFirstResponder];
    }else if(textField == self.IDTF){
        [self.detailAddressTF becomeFirstResponder];
    }else if(textField == self.detailAddressTF){
        [self.view endEditing:YES];
    }
    
    return YES;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if (range.length == 1 && string.length == 0) {
        
        return YES;
    }
    if (textField == self.nameTF) {
        if ([predicateModel inputShouldLetter:string] || [predicateModel inputShouldChinese:string]) {
            return YES;
        }else{
            [EasyShowTextView showInfoText:@"真实姓名输入不合法"];
            return NO;
        }
    }
    
    if (textField == self.IDTF) {
        
        if(![predicateModel inputShouldIDNumber:string]){
            [self.view endEditing:YES];
            [EasyShowTextView showInfoText:@"身份证号只能输入数字和X,x"];
            return NO;
        }
        
//        if (textField.text.length > 17) {
//            textField.text = [textField.text substringToIndex:18];
//            [self.view endEditing:YES];
//            [EasyShowTextView showInfoText:@"身份证号长度超过限制"];
//            return NO;
//        }
        
    }
    return YES;
}


@end
