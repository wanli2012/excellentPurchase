//
//  GLMine_PayFailedView.m
//  excellentPurchase
//
//  Created by 龚磊 on 2018/1/23.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "GLMine_PayFailedView.h"

@interface GLMine_PayFailedView()

@property (weak, nonatomic) IBOutlet UIView *againView;

@end

@implementation GLMine_PayFailedView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tryAgain)];
    [self.againView addGestureRecognizer:tap];
    
    
}
///重试
- (void)tryAgain {
    if ([self.delegate respondsToSelector:@selector(tryAgain)]) {
        [self.delegate tryAgain];
    }
    
}
///返回订单
- (IBAction)backToOrder:(id)sender {
    if ([self.delegate respondsToSelector:@selector(backToOrder)]) {
        [self.delegate backToOrder];
    }
}
///继续购物
- (IBAction)goOn:(id)sender {
    if ([self.delegate respondsToSelector:@selector(goOn)]) {
        [self.delegate goOn];
    }
    
}

@end
