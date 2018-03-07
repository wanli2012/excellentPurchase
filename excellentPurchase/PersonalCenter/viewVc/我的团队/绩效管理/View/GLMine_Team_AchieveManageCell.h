//
//  GLMine_Team_AchieveManageCell.h
//  excellentPurchase
//
//  Created by 龚磊 on 2018/1/17.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GLMine_Team_AchieveManageModel.h"
#import "GLMine_Team_MemberModel.h"
#import "LBMine_Team_ResultModel.h"

@interface GLMine_Team_AchieveManageCell : UITableViewCell

@property (nonatomic, strong)GLMine_Team_AchieveManageModel *model;
@property (nonatomic, strong)GLMine_Team_MemberModel *memberModel;
@property (nonatomic, strong)LBMine_Team_ResultModel *resultModel;

@end
