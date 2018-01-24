//
//  GLMine_PaySuccessView.m
//  excellentPurchase
//
//  Created by 龚磊 on 2018/1/23.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "GLMine_PaySuccessView.h"

@interface GLMine_PaySuccessView()

@property (weak, nonatomic) IBOutlet UIButton *completeBtn;
@property (weak, nonatomic) IBOutlet UIButton *checkBtn;


@end

@implementation GLMine_PaySuccessView

- (void)awakeFromNib {
    [super awakeFromNib];
  
}


/**
 完成
 */
- (IBAction)done:(id)sender {
    if ([self.delegate respondsToSelector:@selector(completed)]) {
        [self.delegate completed];
    }
}

/**
 查看订单
 */
- (IBAction)checkOutOrder:(id)sender {
    if ([self.delegate respondsToSelector:@selector(checkOutOrder)]) {
        [self.delegate checkOutOrder];
    }
}

@end
