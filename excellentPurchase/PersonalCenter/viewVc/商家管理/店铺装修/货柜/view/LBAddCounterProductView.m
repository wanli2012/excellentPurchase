//
//  LBAddCounterProductView.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/1/25.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "LBAddCounterProductView.h"
#import "LBAddProductSelectView.h"

@interface LBAddCounterProductView()
///选择回调
@property (nonatomic, copy) void (^selctBlock)(NSInteger index);
@property (strong , nonatomic)LBAddProductSelectView *containerview;

@property (assign , nonatomic)NSInteger  selectindex;//选中第几个按钮

@end


@implementation LBAddCounterProductView

+(LBAddCounterProductView *)addCounterProductloack:(void (^)(NSInteger))selctBlock{
    
    return [LBAddCounterProductView initaddCounterProductloack:selctBlock];
    
}

+(instancetype)initaddCounterProductloack:(void (^)(NSInteger ))selctBlock{
    LBAddCounterProductView *view = [[LBAddCounterProductView alloc]init];
    [view showView];
    view.selctBlock  = selctBlock;
    return view;
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = YYSRGBColor(0, 0, 0, 0.3);
        self.frame = CGRectMake(0, 0, UIScreenWidth, UIScreenHeight);
        self.selectindex = 1;
        [self initinterfave];// 加载界面
    }
    return self;
}
-(void)initinterfave{
    
    _containerview =[[NSBundle mainBundle]loadNibNamed:@"LBAddProductSelectView" owner:nil options:nil].firstObject;
    _containerview.backgroundColor = [UIColor whiteColor];
    _containerview.frame =CGRectMake(10, UIScreenHeight, UIScreenWidth - 20, 217);
    _containerview.layer.cornerRadius = 4;
    _containerview.clipsToBounds = YES;
    [_containerview.sureBt addTarget:self action:@selector(sureEvent) forControlEvents:UIControlEventTouchUpInside];
    [_containerview.cancelBt addTarget:self action:@selector(hideView) forControlEvents:UIControlEventTouchUpInside];
    UITapGestureRecognizer *tmallTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapgestureTmall)];
    UITapGestureRecognizer *eatTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapgestureeat)];
    [_containerview.tmallView addGestureRecognizer:tmallTap];
    [_containerview.eatView addGestureRecognizer:eatTap];
    
    [self addSubview:_containerview];
    
    UITapGestureRecognizer *tapgesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideView)];
    [self addGestureRecognizer:tapgesture];
    
}

-(void)tapgestureTmall{
    self.selectindex = 1;
    self.containerview.tmallBt.selected = YES;
    self.containerview.eatBt.selected = NO;
}
-(void)tapgestureeat{
     self.selectindex = 2;
    self.containerview.tmallBt.selected = NO;
    self.containerview.eatBt.selected = YES;
}
-(void)sureEvent{
    
    if (self.selctBlock) {
        self.selctBlock(self.selectindex);
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
