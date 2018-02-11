//
//  GLMine_Team_OpenSellerController.m
//  excellentPurchase
//
//  Created by 龚磊 on 2018/1/19.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "GLMine_Team_OpenSellerController.h"
#import "GLMine_Team_UploadLicenseController.h"//单张图片上传
#import "LBUploadIdentityPictureViewController.h"//身份证正反面上传
#import "LBBaiduMapViewController.h"
///地址选择
#import "CZHAddressPickerView.h"
#import "AddressPickerHeader.h"

//单项Picker
#import "ValuePickerView.h"

#import "GLMine_stroeTypeModel.h"//店铺类型模型
#import "GLMine_BrandModel.h"//品牌模型

@interface GLMine_Team_OpenSellerController ()<UITextFieldDelegate>
{
    BOOL _isAgreeProtocol;
}

@property (weak, nonatomic) IBOutlet UITextField *phoneTF;//手机号
@property (weak, nonatomic) IBOutlet UITextField *codeTF;//验证码
@property (weak, nonatomic) IBOutlet UITextField *recommendIDTF;//推荐人ID
@property (weak, nonatomic) IBOutlet UITextField *shopNameTF;//店铺名
@property (weak, nonatomic) IBOutlet UITextField *storeTypeTF;//店铺类型

@property (weak, nonatomic) IBOutlet UITextField *brandTF;//品牌名称
@property (weak, nonatomic) IBOutlet UITextField *brandCertificateTF;//微商授权书
@property (weak, nonatomic) IBOutlet UITextField *licenseTF;//营业执照
@property (weak, nonatomic) IBOutlet UITextField *legalPersonIDTF;//法人身份证
@property (weak, nonatomic) IBOutlet UITextField *areaTF;//地区

@property (weak, nonatomic) IBOutlet UITextField *addressTF;//详细地址
@property (weak, nonatomic) IBOutlet UITextField *mapLoacationTF;//地图定位
@property (weak, nonatomic) IBOutlet UITextField *contractPhoneTF;//联系号码
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;//密码
@property (weak, nonatomic) IBOutlet UITextField *ensurepwdTF;//确认密码

@property (weak, nonatomic) IBOutlet UIImageView *signImageV;//选中标志
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;//提交
@property (weak, nonatomic) IBOutlet UIButton *getCodeBtn;//获取验证码

@property (weak, nonatomic) IBOutlet UIView *brandNameView;//品牌名view
@property (weak, nonatomic) IBOutlet UIView *recommendView;//推荐人view
@property (weak, nonatomic) IBOutlet UIView *brandCertificateView;//微商授权书 view

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *recommendViewHeight;//推荐人view 高度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *brandNameViewHeight;//品牌名称view 高度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *brandCertificateViewHeight;//品牌授权书view 高度

@property (nonatomic, strong)NSArray *areaDataArr;

@property (strong, nonatomic)NSString *provinceStrId;
@property (strong, nonatomic)NSString *cityStrId;
@property (strong, nonatomic)NSString *countryStrId;

@property (strong, nonatomic)NSString *provinceStr;
@property (strong, nonatomic)NSString *cityStr;
@property (strong, nonatomic)NSString *countryStr;

@property (nonatomic, strong) ValuePickerView *pickerView;
@property (nonatomic, strong)NSMutableArray *storeTypeModels;//店铺类型模型组
@property (nonatomic, strong)NSMutableArray *brandModels;//品牌模型组

@property (nonatomic, copy)NSString *stroeType_id;//商铺类型id
@property (nonatomic, copy)NSString *brand_id;//品牌id

@property (nonatomic, copy)NSString *brandCertificateUrl;//品牌授权书 url地址
@property (nonatomic, copy)NSString *licenseUrl;//营业执照 url地址
@property (nonatomic, copy)NSString *faceUrl;//法人 正面照url
@property (nonatomic, copy)NSString *oppositeUrl;//法人 反面照url

@property (nonatomic, assign)CGFloat lng;//经度
@property (nonatomic, assign)CGFloat lat;//纬度

@end

@implementation GLMine_Team_OpenSellerController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.hidden = NO;
    
    if(self.pushType == 2){//1:开通商户 2:注册页跳转过来的
        self.navigationItem.title = @"注册商家";
        self.recommendViewHeight.constant = 50;
        self.recommendView.hidden = NO;
    }else{
        self.navigationItem.title = @"开通商家";
        self.recommendViewHeight.constant = 0;
        self.recommendView.hidden = YES;
    }
    
}
#pragma mark - 获取验证码
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
            return ;
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

#pragma mark - 店铺类型选择
- (IBAction)storeTypeChoose:(id)sender {

    [self.view endEditing:YES];
    
    if(self.storeTypeModels.count != 0){
        [self popStoreTypeChooseView:self.storeTypeModels];
        return;
    }
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"app_handler"] = @"SEARCH";
    
    [EasyShowLodingView showLodingText:@"数据请求中"];
    [NetworkManager requestPOSTWithURLStr:kstore_type_list paramDic:dic finish:^(id responseObject) {
        
        [EasyShowLodingView hidenLoding];
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE) {
            
            for (NSDictionary *dic in responseObject[@"data"]) {
                GLMine_stroeTypeModel *model = [GLMine_stroeTypeModel mj_objectWithKeyValues:dic];
                [self.storeTypeModels addObject:model];
            }
            
            [self popStoreTypeChooseView:self.storeTypeModels];
        }else{
            [EasyShowTextView showErrorText:responseObject[@"message"]];
        }
        
    } enError:^(NSError *error) {
        
        [EasyShowLodingView hidenLoding];
        [EasyShowTextView showErrorText:error.localizedDescription];
    }];
}


#pragma mark - 弹出店铺类型
- (void)popStoreTypeChooseView:(NSMutableArray *)models{
    
    NSMutableArray *arrM = [NSMutableArray array];
    for (GLMine_stroeTypeModel *model in models) {
        [arrM addObject:model.typename];
    }
    
    self.pickerView.dataSource = arrM;
    
    self.pickerView.pickerTitle = @"店铺类型";
    __weak typeof(self) weakSelf = self;
    
    self.pickerView.valueDidSelect = ^(NSString *value){
        
        NSArray * stateArr = [value componentsSeparatedByString:@"-"];
        NSInteger index = [stateArr[1] integerValue];
        if (index == 0) {
            index = 1;
        }
        
        GLMine_stroeTypeModel *model = weakSelf.storeTypeModels[index - 1];
        weakSelf.storeTypeTF.text = stateArr[0];
        weakSelf.stroeType_id = model.type_id;

        if ([model.type_id integerValue] == 4) {//1:厂家直销 2:产地直供 3:品牌加盟 4:渠道授权
            
            weakSelf.brandNameViewHeight.constant = 0;
            weakSelf.brandCertificateViewHeight.constant = 50;
            weakSelf.brandNameView.hidden = NO;
            weakSelf.brandCertificateView.hidden = NO;
            
        }else{
            
            weakSelf.brandNameViewHeight.constant = 0;
            weakSelf.brandCertificateViewHeight.constant = 0;
            weakSelf.brandNameView.hidden = YES;
            weakSelf.brandCertificateView.hidden = YES;
        }
    };
    
    [self.pickerView show];
}

#pragma mark - 品牌选择
- (IBAction)brandNameChoose:(id)sender {
    [self.view endEditing:YES];
    
    if(self.brandModels.count != 0){
        [self popBrandChoose:self.brandModels];
        return;
    }
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"app_handler"] = @"SEARCH";
    
    [EasyShowLodingView showLodingText:@"数据请求中"];
    [NetworkManager requestPOSTWithURLStr:kgoods_brand_list paramDic:dic finish:^(id responseObject) {
        
        [EasyShowLodingView hidenLoding];
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE) {
            
            for (NSDictionary *dic in responseObject[@"data"]) {
                GLMine_BrandModel *model = [GLMine_BrandModel mj_objectWithKeyValues:dic];
                [self.brandModels addObject:model];
            }
            
            [self popBrandChoose:self.brandModels];
        }else{
            [EasyShowTextView showErrorText:responseObject[@"message"]];
        }
        
    } enError:^(NSError *error) {
        
        [EasyShowLodingView hidenLoding];
        [EasyShowTextView showErrorText:error.localizedDescription];
    }];
}


- (void)popBrandChoose:(NSMutableArray *)brandModels{
    
    NSMutableArray *arrM = [NSMutableArray array];
    for (GLMine_BrandModel *model in brandModels) {
        [arrM addObject:model.brand_name];
    }
    
    self.pickerView.dataSource = arrM;
    
    self.pickerView.pickerTitle = @"品牌选择";
    __weak typeof(self) weakSelf = self;
    
    self.pickerView.valueDidSelect = ^(NSString *value){
        
        NSArray * stateArr = [value componentsSeparatedByString:@"-"];
        NSInteger index = [stateArr[1] integerValue];
        if (index == 0) {
            index = 1;
        }
        
        GLMine_BrandModel *model = weakSelf.brandModels[index - 1];
        weakSelf.brandTF.text = stateArr[0];
        weakSelf.brand_id = model.brand_id;
    };
    
    [self.pickerView show];
}


#pragma mark - 品牌授权书上传
- (IBAction)brandCertificateUpload:(id)sender {
    
    self.hidesBottomBarWhenPushed = YES;
    GLMine_Team_UploadLicenseController *vc = [[GLMine_Team_UploadLicenseController alloc] init];
    vc.navigationItem.title = @"微商授权书上传";
    vc.firstUrl = self.brandCertificateUrl;
    WeakSelf;
    vc.block = ^(NSString *firstUrl) {
        weakSelf.brandCertificateUrl = firstUrl;
        weakSelf.brandCertificateTF.text = @"已上传";
    };
    
    [self.navigationController pushViewController:vc animated:YES];
    
}


#pragma mark - 上传执照
- (IBAction)uploadLicense:(id)sender {
    
    self.hidesBottomBarWhenPushed = YES;
    GLMine_Team_UploadLicenseController *vc = [[GLMine_Team_UploadLicenseController alloc] init];
    vc.firstUrl = self.licenseUrl;
    WeakSelf;
    vc.block = ^(NSString *firstUrl) {
        weakSelf.licenseUrl = firstUrl;
        weakSelf.licenseTF.text = @"已上传";
    };
    vc.navigationItem.title = @"营业执照上传";
    [self.navigationController pushViewController:vc animated:YES];
    
}

#pragma mark - 法人身份证上传
- (IBAction)UploadLegalCard:(id)sender {

    self.hidesBottomBarWhenPushed = YES;
    LBUploadIdentityPictureViewController *uploadVc =[[LBUploadIdentityPictureViewController alloc]init];
    uploadVc.faceUrl = self.faceUrl;
    uploadVc.oppositeUrl = self.oppositeUrl;
    WeakSelf;
    uploadVc.block = ^(NSString *faceUrl, NSString *oppositeUrl) {
        weakSelf.faceUrl = faceUrl;
        weakSelf.oppositeUrl = oppositeUrl;
        
        if(weakSelf.faceUrl.length != 0 && weakSelf.oppositeUrl.length != 0){
            weakSelf.legalPersonIDTF.text = @"已上传";
        }
    };
    [self.navigationController pushViewController:uploadVc animated:YES];
}

#pragma mark - 地区选择
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


#pragma mark - 地图定位
- (IBAction)mapLocation:(id)sender {
    self.hidesBottomBarWhenPushed = YES;
    WeakSelf;
    LBBaiduMapViewController *vc = [[LBBaiduMapViewController alloc]init];
    vc.returePositon = ^(NSString *strposition, NSString *pro, NSString *city, NSString *area, CLLocationCoordinate2D coors) {
        weakSelf.mapLoacationTF.text = strposition;
        weakSelf.lat = coors.latitude;
        weakSelf.lng = coors.longitude;
    };
    [self.navigationController pushViewController:vc animated:YES];
    
}

#pragma mark - 提交
- (IBAction)submit:(id)sender {

    [self.view endEditing:YES];
    
    if (![predicateModel valiMobile:self.phoneTF.text]) {
        
        [EasyShowTextView showInfoText:@"手机号填写不正确"];
        return;
    }
    if (self.codeTF.text.length == 0) {
        
        [EasyShowTextView showInfoText:@"请填写验证码"];
        return;
    }
    
    if (self.shopNameTF.text.length == 0) {
        
        [EasyShowTextView showInfoText:@"请填写店铺名"];
        return;
    }
    if (self.shopNameTF.text.length == 0) {
        
        [EasyShowTextView showInfoText:@"请填写店铺名"];
        return;
    }
    if(self.stroeType_id.length == 0){
        [EasyShowTextView showInfoText:@"请选择店铺类型"];
        return;
        
    }else if([self.stroeType_id integerValue] == 4){//渠道授权
        
//        if(self.brandTF.text.length == 0){
//            [EasyShowTextView showInfoText:@"请选择品牌名称"];
//            return;
//        }
        
        if(self.brandCertificateUrl.length == 0){
            [EasyShowTextView showInfoText:@"请上传微商授权书"];
            return;
        }
    }
    if(self.licenseUrl.length == 0){
        [EasyShowTextView showInfoText:@"请上传营业执照"];
        return;
    }
    if(self.faceUrl.length == 0 || self.oppositeUrl.length == 0){
        [EasyShowTextView showInfoText:@"请上传法人身份证照片"];
        return;
    }
    
    if(self.provinceStrId.length == 0 || self.cityStrId.length == 0 || self.countryStrId.length == 0 ){
        [EasyShowTextView showInfoText:@"请选择地区"];
        return;
    }
    
    if(self.addressTF.text.length == 0){
        [EasyShowTextView showInfoText:@"请填写详细地址"];
        return;
    }
    
    if(self.lng == 0.0 || self.lat == 0.0){
        [EasyShowTextView showInfoText:@"请定位准确坐标位置"];
        return;
    }
    if(![predicateModel valiMobile:self.contractPhoneTF.text]){
        [EasyShowTextView showInfoText:@"联系号码填写不正确"];
        return;
    }
    if(self.passwordTF.text.length == 0){
        [EasyShowTextView showInfoText:@"请填写账号密码"];
        return;
    }
    if(![self.ensurepwdTF.text isEqualToString:self.passwordTF.text]){
        [EasyShowTextView showInfoText:@"两次密码输入不一致,请检查"];
        return;
    }
    if(!_isAgreeProtocol){
        [EasyShowTextView showInfoText:@"请先同意协议"];
        return;
    }
 
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    dic[@"app_handler"] = @"ADD";
    dic[@"uid"] = [UserModel defaultUser].uid;
    dic[@"token"] = [UserModel defaultUser].token;
    dic[@"user_pre"] = @"+86";//开通手机号码国际编码
    dic[@"append_phone"] = self.phoneTF.text;//开通手机号
    dic[@"yzm"] = self.codeTF.text;
    dic[@"store_name"] = self.shopNameTF.text;
    dic[@"wblicensing"] = self.brandCertificateUrl;
    dic[@"license_pic"] = self.licenseUrl;
    dic[@"con"] = self.oppositeUrl;
    dic[@"face"] = self.faceUrl;
    dic[@"province"] = self.provinceStrId;
    dic[@"city"] = self.cityStrId;
    dic[@"area"] = self.countryStrId;
    dic[@"type_id"] = self.stroeType_id;
    dic[@"brand_id"] = self.brand_id;
    dic[@"address"] = self.addressTF.text;
    dic[@"lng"] = @(self.lng);
    dic[@"lat"] = @(self.lat);
    dic[@"store_pre"] = @"+86";
    dic[@"store_phone"] = self.contractPhoneTF.text;
    dic[@"password"] = self.passwordTF.text;
    dic[@"confirmpass"] = self.ensurepwdTF.text;
    
    if (self.pushType == 1) {//1是创客开通商铺 2是注册商铺
        dic[@"type"] = @"1";//1是创客开通商铺 2是注册商铺
    }else{
        dic[@"type"] = @"2";
        dic[@"accounts"] = self.recommendIDTF.text;  //type等于2传注册商铺时填写的推荐人账户
    }
   
    [EasyShowLodingView showLodingText:@"数据请求中"];
    [NetworkManager requestPOSTWithURLStr:kappend_shop paramDic:dic finish:^(id responseObject) {
        
        [EasyShowLodingView hidenLoding];
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE) {
            
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

#pragma mark - 是否同意商家承诺书
- (IBAction)isAgreeProtocol:(id)sender {
    _isAgreeProtocol = !_isAgreeProtocol;
    if (_isAgreeProtocol) {
        self.signImageV.image = [UIImage imageNamed:@"greetselect-y"];
    }else{
        self.signImageV.image = [UIImage imageNamed:@"greetselect-n"];
    }
}

#pragma mark - 跳转到商家承诺书
- (IBAction)sellerPromise:(id)sender {

}

#pragma mark - UITextfieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if (textField == self.phoneTF) {
        [self.codeTF becomeFirstResponder];
        
    }else if (textField == self.codeTF) {
        [self.recommendIDTF becomeFirstResponder];
        
    }else if (textField == self.recommendIDTF) {
        [self.shopNameTF becomeFirstResponder];
        
    }else if (textField == self.shopNameTF) {
        
        [self.addressTF becomeFirstResponder];
        
    }else if (textField == self.addressTF) {
        [self.contractPhoneTF becomeFirstResponder];
        
    }else if (textField == self.contractPhoneTF) {
        [self.passwordTF becomeFirstResponder];
        
    }else if (textField == self.passwordTF) {
        [self.ensurepwdTF becomeFirstResponder];
        
    }else if (textField == self.ensurepwdTF) {
        [self.view endEditing:YES];
        
    }
    
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if (range.length == 1 && string.length == 0) {
        
        return YES;
        
    }
    
    if (textField == self.phoneTF || textField == self.codeTF || textField == self.contractPhoneTF) {
        
        if (![predicateModel inputShouldNumber:string]) {
            [self.view endEditing:YES];
            [EasyShowTextView showInfoText:@"此处只能输入数字"];
            
            return NO;
        }
    }

    if(textField == self.shopNameTF || textField == self.passwordTF || textField == self.addressTF){
        
        NSString *tem = [[string componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] componentsJoinedByString:@""];
        if (![string isEqualToString:tem]) {
            [EasyShowTextView showInfoText:@"店铺名不能含有空格"];
            return NO;
        }
    }

    return YES;
}

- (ValuePickerView *)pickerView{
    if (!_pickerView) {
        _pickerView = [[ValuePickerView alloc] init];
    }
    return _pickerView;
}

- (NSMutableArray *)storeTypeModels{
    if (!_storeTypeModels) {
        _storeTypeModels = [NSMutableArray array];
    }
    return _storeTypeModels;
}
- (NSMutableArray *)brandModels{
    if (!_brandModels) {
        _brandModels = [NSMutableArray array];
    }
    return _brandModels;
}

@end
