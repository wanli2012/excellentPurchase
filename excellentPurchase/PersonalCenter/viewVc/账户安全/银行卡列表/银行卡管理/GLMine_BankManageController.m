//
//  GLMine_BankManageController.m
//  excellentPurchase
//
//  Created by 龚磊 on 2018/1/27.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "GLMine_BankManageController.h"

#import "HCBasePopupViewController.h"
#import "HCBottomPopupViewController.h"

@interface GLMine_BankManageController ()

@property (weak, nonatomic) IBOutlet UISwitch *switchV;
@property (weak, nonatomic) IBOutlet UILabel *endNumLabel;

@end

@implementation GLMine_BankManageController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"银行卡管理";
    
    self.endNumLabel.text = [NSString stringWithFormat:@"银行卡尾号:%@",self.endNum];
    
    [self.switchV setOn:NO];
    
}

//设置默认
- (IBAction)setDefault:(UISwitch *)sender {
    
    if (sender.isOn) {
        NSLog(@"设为默认");
    }else{
        NSLog(@"取消默认");
    }
}

//解除绑定
- (IBAction)unbindBtn:(id)sender {
    NSLog(@"解除绑定");
    
    HCBottomPopupViewController * pc =  [[HCBottomPopupViewController alloc]init];
    
    __weak typeof(self) wself = self;
    HCBottomPopupAction * action1 = [HCBottomPopupAction actionWithTitle:@"解除绑定后银行服务将不可使用" withSelectedBlock:nil withType:HCBottomPopupActionSelectItemTypeDefault];

    HCBottomPopupAction * action2 = [HCBottomPopupAction actionWithTitle:@"确定解除绑定" withSelectedBlock:^{

        ///确定之后  解绑银行卡
        [wself unbindBankCard];
        [wself dismissViewControllerAnimated:YES completion:nil];
        
    } withType:HCBottomPopupActionSelectItemTypeDefault];

    HCBottomPopupAction * action4 = [HCBottomPopupAction actionWithTitle:@"取消" withSelectedBlock:nil withType:HCBottomPopupActionSelectItemTypeCancel];

    [pc addAction:action1];
    [pc addAction:action2];
    [pc addAction:action4];

    [self presentViewController:pc animated:YES completion:nil];
}

//确定解绑银行卡
- (void)unbindBankCard{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"app_handler"] = @"UPDATE";
    dic[@"bank_id"] = self.bank_id;
    dic[@"uid"] = [UserModel defaultUser].uid;
    dic[@"token"] = [UserModel defaultUser].token;
    
    [NetworkManager requestPOSTWithURLStr:kUnbind_Bank_URL paramDic:dic finish:^(id responseObject) {
        
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE) {
            
            [EasyShowTextView showSuccessText:@"解除绑定成功"];
            
            if (self.block) {
                self.block(YES);
            }
            
            [self.navigationController popViewControllerAnimated:YES];
           
        }else{
            [EasyShowTextView showErrorText:responseObject[@"message"]];
        }
    } enError:^(NSError *error) {
        [EasyShowTextView showErrorText:error.localizedDescription];
    }];
}

@end
