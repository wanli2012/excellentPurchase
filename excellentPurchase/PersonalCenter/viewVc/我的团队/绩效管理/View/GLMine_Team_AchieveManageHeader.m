//
//  GLMine_Team_AchieveManageHeader.m
//  excellentPurchase
//
//  Created by 龚磊 on 2018/1/17.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "GLMine_Team_AchieveManageHeader.h"

@implementation GLMine_Team_AchieveManageHeader

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self = [[NSBundle mainBundle]loadNibNamed:@"GLMine_Team_AchieveManageHeader" owner:self options:nil].firstObject;
        self.frame = frame;
        self.autoresizingMask = UIViewAutoresizingNone;
        
        [self initInyerface];
    }
    return self;
}

-(void)initInyerface{
    [self setNeedsLayout];
    [self layoutIfNeeded];
    
    
}


@end
