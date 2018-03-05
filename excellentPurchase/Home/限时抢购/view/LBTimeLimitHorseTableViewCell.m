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

@interface LBTimeLimitHorseTableViewCell ()<TXScrollLabelViewDelegate>

@property (nonatomic, copy)NSArray *dataSource;
@property (nonatomic, strong)TXScrollLabelView *scrollLabelView;

@end

@implementation LBTimeLimitHorseTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
     [self initDataFace];
}

-(void)initDataFace{

    [self addWith:TXScrollLabelViewTypeFlipNoRepeat velocity:2 isArray:YES];
}

- (void)addWith:(TXScrollLabelViewType)type velocity:(CGFloat)velocity isArray:(BOOL)isArray {
    /** Step1: 滚动文字 */
    
    NSArray *scrollTexts = @[@"唯独 vvv 的 v 额度部分呗"];
    
    /** Step2: 创建 ScrollLabelView */
    _scrollLabelView = nil;
    if (isArray) {
        _scrollLabelView = [TXScrollLabelView scrollWithTextArray:scrollTexts type:type velocity:velocity options:UIViewAnimationOptionCurveEaseInOut inset:UIEdgeInsetsZero];
    }
    
    /** Step3: 设置代理进行回调 */
    _scrollLabelView.scrollLabelViewDelegate = self;
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

- (void)scrollLabelView:(TXScrollLabelView *)scrollLabelView didClickWithText:(NSString *)text atIndex:(NSInteger)index{

}
@end
