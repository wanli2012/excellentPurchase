//
//  GLMine_Team_OpenMakerController.m
//  excellentPurchase
//
//  Created by 龚磊 on 2018/1/19.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "GLMine_Team_OpenMakerController.h"
#import "GLIdentifySelectController.h"
#import "GLMine_Team_StaffingController.h"//人员配置

///地址选择
#import "CZHAddressPickerView.h"
#import "AddressPickerHeader.h"

@interface GLMine_Team_OpenMakerController ()<UITextFieldDelegate>
{
    BOOL _isAgreeProtocol;
}

@property (weak, nonatomic) IBOutlet UITextField *phoneTF;//手机号
@property (weak, nonatomic) IBOutlet UILabel *IDTypeLabel;//身份类型
@property (weak, nonatomic) IBOutlet UILabel *areaLabel;//地区
@property (weak, nonatomic) IBOutlet UITextField *passWordTF;//密码
@property (weak, nonatomic) IBOutlet UITextField *ensurePwdTF;//确认密码

@property (weak, nonatomic) IBOutlet UIImageView *signImageV;
@property (nonatomic, copy)NSString *group_id;

@end

@implementation GLMine_Team_OpenMakerController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.navigationItem.title = @"开通创客";
    
}
/**
人员配备
 */
- (IBAction)staffing:(id)sender {
    
    self.hidesBottomBarWhenPushed = YES;
    GLMine_Team_StaffingController *VC= [[GLMine_Team_StaffingController alloc] init];
    [self.navigationController pushViewController:VC animated:YES];
}

/**
 身份类型选择
 */
- (IBAction)group_typeChoose:(id)sender {
    self.hidesBottomBarWhenPushed = YES;
    GLIdentifySelectController *vc = [[GLIdentifySelectController alloc] init];
    
     __block typeof(self) weakSelf = self;
    vc.block = ^(NSString *name, NSString *group_id) {
        weakSelf.IDTypeLabel.text = name;
        weakSelf.group_id = group_id;
    };
    
    [self.navigationController pushViewController:vc animated:YES];
}

/**
 地区选择
 */
- (IBAction)areaChoose:(id)sender {

    [CZHAddressPickerView areaPickerViewWithAreaBlock:^(NSString *province, NSString *city, NSString *area) {
        
        self.areaLabel.text = [NSString stringWithFormat:@"%@%@%@",province,city,area];
    }];
}

/**
 创客承诺书
 */
- (IBAction)makerPromise:(id)sender {
    NSLog(@"创客承诺书");
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

/**
 提交
 */
- (IBAction)submit:(id)sender {
    NSLog(@" 提交");
    
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == self.phoneTF) {
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




@end
