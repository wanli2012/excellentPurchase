//
//  NSMutableAttributedString+LBSpecialAttributedString.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/3/20.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "NSMutableAttributedString+LBSpecialAttributedString.h"

@implementation NSMutableAttributedString (LBSpecialAttributedString)

+(NSMutableAttributedString*)addoriginstr:(NSString*)originstr specilstr:(NSArray*)specilstrArr strFont:(UIFont *)font strColor:(UIColor *)color{
    
    NSMutableAttributedString *noteStr = [[NSMutableAttributedString alloc] initWithString:originstr];
    for (int i = 0; i < specilstrArr.count; i++) {
        NSRange rang = [originstr rangeOfString:specilstrArr[i]];
        [noteStr addAttributes:@{NSForegroundColorAttributeName:color} range:rang];
        [noteStr addAttributes:@{NSFontAttributeName:font} range:rang];
    }
    
    return noteStr;
    
}

@end
