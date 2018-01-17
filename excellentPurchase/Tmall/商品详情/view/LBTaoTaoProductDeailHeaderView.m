//
//  LBTaoTaoProductDeailHeaderView.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/1/15.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "LBTaoTaoProductDeailHeaderView.h"

@interface LBTaoTaoProductDeailHeaderView()<SDCycleScrollViewDelegate>

@property (strong, nonatomic)NSArray *imagearr;
@property (strong, nonatomic)SDCycleScrollView *cycleScrollView;

@property (strong, nonatomic)UIView *masckview;
@property (strong, nonatomic)UILabel *label;

@end

@implementation LBTaoTaoProductDeailHeaderView
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = frame;
        [self initInterface];
        
    }
    return self;
}

-(void)initInterface{
    [self addSubview:self.cycleScrollView];
    [self addSubview:self.masckview];
    [self.masckview addSubview:self.label];
    
    [_cycleScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self).offset(0);
        make.leading.equalTo(self).offset(0);
        make.top.equalTo(self).offset(0);
        make.bottom.equalTo(self).offset(0);
        }];
    
    [_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.masckview).offset(-5);
        make.leading.equalTo(self.masckview).offset(5);
        make.top.equalTo(self.masckview).offset(0);
        make.bottom.equalTo(self.masckview).offset(0);
    }];
    
}
-(SDCycleScrollView*)cycleScrollView{
    
    if (!_cycleScrollView) {
        _cycleScrollView = [[SDCycleScrollView alloc]init];//当一张都没有的时候的 占位图
        //每一张图的占位图
        _cycleScrollView.delegate = self;
        _cycleScrollView.placeholderImage = [UIImage imageNamed:@""];
        _cycleScrollView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
        _cycleScrollView.autoScrollTimeInterval = 2;// 自动滚动时间间隔
        _cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;// 翻页 右下角
        _cycleScrollView.titleLabelBackgroundColor = [UIColor clearColor];// 图片对应的标题的 背景色。（因为没有设标题）
        _cycleScrollView.pageControlDotSize = CGSizeMake(10, 10);
        _cycleScrollView.localizationImageNamesGroup = self.imagearr;
        _cycleScrollView.showPageControl = NO;
    }
    
    return _cycleScrollView;
    
}

-(NSArray*)imagearr{
    
    if (!_imagearr) {
        _imagearr = @[@"banner"];
    }
    
    return _imagearr;
    
}

-(UIView*)masckview{
    if (!_masckview) {
        _masckview = [[UIView alloc]initWithFrame:CGRectMake(UIScreenWidth - 60, self.frame.size.height - 30, 50, 25)];
        _masckview.backgroundColor =YYSRGBColor(0, 0, 0, 0.4);
        _masckview.layer.cornerRadius = 12.5;
        _masckview.clipsToBounds = YES;
    }
    
    return _masckview;
}

-(UILabel*)label{
    if (!_label) {
        _label = [[UILabel alloc]init];
        _label.backgroundColor = [UIColor clearColor];
        _label.text = @"1/2";
        _label.textColor = [UIColor whiteColor];
        _label.font = [UIFont systemFontOfSize:14];
        _label.textAlignment = NSTextAlignmentCenter;
    }
    return _label;
}

@end
