//
//  GLMine_Team_HistoryHeader.m
//  excellentPurchase
//
//  Created by 龚磊 on 2018/1/18.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "GLMine_Team_HistoryHeader.h"

@interface GLMine_Team_HistoryHeader()

@end

@implementation GLMine_Team_HistoryHeader

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self = [[NSBundle mainBundle]loadNibNamed:@"GLMine_Team_HistoryHeader" owner:self options:nil].firstObject;
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

/**
 日期选择

 */
- (IBAction)dateChoose:(id)sender {
    if ([self.delegate respondsToSelector:@selector(dateChoose)]) {
        [self.delegate dateChoose];
    }
}

@end
