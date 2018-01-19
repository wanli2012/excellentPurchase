//
//  LBChooseBankTypeView.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/1/12.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "LBChooseBankTypeView.h"

@interface LBChooseBankTypeView()<UIPickerViewDelegate, UIPickerViewDataSource>

//银行类型
@property(nonatomic, strong) NSArray * bankTypeArray;
///银行卡类型
@property(nonatomic, strong) NSArray * bankcardTypeArray;
///内容视图
@property(nonatomic, strong) UIView * containView;
///选择回调
@property (nonatomic, copy) void (^bankBlock)(NSString *bankType, NSString *bankcardType);

@property(nonatomic, strong) UIPickerView * pickerView;

@end

@implementation LBChooseBankTypeView

+ (instancetype)areaPickerViewWithAreaBlock:(void(^)(NSString *bankType, NSString *bankcardType))bankBlock{
    
    return [LBChooseBankTypeView addBankTypePickerViewBlock:bankBlock];
}

+(instancetype)addBankTypePickerViewBlock:(void(^)(NSString *bankType, NSString *bankcardType))bankBlock{
    
    LBChooseBankTypeView *_view = [[LBChooseBankTypeView alloc] init];
    _view.bankBlock = bankBlock;
    
    [_view getData];//获取数据
    
    [_view showView];//展示视图
    
    return _view;
    
}

- (instancetype)init {
    if (self = [super init]) {
        
        [self lb_setView];//加载视图
        
    }
    return self;
}

-(void)getData{
    self.bankTypeArray = @[@"a",@"b"];
    
    
}
- (void)showView {
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    self.backgroundColor = [UIColor clearColor];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.backgroundColor = YYSRGBColor(0, 0, 0, 0.3);
        self.containView.y = UIScreenHeight - self.containView.height;
    }];
}
- (void)hideView {
    
    [UIView animateWithDuration:0.3 animations:^{
        self.backgroundColor = [UIColor clearColor];
        self.containView.y = UIScreenHeight;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    
}



-(void)lb_setView{
    self.frame = CGRectMake(0, 0, UIScreenWidth, UIScreenHeight);
    UIView *containView = [[UIView alloc] init];
    containView.frame = CGRectMake(0, UIScreenHeight, UIScreenWidth, CZH_ScaleHeight(270));
    [self addSubview:containView];
    self.containView = containView;
    
    UIView *toolBar = [[UIView alloc] init];
    toolBar.frame = CGRectMake(0, 0, UIScreenWidth, CZH_ScaleHeight(55));
    toolBar.backgroundColor = [UIColor whiteColor];
    [containView addSubview:toolBar];
    
    UIButton *cancelBt = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 65, toolBar.height)];
    [cancelBt setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBt setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [cancelBt addTarget:self action:@selector(hideView) forControlEvents:UIControlEventTouchUpInside];
    [toolBar addSubview:cancelBt];
    
    UIButton *sureBt = [[UIButton alloc]initWithFrame:CGRectMake(UIScreenWidth - 65, 0, 65, toolBar.height)];
    [sureBt setTitle:@"确定" forState:UIControlStateNormal];
    [sureBt setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [toolBar addSubview:sureBt];
    
    UIPickerView *pickerView = [[UIPickerView alloc] init];
    pickerView.backgroundColor = [UIColor whiteColor];
    pickerView.frame = CGRectMake(0, toolBar.height, UIScreenWidth, containView.height - toolBar.height);
    pickerView.delegate = self;
    pickerView.dataSource = self;
    [containView addSubview:pickerView];
    self.pickerView = pickerView;
    
}

#pragma mark -- UIPickerView

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0) {
        return self.bankTypeArray.count;
    }
    return 0;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 30)];
    label.adjustsFontSizeToFitWidth = YES;
    label.textAlignment = NSTextAlignmentCenter;
    if (component == 0) {
        label.text = self.bankTypeArray[row];
    }
    return label;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
}


- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 40.0;
}



- (NSArray *)bankTypeArray
{
    if (!_bankTypeArray) {
        _bankTypeArray = [NSArray array];
    }
    return _bankTypeArray;
}


- (NSArray *)bankcardTypeArray
{
    if (!_bankcardTypeArray) {
        _bankcardTypeArray = [NSArray array];
    }
    return _bankcardTypeArray;
}



@end
