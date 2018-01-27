//
//  GLMine_BankManageController.m
//  excellentPurchase
//
//  Created by 龚磊 on 2018/1/27.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "GLMine_BankManageController.h"

@interface GLMine_BankManageController ()

@property (weak, nonatomic) IBOutlet UISwitch *switchV;

@end

@implementation GLMine_BankManageController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"银行卡管理";
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
    
    
}


@end
