//
//  GLMine_Team_AchieveManageHeader.m
//  excellentPurchase
//
//  Created by 龚磊 on 2018/1/17.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "GLMine_Team_AchieveManageHeader.h"

@interface GLMine_Team_AchieveManageHeader()

@property (weak, nonatomic) IBOutlet UIView *setView;


@end

@implementation GLMine_Team_AchieveManageHeader

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self = [[NSBundle mainBundle]loadNibNamed:@"GLMine_Team_AchieveManageHeader" owner:self options:nil].firstObject;
        self.frame = frame;
        self.autoresizingMask = UIViewAutoresizingNone;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(setAchieveMent)];
        [self.setView addGestureRecognizer:tap];
        
        [self initInyerface];
    }
    return self;
}

-(void)initInyerface{
    [self setNeedsLayout];
    [self layoutIfNeeded];
    
}

/**
 设置布置绩效
 */
- (void)setAchieveMent{
    
    
    if ([self.delegate respondsToSelector:@selector(setAchieveMent)]) {
        [self.delegate setAchieveMent];
    }
}


@end
