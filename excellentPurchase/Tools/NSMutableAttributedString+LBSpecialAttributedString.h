//
//  NSMutableAttributedString+LBSpecialAttributedString.h
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/3/20.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableAttributedString (LBSpecialAttributedString)

+(NSMutableAttributedString*)addoriginstr:(NSString*)originstr specilstr:(NSArray*)specilstrArr strFont:(UIFont*)font strColor:(UIColor*)color;

@end
