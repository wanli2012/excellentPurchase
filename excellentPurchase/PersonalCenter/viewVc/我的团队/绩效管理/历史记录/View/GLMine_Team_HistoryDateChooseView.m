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

@property (weak, nonatomic) IBOutlet UIView *containView;

///内容视图
//@property(nonatomic, strong) UIView * containView;
///选择回调
@property (nonatomic, copy) void (^dateBlock)(NSString *date);

@end

@implementation GLMine_Team_HistoryDateChooseView

+ (instancetype)showDateChooseViewWith:(void(^)(NSString *dateStr))dateBlock{
    
    return [GLMine_Team_HistoryDateChooseView addDateTypePickerViewBlock:dateBlock];
}

+(instancetype)addDateTypePickerViewBlock:(void(^)(NSString *dateStr))dateBlock{
    
    GLMine_Team_HistoryDateChooseView *_view = [[GLMine_Team_HistoryDateChooseView alloc] init];
    _view.dateBlock = dateBlock;
    
//    [_view getData];//获取数据
//
    [_view showView];//展示视图
    
    return _view;
    
}

//- (instancetype)init {
//    if (self = [super init]) {
//
//        [self gl_setView];//加载视图
//
//    }
//    return self;
//}

/**
 加载视图
 */
- (void)gl_setView {
    
}

- (void)showView {
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    self.backgroundColor = [UIColor clearColor];
    self.containView.y = UIScreenHeight;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.backgroundColor = YYSRGBColor(0, 0, 0, 0.3);
        self.containView.y = UIScreenHeight - self.containView.height;
    }];
}

- (void)dismiss{

    [UIView animateWithDuration:0.3 animations:^{
        self.backgroundColor = [UIColor clearColor];
        self.containView.y = UIScreenHeight;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    
}

- (IBAction)cancel:(id)sender {
    [self dismiss];
}

- (instancetype)init{
    self = [super init];
    if (self) {
        self = [[NSBundle mainBundle]loadNibNamed:@"GLMine_Team_HistoryDateChooseView" owner:self options:nil].firstObject;
        self.frame = CGRectMake(0, 0, UIScreenWidth, UIScreenHeight);
        self.autoresizingMask = UIViewAutoresizingNone;
        
//        [self initInyerface];
    }
    return self;
}

-(void)initInyerface{
    [self setNeedsLayout];
    [self layoutIfNeeded];

    
}
@end
