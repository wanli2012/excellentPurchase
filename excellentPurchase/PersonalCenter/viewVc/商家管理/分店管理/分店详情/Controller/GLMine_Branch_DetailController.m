//
//  GLMine_Branch_DetailController.m
//  excellentPurchase
//
//  Created by 龚磊 on 2018/1/24.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "GLMine_Branch_DetailController.h"
#import "GLMine_Branch_AccountManageController.h"//账号管理
#import "GLMine_Branch_QueryAchievementController.h"//业绩查询

@interface GLMine_Branch_DetailController ()

@end

@implementation GLMine_Branch_DetailController

- (void)viewDidLoad {
    [super viewDidLoad];
   
}

/**
 账号管理
 */
- (IBAction)accountManage:(id)sender {
    
    self.hidesBottomBarWhenPushed = YES;
    GLMine_Branch_AccountManageController *manageVC = [[GLMine_Branch_AccountManageController alloc] init];
    [self.navigationController pushViewController:manageVC animated:YES];
    
}

/**
 分店详情
 */
- (IBAction)branchDetail:(id)sender {
    NSLog(@"分店详情");
}

/**
 历史记录
 */
- (IBAction)historyAchievement:(id)sender {
    self.hidesBottomBarWhenPushed = YES;
    GLMine_Branch_QueryAchievementController *VC= [[GLMine_Branch_QueryAchievementController alloc] init];
    [self.navigationController pushViewController:VC animated:YES];
}

/**
 冻结账号
 */
- (IBAction)frezzAccount:(id)sender {
    NSLog(@"冻结账号");
}


@end
