//
//  GLMine_Team_MonthAchieveManageController.m
//  excellentPurchase
//
//  Created by 龚磊 on 2018/1/18.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "GLMine_Team_MonthAchieveManageController.h"
#import "GLIdentifySelectController.h"

@interface GLMine_Team_MonthAchieveManageController ()

@property (weak, nonatomic) IBOutlet UILabel *IDLabel;//身份
@property (weak, nonatomic) IBOutlet UILabel *accountLabel;//账号
@property (weak, nonatomic) IBOutlet UITextField *achieveMoneyTF;//绩效金额

@property (nonatomic, copy)NSString *group_id;

@end

@implementation GLMine_Team_MonthAchieveManageController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.navigationItem.title = @"当月绩效设置";
    
}

#pragma mark - 提交
- (IBAction)submit:(id)sender {
    NSLog(@"提交");
}
#pragma mark - 身份选择
- (IBAction)IdentityChoose:(id)sender {
    
    self.hidesBottomBarWhenPushed = YES;
    GLIdentifySelectController *idVC = [[GLIdentifySelectController alloc] init];
    
    idVC.selectIndex = [self.group_id integerValue];
    __weak typeof(self) weakSelf = self;
    idVC.block = ^(NSString *name, NSString *group_id) {
        weakSelf.IDLabel.text = name;
        weakSelf.group_id = group_id;
    };
    
    [self.navigationController pushViewController:idVC animated:YES];
}

#pragma mark - 账号选择
- (IBAction)accountChoose:(id)sender {
    NSLog(@"账号选择");
}

@end
