//
//  LBindianaParticipationView.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/5/5.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "LBindianaParticipationView.h"

@interface LBindianaParticipationView()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *numtf;
@property (weak, nonatomic) IBOutlet UIView *infoView;
@property (weak, nonatomic) IBOutlet UIButton *chooseBt;
@property (weak, nonatomic) IBOutlet UIButton *sureBt;
@property (weak, nonatomic) IBOutlet UIView *numView;
@property (weak, nonatomic) IBOutlet UIView *contntview;
@property (strong, nonatomic)NSArray *titleArr;
@property (strong, nonatomic)UIButton *currentbt;
@property (strong, nonatomic)NSString *num;

@end

@implementation LBindianaParticipationView

-(void)awakeFromNib{
    [super awakeFromNib];
    self.numtf.delegate = self;
    UITapGestureRecognizer *choosetap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(chooseselect)];
    [self.infoView addGestureRecognizer:choosetap];
    
//    for (int i = 0; i < 4; i++) {
//
//        UIButton *button = [[UIButton alloc]init];
//        [self.contntview addSubview:button];
//
//        int BW = 55;
//        int BH = 40;
//
//        CGFloat Spacew =  (UIScreenWidth - 55 * 4)/5.0;
//        button.frame = CGRectMake(Spacew + (Spacew + BW) * i, CGRectGetMaxY(self.numView.frame) + 20, BW, BH);
//        [button setTitle:self.titleArr[i] forState:UIControlStateNormal];
//        button.titleLabel.font = [UIFont systemFontOfSize:14];
//        [button setTitleColor:LBHexadecimalColor(0x999999) forState:UIControlStateNormal];
//        button.layer.borderWidth = 1;
//        button.layer.borderColor = LBHexadecimalColor(0x999999).CGColor;
//        [button addTarget:self action:@selector(choosenumevent:) forControlEvents:UIControlEventTouchUpInside];
//        button.tag = 10+i;
//    }
    
    self.num = self.numtf.text;
}

-(void)choosenumevent:(UIButton*)button{
    
    if (self.currentbt) {
        
        if (self.currentbt == button) {
            button.backgroundColor = [UIColor whiteColor];
            [button setTitleColor:LBHexadecimalColor(0x999999) forState:UIControlStateNormal];
            button.layer.borderColor = LBHexadecimalColor(0x999999).CGColor;
            self.currentbt = button;
            self.num = self.numtf.text;
        }else{
            button.backgroundColor = MAIN_COLOR;
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            button.layer.borderColor = [UIColor clearColor].CGColor;
            self.currentbt.backgroundColor = [UIColor whiteColor];
            [self.currentbt setTitleColor:LBHexadecimalColor(0x999999) forState:UIControlStateNormal];
            self.currentbt.layer.borderColor = LBHexadecimalColor(0x999999).CGColor;
            self.currentbt = button;
            
            if (button.tag == 13) {
                self.num = @"-1";
            }else{
                self.num = button.titleLabel.text;
            }
        }
        
    }else{
        button.backgroundColor = MAIN_COLOR;
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.layer.borderColor = [UIColor clearColor].CGColor;
        self.currentbt = button;
        
        if (button.tag == 13) {
            self.num = @"-1";
        }else{
            self.num = button.titleLabel.text;
        }
    }
    
}

-(void)chooseselect{
    
    self.chooseBt.selected = !self.chooseBt.selected;
    if (self.chooseBt.selected == YES) {
        self.sureBt.backgroundColor = MAIN_COLOR;
        self.sureBt.userInteractionEnabled = YES;
    }else{
        self.sureBt.backgroundColor = LBHexadecimalColor(0xb3b3b3);
        self.sureBt.userInteractionEnabled = NO;
        
    }
}

//取消
- (IBAction)cancelEvent:(UIButton *)sender {
    
    if (self.cancelEvent) {
        self.cancelEvent();
    }
    
}
- (IBAction)divideEvent:(UIButton *)sender {
    
    if ([self.numtf.text integerValue] <=  1) {
        [EasyShowTextView showInfoText:@"至少选择1人次"];
    }
    self.numtf.text = [NSString stringWithFormat:@"%zd",[self.numtf.text integerValue] - 1];
    self.num = self.numtf.text;
}

- (IBAction)addEvent:(UIButton *)sender {
    
    self.numtf.text = [NSString stringWithFormat:@"%zd",[self.numtf.text integerValue] + 1];
    self.num = self.numtf.text;
}
- (IBAction)sureEvent:(UIButton *)sender {
    if (self.sureEvent) {
        self.sureEvent(self.num);
    }
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if ([string isEqualToString:@"\n"]) {
        [textField resignFirstResponder];
        return NO;
    }
    
    return YES;
}

-(NSArray*)titleArr{
    if (!_titleArr) {
        _titleArr = @[@"5",@"10",@"50",@"包尾"];
    }
    return _titleArr;
}
@end
