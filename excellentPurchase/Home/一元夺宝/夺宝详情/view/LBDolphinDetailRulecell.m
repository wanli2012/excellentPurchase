//
//  LBDolphinDetailRulecell.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/5/8.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "LBDolphinDetailRulecell.h"

@implementation LBDolphinDetailRulecell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setModel:(LBHomeOneDolphinDetailmodel *)model{
    _model = model;
    NSMutableString *str = [NSMutableString string];
    for (int i = 0 ; i < _model.rule.count; i++) {
        [str appendFormat:@"%d , %@ \n",i+1,_model.rule[i]];
    }
    
    self.titilelb.text = str;
    
}

@end
