//
//  LBHomeDolphinDetailSectionHeader.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/3/14.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "LBHomeDolphinDetailSectionHeader.h"

@interface LBHomeDolphinDetailSectionHeader()

@property (strong , nonatomic)NSArray *arr;
@property (strong , nonatomic)UIView *lineview;
@property (strong , nonatomic)UIButton *currentBt;

@end

@implementation LBHomeDolphinDetailSectionHeader

-(instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self initInterFace];//初始化界面
    }
    return self;
}

-(void)initInterFace{
    
    if (self.subviews.count <= 3) {
        for (int i = 0; i < 3; i++) {
            UIButton *bt = [[UIButton alloc]init];
            bt.frame = CGRectMake(UIScreenWidth/3.0 * i, 0, UIScreenWidth/3.0, 60);
            [bt setTitle:self.arr[i] forState:UIControlStateNormal];
            bt.tag = 10+i;
            if (i == 0) {
                self.currentBt = bt;
                [bt setTitleColor:MAIN_COLOR forState:UIControlStateNormal];
            }else{
                [bt setTitleColor:LBHexadecimalColor(0x323232) forState:UIControlStateNormal];
            }
            bt.titleLabel.font = [UIFont systemFontOfSize:15];
            [bt addTarget:self action:@selector(clickChooseEvent:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:bt];
        }
        
        [self addSubview:self.lineview];
    }
    
}

-(void)clickChooseEvent:(UIButton*)sender{
    
    if (self.currentBt == sender) {
        return;
    }else{
        [self.currentBt setTitleColor:LBHexadecimalColor(0x323232) forState:UIControlStateNormal];
        [sender setTitleColor:MAIN_COLOR forState:UIControlStateNormal];
        self.currentBt = sender;
    }
    NSInteger H = sender.tag  -10;
    [UIView animateWithDuration:0.5 animations:^{
        _lineview.frame =CGRectMake(UIScreenWidth/3.0 * H, 58, UIScreenWidth/3.0, 2);
    } completion:^(BOOL finished) {
        if (self.refreshDataosurce) {
            self.refreshDataosurce(sender.tag);
        }
    }];
    
    
}

-(NSArray*)arr{
    if (!_arr) {
        _arr = @[@"本期参与",@"往期中奖",@"中奖晒图"];
    }
    return _arr;
}

-(UIView*)lineview{
    if (!_lineview) {
        _lineview = [[UIView alloc]init];
        _lineview.frame = CGRectMake(0, 58, UIScreenWidth/3.0, 2);
        _lineview.backgroundColor = MAIN_COLOR;
    }
    return _lineview;
}
@end
