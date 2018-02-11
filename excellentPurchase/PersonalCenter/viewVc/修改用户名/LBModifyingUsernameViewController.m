//
//  LBModifyingUsernameViewController.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/1/10.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "LBModifyingUsernameViewController.h"

@interface LBModifyingUsernameViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topContrait;
@property (weak, nonatomic) IBOutlet UITextField *nameTF;

@end

@implementation LBModifyingUsernameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self.nameTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    [self setNav];
}

/**导航栏设置*/
- (void)setNav{
    
    self.topContrait.constant = SafeAreaTopHeight;
    self.navigationItem.title = @"修改用户名";
    
    UIButton *button=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 80, 44)];
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;//右对齐
    
    [button setTitle:@"保存" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont systemFontOfSize:13]];
    button.backgroundColor = [UIColor clearColor];
    [button addTarget:self action:@selector(save) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
}

/**
 保存
 */
- (void)save{
    [self.view endEditing:YES];
    
    if(self.nameTF.text.length == 0){
        [EasyShowTextView showInfoText:@"请输入你的新昵称"];
        return;
    }
    if (self.nameTF.text.length > 8) {
        
        [EasyShowTextView showInfoText:@"用户名请不要超过8个字"];
        return;
    }
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"app_handler"] = @"UPDATE";
    dic[@"uid"] = [UserModel defaultUser].uid;
    dic[@"token"] = [UserModel defaultUser].token;
    dic[@"nick_name"] = self.nameTF.text;
    
    [EasyShowLodingView showLoding];

    [NetworkManager requestPOSTWithURLStr:kperfect_get_info paramDic:dic finish:^(id responseObject) {
        
        [EasyShowLodingView hidenLoding];
        
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE) {
          
            self.block(self.nameTF.text);
            
            [EasyShowTextView showSuccessText:@"修改成功"];
            [self.navigationController popViewControllerAnimated:YES];
            
        }else{
            [EasyShowTextView showErrorText:responseObject[@"message"]];
        }
        
    } enError:^(NSError *error) {
        [EasyShowLodingView hidenLoding];
        [EasyShowTextView showErrorText:error.localizedDescription];
    }];

}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}


#pragma mark - UITextfieldDelegate

//- (void)textFieldDidChange:(UITextField *)textField
//{
//    if (textField == self.nameTF) {
//        if (textField.text.length > 8) {
//            [self.view endEditing:YES];
//            [EasyShowTextView showInfoText:@"用户名请不要超过8个字"];
//            textField.text = [textField.text substringToIndex:8];
//        }
//    }
//}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [self.view endEditing:YES];
    
    return YES;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if (range.length == 1 && string.length == 0) {
        
        return YES;
    }
    
    if (textField.text.length > 8) {
        [self.view endEditing:YES];
        [EasyShowTextView showInfoText:@"用户名请不要超过8个字"];
        textField.text = [textField.text substringToIndex:8];
    }
    
    return YES;
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    
    if (textField.text.length > 8) {
        
        textField.text = [textField.text substringToIndex:8];
    }
    return YES;
}

@end
