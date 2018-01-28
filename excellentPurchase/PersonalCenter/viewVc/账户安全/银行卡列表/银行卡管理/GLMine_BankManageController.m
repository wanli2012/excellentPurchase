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
    
//    HCBottomPopupViewController * pc =  [[HCBottomPopupViewController alloc]init];
//    __weak typeof(self) wself = self;
//    HCBottomPopupAction * action1 = [HCBottomPopupAction actionWithTitle:@"拍照" withSelectedBlock:^{
//        [wself.presentedViewController dismissViewControllerAnimated:NO completion:nil];
//        [wself getcamera];
//    } withType:HCBottomPopupActionSelectItemTypeDefault];
//
//    HCBottomPopupAction * action2 = [HCBottomPopupAction actionWithTitle:@"从手机相册选择" withSelectedBlock:^{
//        [wself.presentedViewController dismissViewControllerAnimated:NO completion:nil];
//        [wself photoSelectet:self.assets1 collectionview:self.collectionview1];
//    } withType:HCBottomPopupActionSelectItemTypeDefault];
//
//    HCBottomPopupAction * action3 = [HCBottomPopupAction actionWithTitle:@"保存图片" withSelectedBlock:nil withType:HCBottomPopupActionSelectItemTypeDefault];
//
//    HCBottomPopupAction * action4 = [HCBottomPopupAction actionWithTitle:@"取消" withSelectedBlock:nil withType:HCBottomPopupActionSelectItemTypeCancel];
//
//    [pc addAction:action1];
//    [pc addAction:action2];
//    [pc addAction:action3];
//    [pc addAction:action4];
//
//    [self presentViewController:pc animated:YES completion:nil];
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
