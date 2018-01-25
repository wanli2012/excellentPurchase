//
//  GLMine_Branch_OnlineFooter.m
//  excellentPurchase
//
//  Created by 龚磊 on 2018/1/25.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "GLMine_Branch_OnlineFooter.h"

@interface GLMine_Branch_OnlineFooter()

@end

@implementation GLMine_Branch_OnlineFooter

-(instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self initInterFace];//初始化界面
    }
    return self;
}

-(void)initInterFace{
    
    [self addSubview:self.rightBtn];
    [self addSubview:self.leftBtn];
    
}

/**
 右键点击事件
 */
-(void)rightBtnClick{
    
    if ([self.delegate respondsToSelector:@selector(ensureOrder:)]) {
        [self.delegate ensureOrder:self.section];
    }
}

/**
 左键点击事件
 */
-(void)leftBtnClick{
    
    if ([self.delegate respondsToSelector:@selector(cancelOrder:)]) {
        [self.delegate cancelOrder:self.section];
    }
}

#pragma mark - 懒加载
- (UIButton *)rightBtn{
    if (!_rightBtn) {
        _rightBtn = [[UIButton alloc] init];
        [_rightBtn setTitle:@"确认订单" forState:UIControlStateNormal];
        [_rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _rightBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        _rightBtn.backgroundColor = MAIN_COLOR;
        _rightBtn.frame = CGRectMake(UIScreenWidth - 100, 10, 80, 30);
        _rightBtn.layer.cornerRadius = _rightBtn.height/2.0;
        _rightBtn.clipsToBounds = YES;
        [_rightBtn addTarget:self action:@selector(rightBtnClick) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _rightBtn;
}

- (UIButton *)leftBtn{
    if (!_leftBtn) {
        _leftBtn = [[UIButton alloc] init];
        [_leftBtn setTitle:@"取消订单" forState:UIControlStateNormal];
        [_leftBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _leftBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        _leftBtn.backgroundColor = MAIN_COLOR;
        _leftBtn.frame = CGRectMake(UIScreenWidth - 200, 10, 80, 30);
        _leftBtn.layer.cornerRadius = _leftBtn.height/2.0;
        _leftBtn.clipsToBounds = YES;
        [_leftBtn addTarget:self action:@selector(leftBtnClick) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _leftBtn;
}

@end
