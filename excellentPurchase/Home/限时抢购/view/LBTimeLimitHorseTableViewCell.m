//
//  LBTimeLimitHorseTableViewCell.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/3/1.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "LBTimeLimitHorseTableViewCell.h"
#import "LBHorseRaceLampModel.h"
#import "TXScrollLabelView.h"

@interface LBTimeLimitHorseTableViewCell ()

@property (nonatomic, copy)NSArray *dataSource;

@end

@implementation LBTimeLimitHorseTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _dataSource = @[@" "];
     [self initDataFace];
}

-(void)initDataFace{

    [self addWith:TXScrollLabelViewTypeFlipNoRepeat velocity:2 isArray:YES];
}

- (void)addWith:(TXScrollLabelViewType)type velocity:(CGFloat)velocity isArray:(BOOL)isArray {
    /** Step1: 滚动文字 */
    
    /** Step2: 创建 ScrollLabelView */
    _scrollLabelView = nil;
    if (isArray) {
        _scrollLabelView = [TXScrollLabelView scrollWithTextArray:_dataSource type:type velocity:velocity options:UIViewAnimationOptionCurveEaseInOut inset:UIEdgeInsetsZero];
    }
    _scrollLabelView.frame = CGRectMake(90, 5, UIScreenWidth  - 100, 40);
    [self addSubview:_scrollLabelView];
    /** Step4: 布局(Required) */
    
    //偏好(Optional), Preference,if you want.
    //    _scrollLabelView.tx_centerX  = [UIScreen mainScreen].bounds.size.width * 0.5;
    _scrollLabelView.scrollInset = UIEdgeInsetsMake(0, 0 , 0, 0);
    _scrollLabelView.scrollSpace = 10;
    _scrollLabelView.font = [UIFont systemFontOfSize:14];
    _scrollLabelView.textAlignment = NSTextAlignmentLeft;
    _scrollLabelView.scrollTitleColor =LBHexadecimalColor(0x333333);
    _scrollLabelView.backgroundColor = [UIColor clearColor];
    _scrollLabelView.layer.cornerRadius = 5;
    
    /** Step5: 开始滚动(Start scrolling!) */
    [_scrollLabelView beginScrolling];
}

-(void)setDataArr:(NSArray *)dataArr{
    _dataArr = dataArr;
    _scrollLabelView.dataArr = _dataArr;
    [_scrollLabelView beginScrolling];
    
}

@end
