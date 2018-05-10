//
//  HHPayPasswordView.m
//  HHPayPasswordView
//
//  Created by xiaozuan on 2017/9/7.
//  Copyright © 2017年 xiaozuan. All rights reserved.
//

#import "HHPayPasswordView.h"
#import "HHTextField.h"
#import "HHPasswordErrorView.h"
#import "IQKeyboardManager.h"

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

static NSInteger const kDotsNumber = 6;
static CGFloat const kDotWith_height = 10;

@interface HHPayPasswordView()<UITextFieldDelegate>

@property (nonatomic, strong) UIView *coverView;
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIButton *sureButton;
@property (nonatomic, strong) UIView *line;
@property (nonatomic, strong) UIView *line1;
@property (nonatomic, strong) UIView *line2;
@property (nonatomic, strong) HHTextField *passwordField;
@property (nonatomic, strong) NSMutableArray *passwordDotsArray;

@property (nonatomic, strong) UIImageView *loadingImgView;  // 加载视图
@property (nonatomic, strong) UILabel *tipLabel;            // 提示文字

@property (nonatomic, strong) HHPasswordErrorView *errorView;

@end
@implementation HHPayPasswordView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    self.backgroundColor = [UIColor clearColor];
    UITapGestureRecognizer *tapgesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(close)];
    [self addGestureRecognizer:tapgesture];
    
    
    //监听当键盘将要出现时
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    //监听当键将要退出时
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    // 蒙版
    [self addSubview:self.coverView];
    [self addSubview:self.backView];
    [self.backView addSubview:self.closeButton];
    [self.backView addSubview:self.line];
    [self.backView addSubview:self.passwordField];
    [self.backView addSubview:self.loadingImgView];
    [self.backView addSubview:self.tipLabel];
    [self.backView addSubview:self.line1];
    [self.backView addSubview:self.cancelButton];
    [self.backView addSubview:self.line2];
     [self.backView addSubview:self.sureButton];
    
    self.coverView.frame = self.bounds;
    self.closeButton.frame = CGRectMake(0, 0, SCREEN_WIDTH - 40, 49);
    self.line.frame = CGRectMake(0, 50, SCREEN_WIDTH - 40, 0.5);
    self.passwordField.frame = CGRectMake(((SCREEN_WIDTH - 40) - 44 * 6)/2.0, 80, 44 * 6, 44);
    self.loadingImgView.frame = CGRectMake(((SCREEN_WIDTH - 40)-40)/2, CGRectGetMaxY(self.line.frame) + 30, 40, 40);
    self.tipLabel.frame = CGRectMake(((SCREEN_WIDTH - 40)-100)/2, CGRectGetMaxY(self.loadingImgView.frame) + 30, 100, 30);
    self.line1.frame = CGRectMake(0, CGRectGetMaxY(self.passwordField.frame) + 30, SCREEN_WIDTH - 40, 0.5);
    self.cancelButton.frame = CGRectMake(0, CGRectGetMaxY(self.line1.frame), (SCREEN_WIDTH - 40)/2.0, 50);
     self.line2.frame = CGRectMake(CGRectGetMaxX(self.cancelButton.frame), CGRectGetMaxY(self.line1.frame), 0.5, 50);
    self.sureButton.frame = CGRectMake(CGRectGetMaxX(self.line2.frame), CGRectGetMaxY(self.line1.frame), (SCREEN_WIDTH - 40)/2.0, 50);
    // 添加密码黑点
    [self addDotsViews];
}

//当键盘出现
- (void)keyboardWillShow:(NSNotification *)notification
{
    //获取键盘的高度
    NSDictionary *userInfo = [notification userInfo];
    NSValue *value = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [value CGRectValue];
    int height = keyboardRect.size.height;
    
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionTransitionNone animations:^{
        self.backView.frame = CGRectMake(20, self.frame.size.height - height - 220, SCREEN_WIDTH - 40, 210);
    } completion:^(BOOL finished) {
    }];
}

//当键退出
- (void)keyboardWillHide:(NSNotification *)notification
{
    //获取键盘的高度
    NSDictionary *userInfo = [notification userInfo];
    NSValue *value = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [value CGRectValue];
    int height = keyboardRect.size.height;
    
}

- (void)showInView:(UIView *)view{
    [view addSubview:self];
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    [IQKeyboardManager sharedManager].enable = NO;
    [self.passwordField becomeFirstResponder];
}
- (void)hide{
    [self close];
}
- (void)close{
    [self.passwordField resignFirstResponder];
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{

        self.backView.frame = CGRectMake(20, SCREEN_HEIGHT, SCREEN_WIDTH - 40, 210);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
        [IQKeyboardManager sharedManager].enable = YES;
    }];
}
-(void)sureEvent{
    [self .delegate actionSure:_passwordField.text];
}
- (void)startLoading{
    self.loadingImgView.hidden = NO;
    self.tipLabel.hidden = NO;
    self.passwordField.hidden = YES;
    self.line1.hidden = YES;
    self.line2.hidden = YES;
    self.cancelButton.hidden = YES;
    self.sureButton.hidden = YES;
 
    [self setDotsViewHidden];
    
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
    rotationAnimation.duration = 2.0;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = MAXFLOAT;
    [self.loadingImgView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}
- (void)stopLoading{
    self.tipLabel.hidden = YES;
}
// 弹出密码错误视图
- (void)showPasswordErrorWithLimit:(NSInteger )limit message:(NSString *)message{
    [self stopLoading];
    self.errorView = [[HHPasswordErrorView alloc] init];
    self.errorView.limit = limit;
    if ([NSString StringIsNullOrEmpty:message]) {
         self.errorView.titleLabel.text = @"请求失败";
    }else{
         self.errorView.titleLabel.text = message;
    }
    [self.errorView.onceButton addTarget:self action:@selector(clickOnceButton) forControlEvents:UIControlEventTouchUpInside];
    [self.errorView.forgetPwdButton addTarget:self action:@selector(clickForgetPwd) forControlEvents:UIControlEventTouchUpInside];
    [self.errorView showInView:self.backView];
}
#pragma mark - 支付成功
- (void)paySuccess{
    self.tipLabel.text = @"支付成功";
    self.loadingImgView.image = [UIImage imageNamed:@"password_success"];
    [self.loadingImgView.layer removeAllAnimations];
}
#pragma mark - 支付失败 密码错误
- (void)payFailureWithPasswordError:(BOOL)passwordError withErrorLimit:(NSInteger)limit message:(NSString *)message{
    self.loadingImgView.hidden = YES;
    if (passwordError) {
        [self showPasswordErrorWithLimit:limit message:message];
    }
}

// 点击忘记密码
- (void)clickOnceButton{
    [self close];
}
// 点击重新输入
- (void)clickForgetPwd{

    [self.errorView hide];
    self.passwordField.hidden = NO;
    self.passwordField.text = @"";
    self.line1.hidden = NO;
    self.line2.hidden = NO;
    self.cancelButton.hidden = NO;
    self.sureButton.hidden = NO;
    [self.passwordField becomeFirstResponder];
    
}
#pragma mark 
- (void)addDotsViews{
    //密码输入框的宽度
    CGFloat passwordFieldWidth = CGRectGetWidth(self.passwordField.frame);
    //六等分 每等分的宽度
    CGFloat password_width = passwordFieldWidth / kDotsNumber;
    //密码输入框的高度
    CGFloat password_height = CGRectGetHeight(self.passwordField.frame);
    
    for (int i = 0; i < kDotsNumber; i ++)
    {
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(i * password_width, 0, 0.5, password_height)];
        line.backgroundColor = [UIColor colorWithRed:217/255.0 green:217/255.0 blue:217/255.0 alpha:1];
        [self.passwordField addSubview:line];
        
        //假密码点的x坐标
        CGFloat dotViewX = (i + 1)*password_width - password_width / 2.0 - kDotWith_height / 2.0;
        CGFloat dotViewY = (password_height - kDotWith_height) / 2.0;
        UIView *dotView = [[UIView alloc] initWithFrame:CGRectMake(dotViewX, dotViewY, kDotWith_height, kDotWith_height)];
        dotView.backgroundColor = [UIColor blackColor];
        dotView.layer.cornerRadius = kDotWith_height/2.0;
        dotView.hidden = YES;
        [self.passwordField addSubview:dotView];
        [self.passwordDotsArray addObject:dotView];
    }
}
// 将所有的假密码点设置为隐藏状态
- (void)setDotsViewHidden{
    for (UIView *view in _passwordDotsArray){
        [view setHidden:YES];
    }
}
- (void)setDotsViewShow{
    for (UIView *view in _passwordDotsArray){
        [view setHidden:NO];
    }
}
- (void)passwordFieldDidChange:(UITextField *)field{
    [self setDotsViewHidden];
    
    for (int i = 0; i < _passwordField.text.length; i ++){
        if (_passwordDotsArray.count > i ) {
            UIView *dotView = _passwordDotsArray[i];
            [dotView setHidden:NO];
        }
    }
    
    if (_passwordField.text.length == 6){

        [self startLoading];
        [self.passwordField resignFirstResponder];
        if ([_delegate respondsToSelector:@selector(passwordView:didFinishInputPayPassword:)]) {
            
            [_delegate passwordView:self didFinishInputPayPassword:_passwordField.text];
        }
    }
}

#pragma mark == UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    //删除键
    if (string.length == 0){
        return YES;
    }
    
    if (_passwordField.text.length >= kDotsNumber){
        return NO;
    }
    return YES;
}
#pragma mark - 懒加载控件
- (UIView *)coverView{
    if (_coverView == nil){
        _coverView = [[UIView alloc] init];
        [_coverView setBackgroundColor:[UIColor blackColor]];
        _coverView.alpha = 0.3;
    }
    return _coverView;
}

- (UIView *)backView{
    if (!_backView) {
        _backView = [[UIView alloc] init];
        _backView.backgroundColor = [UIColor whiteColor];
        _backView.layer.cornerRadius = 3;
        _backView.clipsToBounds = YES;
        _backView.frame = CGRectMake(20, SCREEN_HEIGHT , SCREEN_WIDTH - 40, 300);
    }
    return _backView;
}
- (UIButton *)closeButton{
    if (!_closeButton) {
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeButton setTitle:@"请输入密码" forState:UIControlStateNormal];
        _closeButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [_closeButton setTitleColor:[UIColor colorWithRed:33/255.0 green:33/255.0 blue:33/255.0 alpha:1] forState:UIControlStateNormal];
        //[_closeButton addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeButton;
}

- (UIButton *)cancelButton{
    if (!_cancelButton) {
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        _cancelButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [_cancelButton setTitleColor:[UIColor colorWithRed:33/255.0 green:33/255.0 blue:33/255.0 alpha:1] forState:UIControlStateNormal];
        [_cancelButton addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
        _cancelButton.backgroundColor = [UIColor whiteColor];
    }
    return _cancelButton;
}
- (UIButton *)sureButton{
    if (!_sureButton) {
        _sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sureButton setTitle:@"确定" forState:UIControlStateNormal];
        _sureButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [_sureButton setTitleColor:[UIColor colorWithRed:251/255.0 green:39/255.0 blue:49/255.0 alpha:1] forState:UIControlStateNormal];
        [_sureButton addTarget:self action:@selector(sureEvent) forControlEvents:UIControlEventTouchUpInside];
        _sureButton.backgroundColor = [UIColor whiteColor];
    }
    return _sureButton;
}

- (UIView *)line{
    if (!_line) {
        _line = [[UIView alloc] init];
        _line.backgroundColor = [UIColor colorWithRed:217/255.0 green:217/255.0 blue:217/255.0 alpha:1];
    }
    return _line;
}
- (UIView *)line1{
    if (!_line1) {
        _line1 = [[UIView alloc] init];
        _line1.backgroundColor = [UIColor colorWithRed:217/255.0 green:217/255.0 blue:217/255.0 alpha:1];
    }
    return _line1;
}
- (UIView *)line2{
    if (!_line2) {
        _line2 = [[UIView alloc] init];
        _line2.backgroundColor = [UIColor colorWithRed:217/255.0 green:217/255.0 blue:217/255.0 alpha:1];
    }
    return _line2;
}
- (HHTextField *)passwordField{
    if (_passwordField == nil){
        _passwordField = [[HHTextField alloc] init];
        _passwordField.delegate = (id)self;
        _passwordField.backgroundColor = [UIColor whiteColor];
        _passwordField.textColor = [UIColor clearColor];
        _passwordField.tintColor = [UIColor clearColor];
        _passwordField.layer.borderColor = [UIColor colorWithRed:217/255.0 green:217/255.0 blue:217/255.0 alpha:1].CGColor;
        _passwordField.layer.borderWidth = 0.5;
        _passwordField.keyboardType = UIKeyboardTypeNumberPad;
        _passwordField.secureTextEntry = YES;
    }
    [_passwordField addTarget:self action:@selector(passwordFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    return _passwordField;
}

- (NSMutableArray *)passwordDotsArray{
    if (nil == _passwordDotsArray){
        _passwordDotsArray = [[NSMutableArray alloc] initWithCapacity:kDotsNumber];
    }
    return _passwordDotsArray;
}
- (UIImageView *)loadingImgView {
    if (_loadingImgView == nil) {
        _loadingImgView = [[UIImageView alloc] init];
        _loadingImgView.image = [UIImage imageNamed:@"password_loading_a"];
        [_loadingImgView sizeToFit];
        _loadingImgView.hidden = YES;
    }
    return _loadingImgView;
}
- (UILabel *)tipLabel {
    if (_tipLabel == nil) {
        _tipLabel = [[UILabel alloc] init];
        _tipLabel.text = @"支付中...";
        _tipLabel.hidden = YES;
        _tipLabel.textColor = [UIColor darkGrayColor];
        _tipLabel.font = [UIFont systemFontOfSize:14];
        _tipLabel.textAlignment = NSTextAlignmentCenter;
        [_tipLabel sizeToFit];
    }
    return _tipLabel;
}

@end
