//
//  LBHomeOneDolphinDetailHeaderView.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/3/12.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "LBHomeOneDolphinDetailHeaderView.h"
#import "LBDolphinDetailOneHeaderView.h"
#import "LBDolphinDetailTwoHeaderView.h"

@interface LBHomeOneDolphinDetailHeaderView()<SDCycleScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *bannerView;
@property (weak, nonatomic) IBOutlet UIButton *picWordBt;
@property (strong, nonatomic)SDCycleScrollView *cycleScrollView;//banner
@property (strong, nonatomic)LBDolphinDetailOneHeaderView *dolphinDetailOneHeaderView;
@property (strong, nonatomic)LBDolphinDetailTwoHeaderView *dolphinDetailTwoHeaderView;

@end

@implementation LBHomeOneDolphinDetailHeaderView

-(void)awakeFromNib{
    [super awakeFromNib];
    [self initInterface];
    
}

-(void)initInterface{
    [self.picWordBt setTitle:[NSString stringWithFormat:@"图文\n详情"] forState:UIControlStateNormal];
    self.picWordBt.titleLabel.lineBreakMode = 0;
    [self.bannerView insertSubview:self.cycleScrollView belowSubview:self.picWordBt];
    [self addSubview:self.dolphinDetailOneHeaderView];
    [self addSubview:self.dolphinDetailTwoHeaderView];
     __weak typeof(self) wself = self;
    [self.cycleScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self).offset(0);
        make.leading.equalTo(self).offset(0);
        make.top.equalTo(self).offset(0);
        make.height.equalTo(wself.cycleScrollView.mas_width).multipliedBy(1);
    }];
    
    [self.dolphinDetailOneHeaderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self).offset(0);
        make.leading.equalTo(self).offset(0);
        make.top.equalTo(wself.cycleScrollView.mas_bottom).offset(0);
        make.height.equalTo(@214);
    }];
    
    [self.dolphinDetailTwoHeaderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self).offset(0);
        make.leading.equalTo(self).offset(0);
        make.top.equalTo(wself.dolphinDetailOneHeaderView.mas_bottom).offset(0);
        make.height.equalTo(@195);
    }];
}

//查看图文混排
- (IBAction)pictureWordEvent:(UIButton *)sender {
    
    
}

-(SDCycleScrollView*)cycleScrollView{
    
    if (!_cycleScrollView) {
        _cycleScrollView = [[SDCycleScrollView alloc]init];//当一张都没有的时候的 占位图
        //每一张图的占位图
        _cycleScrollView.delegate = self;
        _cycleScrollView.placeholderImage = [UIImage imageNamed:@"shangpinxiangqing"];
        _cycleScrollView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
        _cycleScrollView.autoScrollTimeInterval = 2;// 自动滚动时间间隔
        _cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;// 翻页 右下角
        _cycleScrollView.titleLabelBackgroundColor = [UIColor groupTableViewBackgroundColor];// 图片对应的标题的 背景色。（因为没有设标题）
        _cycleScrollView.backgroundColor = [UIColor whiteColor];
        _cycleScrollView.pageControlDotSize = CGSizeMake(10, 10);
        _cycleScrollView.localizationImageNamesGroup = @[@" ",@" "];
        _cycleScrollView.showPageControl = NO;
    }
    
    return _cycleScrollView;
    
}

-(LBDolphinDetailOneHeaderView*)dolphinDetailOneHeaderView{
    if (!_dolphinDetailOneHeaderView) {
        _dolphinDetailOneHeaderView = [[NSBundle mainBundle]loadNibNamed:@"LBDolphinDetailOneHeaderView" owner:nil options:nil].firstObject;
    }
    return _dolphinDetailOneHeaderView;
}

-(LBDolphinDetailTwoHeaderView*)dolphinDetailTwoHeaderView{
    if (!_dolphinDetailTwoHeaderView) {
        _dolphinDetailTwoHeaderView = [[NSBundle mainBundle]loadNibNamed:@"LBDolphinDetailTwoHeaderView" owner:nil options:nil].firstObject;
    }
    return _dolphinDetailTwoHeaderView;
}
@end
