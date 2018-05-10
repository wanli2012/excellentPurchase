//
//  LBDolphinDetailThreeHeaderView.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/3/19.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "LBDolphinDetailThreeHeaderView.h"

@interface LBDolphinDetailThreeHeaderView()

@end

@implementation LBDolphinDetailThreeHeaderView

-(void)awakeFromNib{
    [super awakeFromNib];
    
    self.zdProgressView = [[ZDProgressView alloc] initWithFrame:CGRectMake(0, 0, self.progressV.width, self.progressV.height)];
    self.zdProgressView.progress = 0.5;
    self.zdProgressView.textFont = [UIFont systemFontOfSize:10];
    self.zdProgressView.noColor = LBHexadecimalColor(0xffedec);
    self.zdProgressView.prsColor = MAIN_COLOR;
    [self.progressV addSubview:self.zdProgressView];
    
}

@end
