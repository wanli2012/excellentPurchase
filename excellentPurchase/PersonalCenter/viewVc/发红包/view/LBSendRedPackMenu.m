//
//  LBSendRedPackMenu.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/1/11.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "LBSendRedPackMenu.h"

@implementation LBSendRedPackMenu

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self = [[NSBundle mainBundle]loadNibNamed:@"LBSendRedPackMenu" owner:self options:nil].firstObject;
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
//发送红包
- (IBAction)sendRedPackEvent:(UIButton *)sender {
    [self.delegate pageMenu:self itemSelectedFromIndex:0 toIndex:1];
    self.selectedItemIndex = 1;
}
//获取红包
- (IBAction)getRedPackEvent:(UIButton *)sender {
    self.selectedItemIndex = 0;
    [self.delegate pageMenu:self itemSelectedFromIndex:1 toIndex:0];
}


@end
