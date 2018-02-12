//
//  LBHorseGroupTableViewCell.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/1/9.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "LBHorseGroupTableViewCell.h"
#import "LBHorseRaceLampModel.h"
#import "TXScrollLabelView.h"

@interface LBHorseGroupTableViewCell ()<TXScrollLabelViewDelegate>

@property (nonatomic, copy)NSArray *dataSource;
@property (nonatomic, strong)TXScrollLabelView *scrollLabelView;

@end

@implementation LBHorseGroupTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initDataFace];
    }
    
    return self;
}

-(void)initDataFace{
    
    [self.imagev removeFromSuperview];
    [self addSubview:self.imagev];
    __weak typeof(self) wself = self;
    [self.imagev mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self).offset(10);
        make.height.equalTo(@35);
        make.centerY.equalTo(self);
        make.width.mas_equalTo(wself.imagev.mas_height).multipliedBy(1);//设置等比宽高
    }];
    
     [self addWith:TXScrollLabelViewTypeFlipNoRepeat velocity:2 isArray:YES];
}

- (void)addWith:(TXScrollLabelViewType)type velocity:(CGFloat)velocity isArray:(BOOL)isArray {
    /** Step1: 滚动文字 */
    
    NSArray *scrollTexts = @[@" "];
    
    /** Step2: 创建 ScrollLabelView */
    _scrollLabelView = nil;
    if (isArray) {
        _scrollLabelView = [TXScrollLabelView scrollWithTextArray:scrollTexts type:type velocity:velocity options:UIViewAnimationOptionCurveEaseInOut inset:UIEdgeInsetsZero];
    }
    
    /** Step3: 设置代理进行回调 */
    _scrollLabelView.scrollLabelViewDelegate = self;
    _scrollLabelView.frame = CGRectMake(55, 5, UIScreenWidth  - 60, 50);
    [self addSubview:_scrollLabelView];
    /** Step4: 布局(Required) */

    //偏好(Optional), Preference,if you want.
//    _scrollLabelView.tx_centerX  = [UIScreen mainScreen].bounds.size.width * 0.5;
    _scrollLabelView.scrollInset = UIEdgeInsetsMake(0, 10 , 0, 10);
    _scrollLabelView.scrollSpace = 10;
    _scrollLabelView.font = [UIFont systemFontOfSize:14];
    _scrollLabelView.textAlignment = NSTextAlignmentLeft;
    _scrollLabelView.scrollTitleColor =LBHexadecimalColor(0x333333);
    _scrollLabelView.backgroundColor = [UIColor clearColor];
    _scrollLabelView.layer.cornerRadius = 5;
    
    /** Step5: 开始滚动(Start scrolling!) */
    [_scrollLabelView beginScrolling];
}


- (void)setNewsModels:(NSArray<GLHome_newsModel *> *)newsModels{
    _newsModels = newsModels;

    NSMutableArray *arrM = [NSMutableArray array];
    for (GLHome_newsModel *model in newsModels) {
        [arrM addObject:model.title];
    }
    _scrollLabelView.dataArr = arrM;
    /** Step5: 开始滚动(Start scrolling!) */
    [_scrollLabelView beginScrolling];
}
- (void)setOrderModels:(NSArray<GLHome_ordersModel *> *)orderModels{
    _orderModels = orderModels;
    
    NSMutableArray *arrM = [NSMutableArray array];
    for (GLHome_ordersModel *model in orderModels) {
        [arrM addObject:model.title];
    }
    _scrollLabelView.dataArr = arrM;
    /** Step5: 开始滚动(Start scrolling!) */
    [_scrollLabelView beginScrolling];
}

- (void)scrollLabelView:(TXScrollLabelView *)scrollLabelView didClickWithText:(NSString *)text atIndex:(NSInteger)index{
    [self.delegate toDetail:self.index infoIndex:index];
}

-(UIImageView*)imagev{
    
    if (!_imagev) {
        _imagev = [[UIImageView alloc]init];
        _imagev.backgroundColor = [UIColor clearColor];
        _imagev.image = [UIImage imageNamed:@"世纪优购"];
        _imagev.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _imagev;
}

@end
