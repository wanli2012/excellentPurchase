//
//  GLMine_Team_AchieveManageHeader.h
//  excellentPurchase
//
//  Created by 龚磊 on 2018/1/17.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GLMine_Team_AchieveManageHeaderDelegate <NSObject>

- (void)setAchieveMent;

@end

@interface GLMine_Team_AchieveManageHeader : UIView

@property (nonatomic, weak)id <GLMine_Team_AchieveManageHeaderDelegate> delegate;

@end
