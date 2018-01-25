//
//  GLMine_Branch_OnlineHeader.m
//  excellentPurchase
//
//  Created by 龚磊 on 2018/1/25.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "GLMine_Branch_OnlineHeader.h"

@implementation GLMine_Branch_OnlineHeader

-(instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {

        self = [[NSBundle mainBundle] loadNibNamed:@"GLMine_Branch_OnlineHeader" owner:nil options:nil].lastObject;
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(orderDetail)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void)orderDetail{
    if ([self.delegate respondsToSelector:@selector(toOrderDetail:)]) {
        [self.delegate toOrderDetail:self.section];
    }
}

@end
