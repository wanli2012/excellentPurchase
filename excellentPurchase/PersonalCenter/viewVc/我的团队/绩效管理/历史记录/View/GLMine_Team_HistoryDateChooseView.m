//
//  GLMine_Team_HistoryDateChooseView.m
//  excellentPurchase
//
//  Created by 龚磊 on 2018/1/18.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "GLMine_Team_HistoryDateChooseView.h"
#import "FullTimeView.h"

@interface GLMine_Team_HistoryDateChooseView()<FinishPickView>
{
    UIButton *btn;
    NSString *currentDate;
    UIView *_topView;
}

///内容视图
//@property (strong, nonatomic)UIView *containView;
///选择回调
@property (nonatomic, copy) void (^dateBlock)(NSString *date);
//@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

@end

@implementation GLMine_Team_HistoryDateChooseView

+ (instancetype)showDateChooseViewWith:(void(^)(NSString *dateStr))dateBlock{
    
    return [GLMine_Team_HistoryDateChooseView addDateTypePickerViewBlock:dateBlock];
}

+(instancetype)addDateTypePickerViewBlock:(void(^)(NSString *dateStr))dateBlock{
    
    GLMine_Team_HistoryDateChooseView *_view = [[GLMine_Team_HistoryDateChooseView alloc] init];
    _view.dateBlock = dateBlock;
    
//    [_view setPicker];//获取数据

    [_view showView];//展示视图
    
    return _view;
    
}

- (instancetype)init {
    if (self = [super init]) {
    
        self.frame = CGRectMake(0, 0, UIScreenWidth, UIScreenHeight);
        self.backgroundColor = [UIColor clearColor];
        
        [self gl_setView];//加载视图

    }
    
    return self;
}

/**
 加载视图
 */
- (void)gl_setView {
    
    CGFloat topViewHeight = 270;
    CGFloat selectViewHeight = 50;
    
    if (_topView == nil){
        _topView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height-topViewHeight, self.frame.size.width, topViewHeight)];
        _topView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_topView];
        
        UIView *selectView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width,selectViewHeight)];
        selectView.backgroundColor = [[UIColor alloc]initWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:0.5];
        [_topView addSubview:selectView];
        
        UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        leftBtn.frame = CGRectMake(10, 0, 50, selectViewHeight);
        [leftBtn setTitle:@"取消" forState:UIControlStateNormal];
        [leftBtn setTitleColor:[[UIColor alloc] initWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0] forState:UIControlStateNormal];
        [leftBtn addTarget:self action:@selector(cancleBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [selectView addSubview:leftBtn];
        
        UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        rightBtn.frame = CGRectMake(self.frame.size.width-60, 0, 50, selectViewHeight);
        [rightBtn setTitle:@"确定" forState:UIControlStateNormal];
        [rightBtn setTitleColor:[[UIColor alloc] initWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0] forState:UIControlStateNormal];
        [rightBtn addTarget:self action:@selector(okBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [selectView addSubview:rightBtn];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width/2 - 50, 0, 100, selectViewHeight)];
        label.text = @"历史记录";
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor darkGrayColor];
        label.font = [UIFont systemFontOfSize:16];
        [selectView addSubview:label];
        
        
        FullTimeView *fullTimePicker = [[FullTimeView alloc]initWithFrame:CGRectMake(0, selectViewHeight, self.frame.size.width,topViewHeight - selectViewHeight)];
        fullTimePicker.curDate = [NSDate date];
        fullTimePicker.delegate = self;
        [_topView addSubview:fullTimePicker];
    }
    
    [self addSubview:_topView];
}

- (void)showView {
    
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    self.backgroundColor = [UIColor clearColor];
    _topView.y = UIScreenHeight;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.backgroundColor = YYSRGBColor(0, 0, 0, 0.3);
        _topView.y = UIScreenHeight - _topView.height;
    }];
}

-(void)okBtnClick{

    [self dismiss];
    //获取当前时间
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    [formatter setDateFormat:@"YYYY-MM"];
    NSString *DateTime = [formatter stringFromDate:date];
    //判断 进来时currentDate是否==nil 如果是空 赋值当前时间 如果不是就拿从currentDate获取到的值进行赋值
    if (currentDate==nil) {
        [btn setTitle:DateTime forState:UIControlStateNormal];
    }else{
        [btn setTitle:currentDate forState:UIControlStateNormal];
    }
    
}

-(void)cancleBtnClick{
    
    [self dismiss];
}

#pragma mark - FinishPickView
- (void)didFinishPickView:(NSDate *)date
{
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM";
    NSString *dateString = [fmt stringFromDate:date];
    // NSLog(@"%@", dateString);
    currentDate = dateString;
}
- (void)dismiss{
    
    [UIView animateWithDuration:0.3 animations:^{
        self.backgroundColor = [UIColor clearColor];
        _topView.y = UIScreenHeight;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    
}

/**
 设置picker属性
 */
//- (void)setPicker{
//
////    UIDatePicker
////    self.datePicker;
//
//    [self.datePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
//}
//
//- (void)dateChanged:(UIDatePicker *)datePicker{
//
//    NSDate *date = datePicker.date;
//
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    //设置格式：zzz表示时区
//    [dateFormatter setDateFormat:@"yyyy-MM"];
//    //NSDate转NSString
//    NSString *dateStr = [dateFormatter stringFromDate:date];
//
//    self.dateBlock(dateStr);
//
//}

//
//- (IBAction)cancel:(id)sender {
//    [self dismiss];
//}

//- (instancetype)init{
//    self = [super init];
//    if (self) {
//        self = [[NSBundle mainBundle]loadNibNamed:@"GLMine_Team_HistoryDateChooseView" owner:self options:nil].firstObject;
//        self.frame = CGRectMake(0, 0, UIScreenWidth, UIScreenHeight);
//        self.autoresizingMask = UIViewAutoresizingNone;
//
//
//        [self initInyerface];
//    }
//    return self;
//}
//
//-(void)initInyerface{
//    [self setNeedsLayout];
//    [self layoutIfNeeded];
//
//}


@end
