//
//  CALayer+LBBorderLayer.h
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/1/15.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface CALayer (LBBorderLayer)

@property(nonatomic, strong) UIColor* borderUIColor;

@property(nonatomic, assign) CGFloat  borderUIWidth;

@end
