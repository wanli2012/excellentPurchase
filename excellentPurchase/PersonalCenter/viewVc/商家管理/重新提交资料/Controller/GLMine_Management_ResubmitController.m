//
//  GLMine_Management_ResubmitController.m
//  excellentPurchase
//
//  Created by 龚磊 on 2018/3/2.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "GLMine_Management_ResubmitController.h"

#import "GLMine_Team_UploadLicenseController.h"//单张图片上传
#import "LBUploadIdentityPictureViewController.h"//身份证正反面上传
#import "LBBaiduMapViewController.h"
//单项Picker
#import "ValuePickerView.h"
///地址选择
#import "CZHAddressPickerView.h"
#import "AddressPickerHeader.h"
#import "GLMine_stroeTypeModel.h"//店铺类型模型

@interface GLMine_Management_ResubmitController ()<UITextFieldDelegate>
{
    BOOL _isAgreeProtocol;
}

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UITextField *shopNameTF;//店铺名
@property (weak, nonatomic) IBOutlet UITextField *storeTypeTF;//店铺类型
@property (weak, nonatomic) IBOutlet UITextField *brandCertificateTF;//微商授权书
@property (weak, nonatomic) IBOutlet UITextField *licenseTF;//营业执照
@property (weak, nonatomic) IBOutlet UITextField *legalPersonIDTF;//法人身份证
@property (weak, nonatomic) IBOutlet UITextField *areaTF;//地区

@property (weak, nonatomic) IBOutlet UITextField *addressTF;//详细地址
@property (weak, nonatomic) IBOutlet UITextField *mapLoacationTF;//地图定位
@property (weak, nonatomic) IBOutlet UITextField *contractPhoneTF;//联系号码

@property (weak, nonatomic) IBOutlet UIImageView *signImageV;//选中标志
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;//提交

@property (weak, nonatomic) IBOutlet UIView *brandCertificateView;//微商授权书 view

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *brandCertificateViewHeight;//品牌授权书view 高度
@property (weak, nonatomic) IBOutlet UIView *benefitView;//收益人view
@property (weak, nonatomic) IBOutlet UITextField *benefitTF;//收益人TF
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *benefitViewHeight;//收益人高度

@property (nonatomic, strong)NSArray *areaDataArr;

@property (strong, nonatomic)NSString *provinceStrId;
@property (strong, nonatomic)NSString *cityStrId;
@property (strong, nonatomic)NSString *countryStrId;

@property (strong, nonatomic)NSString *provinceStr;
@property (strong, nonatomic)NSString *cityStr;
@property (strong, nonatomic)NSString *countryStr;

@property (nonatomic, strong)ValuePickerView *pickerView;
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

@implementation GLMine_Management_ResubmitController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"重新提交资料";
    [self postRequest];
}

- (void)postRequest {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"app_handler"] = @"SEARCH";
    dict[@"uid"] = [UserModel defaultUser].uid;
    dict[@"token"] = [UserModel defaultUser].token;
    
    [EasyShowLodingView showLoding];
    [NetworkManager requestPOSTWithURLStr:kshop_reiterate_find paramDic:dict finish:^(id responseObject) {
        
        [EasyShowLodingView hidenLoding];
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE) {
            
            self.shopNameTF.text = [self judgeStringIsNull:responseObject[@"data"][@"sname"] andDefault:NO];
            self.storeTypeTF.text = [self judgeStringIsNull:responseObject[@"data"][@"typename"] andDefault:NO];
            if ([responseObject[@"data"][@"areaname"] length] == 0) {
                self.areaTF.text = [NSString stringWithFormat:@"%@%@",responseObject[@"data"][@"provincename"],responseObject[@"data"][@"cityname"]];
            }else{
                self.areaTF.text = [NSString stringWithFormat:@"%@%@%@",responseObject[@"data"][@"provincename"],responseObject[@"data"][@"cityname"],responseObject[@"data"][@"areaname"]];
            }
            
            self.addressTF.text = [self judgeStringIsNull:responseObject[@"data"][@"address"] andDefault:NO];
            self.contractPhoneTF.text = [self judgeStringIsNull:responseObject[@"data"][@"store_phone"] andDefault:NO];
            self.mapLoacationTF.text = [NSString stringWithFormat:@"%@,%@",responseObject[@"data"][@"lng"],responseObject[@"data"][@"lat"]];
            
            self.provinceStrId = [self judgeStringIsNull:responseObject[@"data"][@"province"] andDefault:NO];
            self.cityStrId = [self judgeStringIsNull:responseObject[@"data"][@"city"] andDefault:NO];
            self.countryStrId = [self judgeStringIsNull:responseObject[@"data"][@"area"] andDefault:NO];
            self.stroeType_id = [self judgeStringIsNull:responseObject[@"data"][@"type_id"] andDefault:NO];
            
            self.licenseUrl = [self judgeStringIsNull:responseObject[@"data"][@"license_pic"] andDefault:NO];
            self.oppositeUrl = [self judgeStringIsNull:responseObject[@"data"][@"card"][@"con"] andDefault:NO];
            self.faceUrl = [self judgeStringIsNull:responseObject[@"data"][@"card"][@"face"] andDefault:NO];
            
            self.sid = responseObject[@"data"][@"sid"];
            
            if (self.licenseUrl.length != 0) {
                self.licenseTF.text = @"已上传";
            }
            
            if(self.oppositeUrl.length != 0 && self.faceUrl.length != 0){
                self.legalPersonIDTF.text = @"已上传";
            }
            
        }else{
            
            [EasyShowTextView showErrorText:responseObject[@"message"]];
        }
        
    } enError:^(NSError *error) {
        
        [EasyShowLodingView hidenLoding];
        [EasyShowTextView showErrorText:error.localizedDescription];
    }];
}

//判空 给数字设置默认值
- (NSString *)judgeStringIsNull:(id )sender andDefault:(BOOL)isNeedDefault{
    
    NSString *str = [NSString stringWithFormat:@"%@",sender];
    
    if ([NSString StringIsNullOrEmpty:str]) {
        
        if (isNeedDefault) {
            return @"0.00";
        }else{
            return @"";
        }
    }else{
        return str;
    }
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
            
            weakSelf.brandCertificateViewHeight.constant = 50;
            weakSelf.brandCertificateView.hidden = NO;
            
        }else{
            
            weakSelf.brandCertificateViewHeight.constant = 0;
            weakSelf.brandCertificateView.hidden = YES;
        }
    };
    
    [self.pickerView show];
}

#pragma mark - 营业执照上传
- (IBAction)licenseUpload:(id)sender {

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
- (IBAction)IDUpload:(id)sender {
    
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


#pragma mark - 授权书上传
- (IBAction)CertificateUpload:(id)sender {

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
#pragma mark - 地图定位
- (IBAction)mapLocation:(id)sender {
    self.hidesBottomBarWhenPushed = YES;
    WeakSelf;
    LBBaiduMapViewController *vc = [[LBBaiduMapViewController alloc]init];
    vc.returePositon = ^(NSString *strposition, NSString *pro, NSString *city, NSString *area, CLLocationCoordinate2D coors) {
        
        if (![NSString StringIsNullOrEmpty:strposition]) {
            
            weakSelf.mapLoacationTF.text = strposition;
            weakSelf.lat = coors.latitude;
            weakSelf.lng = coors.longitude;
        }
    };
    
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 是否同意服务条款
- (IBAction)isAgreeProtocol:(id)sender {
    _isAgreeProtocol = !_isAgreeProtocol;
    if (_isAgreeProtocol) {
        self.signImageV.image = [UIImage imageNamed:@"greetselect-y"];
    }else{
        self.signImageV.image = [UIImage imageNamed:@"greetselect-n"];
    }
}

#pragma mark - 提交
- (IBAction)submit:(id)sender {
    
    [self.view endEditing:YES];

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

    if(!_isAgreeProtocol){
        [EasyShowTextView showInfoText:@"请先同意协议"];
        return;
    }
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    dic[@"app_handler"] = @"UPDATE";
    dic[@"uid"] = [UserModel defaultUser].uid;
    dic[@"token"] = [UserModel defaultUser].token;
    dic[@"sid"] = self.sid;
    dic[@"type"] = @"4";//重申商铺 传4
    dic[@"store_name"] = self.shopNameTF.text;
    dic[@"wblicensing"] = self.brandCertificateUrl;
    dic[@"license_pic"] = self.licenseUrl;
    dic[@"con"] = self.oppositeUrl;
    dic[@"face"] = self.faceUrl;
    dic[@"province"] = self.provinceStrId;
    dic[@"city"] = self.cityStrId;
    dic[@"area"] = self.countryStrId;
    dic[@"type_id"] = self.stroeType_id;
    dic[@"address"] = self.addressTF.text;
    dic[@"lng"] = @(self.lng);
    dic[@"lat"] = @(self.lat);
    dic[@"store_pre"] = @"+86";
    dic[@"store_phone"] = self.contractPhoneTF.text;

    [EasyShowLodingView showLodingText:@"数据请求中"];
    [NetworkManager requestPOSTWithURLStr:kshop_reiterate_save paramDic:dic finish:^(id responseObject) {
        
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

#pragma mark - 懒加载
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
