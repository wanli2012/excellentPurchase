//
//  CALayer+LBBorderLayer.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/1/15.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "CALayer+LBBorderLayer.h"

@implementation CALayer (LBBorderLayer)

@dynamic borderUIWidth;

-(void)setBorderUIColor:(UIColor *)borderUIColor{
    self.borderColor = borderUIColor.CGColor;
}

-(UIColor*)borderUIColor
{
    return [UIColor colorWithCGColor:self.borderColor];
}

-(void)setBorderUIWidth:(CGFloat)borderUIWidth{
    if (borderUIWidth <=0 ) {
        return;
    }
    
    self.borderWidth = borderUIWidth;
}

-(CGFloat)borderUIWidth{
    
    return self.borderWidth;
}
@end
