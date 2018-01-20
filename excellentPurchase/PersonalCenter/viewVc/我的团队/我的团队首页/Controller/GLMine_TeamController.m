//
//  GLMine_TeamController.m
//  excellentPurchase
//
//  Created by 龚磊 on 2018/1/17.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "GLMine_TeamController.h"
#import "GLMine_Team_TeamAchievementController.h"//团队业绩
#import "GLMine_Team_AchievementManageController.h"//绩效管理
#import "GLMine_Team_OpenMakerController.h"//开通创客
#import "GLMine_Team_MembersController.h"//团队成员
#import "GLMine_Team_OpenSellerController.h"//开通商家

@interface GLMine_TeamController ()

@property (weak, nonatomic) IBOutlet UIImageView *picImageV;//头像
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;//名字
@property (weak, nonatomic) IBOutlet UILabel *IDLabel;//ID
@property (weak, nonatomic) IBOutlet UILabel *monthConsumeLabel;//本月消费
@property (weak, nonatomic) IBOutlet UILabel *recommendUserConsumeLabel;//推荐用户消费
@property (weak, nonatomic) IBOutlet UILabel *subordinatesConsumeLabel;//下属创客业绩
@property (weak, nonatomic) IBOutlet UILabel *getRewardLabel;//获得奖励

@end

@implementation GLMine_TeamController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"我的团队";
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.picImageV.layer.cornerRadius = self.picImageV.height / 2;
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

#pragma mark - 团队业绩
- (IBAction)teamAchievement:(id)sender {
    
    self.hidesBottomBarWhenPushed = YES;
    GLMine_Team_TeamAchievementController *achieveVC = [[GLMine_Team_TeamAchievementController alloc] init];
    [self.navigationController pushViewController:achieveVC animated:YES];
    
}

#pragma mark - 绩效管理
- (IBAction)achievementManage:(id)sender {
    
    self.hidesBottomBarWhenPushed = YES;
    GLMine_Team_AchievementManageController *achieveVC = [[GLMine_Team_AchievementManageController alloc] init];
    [self.navigationController pushViewController:achieveVC animated:YES];
}

#pragma mark - 开通创客
- (IBAction)openGuest:(id)sender {
   
    self.hidesBottomBarWhenPushed = YES;
    GLMine_Team_OpenMakerController *openVC = [[GLMine_Team_OpenMakerController alloc] init];
    [self.navigationController pushViewController:openVC animated:YES];
}

#pragma mark - 团队成员
- (IBAction)teamMember:(id)sender {
    
    self.hidesBottomBarWhenPushed = YES;
    GLMine_Team_MembersController *vc = [[GLMine_Team_MembersController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 开通商户
- (IBAction)openBusiness:(id)sender {

    self.hidesBottomBarWhenPushed = YES;
    GLMine_Team_OpenSellerController *vc = [[GLMine_Team_OpenSellerController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
