//
//  LBDolphinDetailOneHeaderView.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/3/12.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "LBDolphinDetailOneHeaderView.h"

@interface LBDolphinDetailOneHeaderView()

@end

@implementation LBDolphinDetailOneHeaderView

-(void)awakeFromNib{
    [super awakeFromNib];
    [self initInterface];
}

-(void)initInterface{

    CGFloat viewWidth = UIScreenWidth - 20;
    CGFloat viewHeight = self.baseview.size.height;
    CAShapeLayer *borderLayer = [CAShapeLayer layer];
    borderLayer.frame = CGRectMake(0, 0, viewWidth, viewHeight);
//    borderLayer.position = CGPointMake(CGRectGetMidX(self.baseview.bounds), CGRectGetMidY(self.baseview.bounds));
    borderLayer.path = [UIBezierPath bezierPathWithRoundedRect:borderLayer.bounds cornerRadius:4].CGPath;
    borderLayer.lineWidth = 1. / [[UIScreen mainScreen] scale];
    //虚线边框
    borderLayer.lineDashPattern = @[@3, @3];
    borderLayer.fillColor = [UIColor clearColor].CGColor;
    borderLayer.strokeColor = [UIColor redColor].CGColor;
    [self.baseview.layer addSublayer:borderLayer];
    
    CAShapeLayer *otherborderLayer = [CAShapeLayer layer];
    otherborderLayer.frame = CGRectMake(0, 0, viewWidth, viewHeight);
    //    borderLayer.position = CGPointMake(CGRectGetMidX(self.baseview.bounds), CGRectGetMidY(self.baseview.bounds));
    otherborderLayer.path = [UIBezierPath bezierPathWithRoundedRect:borderLayer.bounds cornerRadius:4].CGPath;
    otherborderLayer.lineWidth = 1. / [[UIScreen mainScreen] scale];
    //虚线边框
    otherborderLayer.lineDashPattern = @[@3, @3];
    otherborderLayer.fillColor = [UIColor clearColor].CGColor;
    otherborderLayer.strokeColor = [UIColor redColor].CGColor;
    [self.otherView.layer addSublayer:otherborderLayer];
    
}


@end
