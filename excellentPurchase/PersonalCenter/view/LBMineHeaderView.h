//
//  LBMineHeaderView.h
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/1/15.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LBMineHeaderViewDelegate <NSObject>

//跳转到我的资产
- (void)toMyProperty;

//切换账号
- (void)changeAccountEvent;

//跳转到个人信息
- (void)toMyInfomation;

@end

@interface LBMineHeaderView : UIView

@property (nonatomic, weak)id <LBMineHeaderViewDelegate> delegate;

@property (nonatomic, copy)NSArray *noticeArr;//通知数组

@property (nonatomic, copy)NSArray *titleArr;
@property (nonatomic, copy)NSArray *valueArr;

@property (weak, nonatomic) IBOutlet UIImageView *iconImageV;//头像
@property (weak, nonatomic) IBOutlet UILabel *nicknameLabel;//昵称
@property (weak, nonatomic) IBOutlet UILabel *IDNumberLabel;//id号
@property (weak, nonatomic) IBOutlet UILabel *groupTypeLabel;//身份类型

@end
