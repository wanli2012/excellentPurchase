//
//  GLMine_Branch_OpenStoreController.m
//  excellentPurchase
//
//  Created by 龚磊 on 2018/1/24.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "GLMine_Branch_OpenStoreController.h"

@interface GLMine_Branch_OpenStoreController ()

@property (weak, nonatomic) IBOutlet UITextField *phoneTF;//手机号
@property (weak, nonatomic) IBOutlet UITextField *shopNameTF;//店铺名
@property (weak, nonatomic) IBOutlet UITextField *profitAccountTF;//收益账号
@property (weak, nonatomic) IBOutlet UITextField *addressTF;//详细地址
@property (weak, nonatomic) IBOutlet UITextField *contractPhoneTF;//联系号码
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;//密码
@property (weak, nonatomic) IBOutlet UITextField *ensurepwdTF;//确认密码

@property (weak, nonatomic) IBOutlet UILabel *storeTypeLabel;//店铺类型
@property (weak, nonatomic) IBOutlet UILabel *licenseLabel;//执照
@property (weak, nonatomic) IBOutlet UILabel *areaLabel;//地址
@property (weak, nonatomic) IBOutlet UILabel *mapLocationLabel;//地图定位

@property (weak, nonatomic) IBOutlet UIImageView *signImageV;//选中标志


@end

@implementation GLMine_Branch_OpenStoreController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"开通分店";
    
    [self.phoneTF setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
    [self.phoneTF setValue:[UIFont systemFontOfSize:15] forKeyPath:@"_placeholderLabel.font"];
    
    [self.shopNameTF setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
    [self.shopNameTF setValue:[UIFont systemFontOfSize:15] forKeyPath:@"_placeholderLabel.font"];
    
    [self.profitAccountTF setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
    [self.profitAccountTF setValue:[UIFont systemFontOfSize:15] forKeyPath:@"_placeholderLabel.font"];
    
    [self.addressTF setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
    [self.addressTF setValue:[UIFont systemFontOfSize:15] forKeyPath:@"_placeholderLabel.font"];
    
    [self.contractPhoneTF setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
    [self.contractPhoneTF setValue:[UIFont systemFontOfSize:15] forKeyPath:@"_placeholderLabel.font"];
    
    [self.passwordTF setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
    [self.passwordTF setValue:[UIFont systemFontOfSize:15] forKeyPath:@"_placeholderLabel.font"];
    
    [self.ensurepwdTF setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
    [self.ensurepwdTF setValue:[UIFont systemFontOfSize:15] forKeyPath:@"_placeholderLabel.font"];
}


/**
 同意承诺书
 */
- (IBAction)isAgreePromise:(id)sender {
    NSLog(@" 同意承诺书");
}

/**
地图定位
 */
- (IBAction)mapLocation:(id)sender {
    NSLog(@" 地图定位");
}
/**
 地区选择
 */
- (IBAction)areaChoose:(id)sender {
    NSLog(@" 地区选择");
}
/**
 上传执照
 */
- (IBAction)uploadLicense:(id)sender {
    NSLog(@" 上传执照");
}
/**
 店铺类型选择
 */
- (IBAction)storeTypeChoose:(id)sender {
    NSLog(@" 店铺类型选择");
}

/**
 跳转到承诺书界面
 */
- (IBAction)sellerPromise:(id)sender {
    NSLog(@" 跳转到承诺书界面");
}

#pragma mark - UITextfieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if (textField == self.phoneTF) {
        [self.shopNameTF becomeFirstResponder];
    }else if (textField == self.shopNameTF) {
        [self.profitAccountTF becomeFirstResponder];
    }else if (textField == self.profitAccountTF) {
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
