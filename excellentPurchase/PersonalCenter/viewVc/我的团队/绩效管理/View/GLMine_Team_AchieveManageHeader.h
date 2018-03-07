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

@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UILabel *namelb;
@property (weak, nonatomic) IBOutlet UILabel *uidtsr;
@property (weak, nonatomic) IBOutlet UILabel *planlb;
@property (weak, nonatomic) IBOutlet UILabel *donelb;

@property (nonatomic, weak)id <GLMine_Team_AchieveManageHeaderDelegate> delegate;

@end
