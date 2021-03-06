//
//  LBAddCounterView.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/1/25.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "LBAddCounterView.h"
#import "LBAddCounterContainerView.h"

@interface LBAddCounterView()<UITextFieldDelegate>

///选择回调
@property (nonatomic, copy) void (^filedBlock)(NSString *textfiled);

@property (strong , nonatomic)LBAddCounterContainerView *containerview;

@end

@implementation LBAddCounterView

+(LBAddCounterView *)addCounterFrame:(CGRect)frame delegate:(id)delegate textfBloack:(void (^)(NSString *))filedBlock{
    return [self initAddCounterWithFrame:frame delegate:delegate textfBloack:filedBlock];
}

+(instancetype)initAddCounterWithFrame:(CGRect)frame delegate:(id)delegate textfBloack:(void (^)(NSString *))filedBlock{
    LBAddCounterView *view = [[LBAddCounterView alloc]initWithFrame:frame];
    [view showView];
    view.delegate = delegate;
    view.filedBlock = filedBlock;
    return view;
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = YYSRGBColor(0, 0, 0, 0.3);
        [self initinterfave];// 加载界面
    }
    return self;
}

#pragma mark - 初始化界面

-(void)initinterfave{
    
    _containerview =[[NSBundle mainBundle]loadNibNamed:@"LBAddCounterContainerView" owner:nil options:nil].firstObject;
    _containerview.backgroundColor = [UIColor whiteColor];
    _containerview.frame =CGRectMake(10, UIScreenHeight, UIScreenWidth - 20, 320);
    _containerview.layer.cornerRadius = 4;
    _containerview.clipsToBounds = YES;
    [_containerview.surebt addTarget:self action:@selector(sureEvent) forControlEvents:UIControlEventTouchUpInside];
    [_containerview.cancelBt addTarget:self action:@selector(hideView) forControlEvents:UIControlEventTouchUpInside];
    _containerview.textfiled.delegate = self;

    
    UITapGestureRecognizer *tapgestureType = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(choseType)];
    [_containerview.typeView addGestureRecognizer:tapgestureType];
    
    [self addSubview:_containerview];
    
    UITapGestureRecognizer *tapgesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideView)];
    [self addGestureRecognizer:tapgesture];
    
}

#pragma mark - 类型选择
-(void)choseType{
    
    WeakSelf;
    if ([self.delegate respondsToSelector:@selector(popClassifyView:)]) {
        [self.delegate popClassifyView:^(NSString *text) {
            weakSelf.containerview.typeTF.text = text;
        }];
    }
}

-(void)sureEvent{
    
    if (self.filedBlock) {
        self.filedBlock(_containerview.textfiled.text);
    }
    
    [self hideView];
}


- (void)showView {
    
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    self.backgroundColor = [UIColor clearColor];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.backgroundColor = YYSRGBColor(0, 0, 0, 0.3);
        self.containerview.y = (UIScreenHeight - self.containerview.height)/2.0;
    }];
}

- (void)hideView {
    
    [UIView animateWithDuration:0.3 animations:^{
        self.backgroundColor = [UIColor clearColor];
        self.containerview.y = UIScreenHeight;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    
}


@end
