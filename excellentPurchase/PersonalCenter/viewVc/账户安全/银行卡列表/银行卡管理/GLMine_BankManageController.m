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
    
    if ([self.is_default integerValue] == 1) {//银行卡是否默认 1:是 2:否
        [self.switchV setOn:YES];
    }else{
        [self.switchV setOn:NO];
    }
}

//设置默认
- (IBAction)setDefault:(UISwitch *)sender {

    [self setDefaultCard:sender.isOn];
}

//设置默认银行卡 取消默认
- (void)setDefaultCard:(BOOL)isSetDefault{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"app_handler"] = @"UPDATE";
    dic[@"bank_id"] = self.bank_id;
    dic[@"uid"] = [UserModel defaultUser].uid;
    dic[@"token"] = [UserModel defaultUser].token;
    
    if (self.switchV.isOn) {//是否默认状态 1:是 2:否
        dic[@"is_default"] = @"1";
    }else{
        dic[@"is_default"] = @"2";
    }
    
    [NetworkManager requestPOSTWithURLStr:kSetDefaultCard_URL paramDic:dic finish:^(id responseObject) {

        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE) {

            if (self.switchV.isOn) {
                [EasyShowTextView showSuccessText:@"设置默认成功"];
            }else{
                [EasyShowTextView showSuccessText:@"取消默认成功"];
            }
            
            if (self.block) {
                self.block(YES);
            }
            
        }else{
            [self.switchV setOn:!self.switchV.isOn];
            
            [EasyShowTextView showErrorText:responseObject[@"message"]];
        }
        
    } enError:^(NSError *error) {
        
        [self.switchV setOn:!self.switchV.isOn];
        [EasyShowTextView showErrorText:error.localizedDescription];
    }];
}

//解除绑定
- (IBAction)unbindBtn:(id)sender {
    
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
    
    [EasyShowLodingView showLodingText:@"请求中..."];
    
    [NetworkManager requestPOSTWithURLStr:kUnbind_Bank_URL paramDic:dic finish:^(id responseObject) {
        [EasyShowLodingView hidenLoding];
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
        [EasyShowLodingView hidenLoding];
        [EasyShowTextView showErrorText:error.localizedDescription];
    }];
}

@end
