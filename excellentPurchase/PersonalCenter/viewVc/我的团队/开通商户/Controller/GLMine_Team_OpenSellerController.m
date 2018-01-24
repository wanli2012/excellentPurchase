//
//  GLMine_Team_OpenSellerController.m
//  excellentPurchase
//
//  Created by 龚磊 on 2018/1/19.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "GLMine_Team_OpenSellerController.h"
#import "GLMine_Team_UploadLicenseController.h"

///地址选择
#import "CZHAddressPickerView.h"
#import "AddressPickerHeader.h"

@interface GLMine_Team_OpenSellerController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *phoneTF;//手机号
@property (weak, nonatomic) IBOutlet UITextField *shopNameTF;//店铺名
@property (weak, nonatomic) IBOutlet UITextField *addressTF;//详细地址
@property (weak, nonatomic) IBOutlet UITextField *contractPhoneTF;//联系号码
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;//密码
@property (weak, nonatomic) IBOutlet UITextField *ensurepwdTF;//确认密码

@property (weak, nonatomic) IBOutlet UITextField *mapLoacationTF;//地图定位
@property (weak, nonatomic) IBOutlet UILabel *areaLabel;//地址
@property (weak, nonatomic) IBOutlet UILabel *licenseLabel;//执照

@property (weak, nonatomic) IBOutlet UIImageView *signImageV;//选中标志

@end

@implementation GLMine_Team_OpenSellerController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.navigationItem.title = @"开通商家";
    
}

#pragma mark - 跳转到商家承诺书
- (IBAction)sellerPromise:(id)sender {
    NSLog(@"跳转到商家承诺书");
}
#pragma mark - 上传执照
- (IBAction)uploadLicense:(id)sender {

    self.hidesBottomBarWhenPushed = YES;
    GLMine_Team_UploadLicenseController *vc = [[GLMine_Team_UploadLicenseController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    
}
#pragma mark - 地区选择
- (IBAction)areaChoose:(id)sender {
    [CZHAddressPickerView areaPickerViewWithAreaBlock:^(NSString *province, NSString *city, NSString *area) {
        
        self.areaLabel.text = [NSString stringWithFormat:@"%@%@%@",province,city,area];
    }];
}

#pragma mark - 地图定位
- (IBAction)mapLocation:(id)sender {
    NSLog(@"地图定位");
}

#pragma mark - 提交
- (IBAction)submit:(id)sender {
    NSLog(@"提交");
    
}

#pragma mark - UITextfieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if (textField == self.phoneTF) {
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
    
    
    return YES;
}

@end
