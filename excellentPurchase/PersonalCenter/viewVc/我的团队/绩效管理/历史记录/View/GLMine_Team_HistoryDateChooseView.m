//
//  GLMine_Team_HistoryDateChooseView.m
//  excellentPurchase
//
//  Created by 龚磊 on 2018/1/18.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "GLMine_Team_HistoryDateChooseView.h"

@interface GLMine_Team_HistoryDateChooseView()

@property (weak, nonatomic) IBOutlet UIView *maskV;

@property (nonatomic, strong)GLMine_Team_HistoryDateChooseView *view;

@end

@implementation GLMine_Team_HistoryDateChooseView

+ (GLMine_Team_HistoryDateChooseView *)show{
    
    return [[self alloc] initWithFrame:CGRectMake(0, 0, UIScreenWidth, UIScreenHeight)];
    
}

- (void)dismiss{

    [UIView animateWithDuration:0.3 animations:^{
        
        [self removeFromSuperview];
    }completion:^(BOOL finished) {
        
        
    }];
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self = [[NSBundle mainBundle]loadNibNamed:@"GLMine_Team_HistoryDateChooseView" owner:self options:nil].firstObject;
        self.frame = frame;
        self.autoresizingMask = UIViewAutoresizingNone;
        
        [self initInyerface];
    }
    return self;
}

-(void)initInyerface{
    [self setNeedsLayout];
    [self layoutIfNeeded];
    
        self.view = [self initWithFrame:CGRectMake(0, 0, UIScreenWidth, UIScreenHeight)];
    
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        [window addGestureRecognizer:tap];
        [window addSubview:self.view];
    
}
@end
