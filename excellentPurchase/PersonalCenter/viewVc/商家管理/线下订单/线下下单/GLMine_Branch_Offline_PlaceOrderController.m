//
//  GLMine_Branch_Offline_PlaceOrderController.m
//  excellentPurchase
//
//  Created by 龚磊 on 2018/1/25.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "GLMine_Branch_Offline_PlaceOrderController.h"

@interface GLMine_Branch_Offline_PlaceOrderController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *IDNumberTF;//ID号
@property (weak, nonatomic) IBOutlet UITextField *consumeTF;//消费金额
@property (weak, nonatomic) IBOutlet UITextField *noProfitTF;//让利金额
@property (weak, nonatomic) IBOutlet UILabel *proofLabel;//凭证显示label
@property (weak, nonatomic) IBOutlet UILabel *checkCodeLabel;//校验码
@property (weak, nonatomic) IBOutlet UIButton *buildBtn;//生成按钮
@property (weak, nonatomic) IBOutlet UIImageView *signImageV;//协议同意标志

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewHeight;

@end

@implementation GLMine_Branch_Offline_PlaceOrderController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"线下下单";
    
    self.contentViewHeight.constant = UIScreenHeight - SafeAreaTopHeight;
}

/**
 重新生成
 */
- (IBAction)rebuild:(id)sender {
    NSLog(@"重新生成");
}
/**
 上传打卡款凭证
 */
- (IBAction)uploadProof:(id)sender {
    NSLog(@"上传打卡款凭证");
}
/**
 是否同意协议
 */
- (IBAction)isAgreeProtocol:(id)sender {
    NSLog(@"是否同意协议");
}
/*
 商家协议
*/
- (IBAction)sellerProtocol:(id)sender {
    NSLog(@"商家协议");
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if (textField == self.IDNumberTF) {
        [self.consumeTF becomeFirstResponder];
    }else if(textField == self.consumeTF){
        [self.noProfitTF becomeFirstResponder];
    }else{
        [self.view endEditing:YES];
    }
    
    return YES;
}


@end
