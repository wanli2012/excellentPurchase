//
//  LBEat_StoreCommentHeaderView.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/1/19.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "LBEat_StoreCommentHeaderView.h"
#import "XHStarRateView.h"

@interface LBEat_StoreCommentHeaderView()

@property (strong , nonatomic)UIImageView *headimage;//头像

@property (strong , nonatomic)UILabel *nameLb;//呢称

@property (strong , nonatomic)UILabel *identifyLb;//ID

@property (strong, nonatomic) XHStarRateView *starRateView;//评分

@property (strong , nonatomic)UILabel *contentLb;//内容

@end

@implementation LBEat_StoreCommentHeaderView

-(instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        [self initInterFace];//初始化界面
    }
    return self;
}

-(void)initInterFace{
    [self addSubview:self.headimage];
    [self addSubview:self.starRateView];
    [self addSubview:self.nameLb];
    [self addSubview:self.identifyLb];
    [self addSubview:self.contentLb];
    
    [self.nameLb mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.trailing.equalTo(self.starRateView.mas_leading).offset(-10);
        make.leading.equalTo(self.headimage.mas_trailing).offset(10);
        make.top.equalTo(self.headimage.mas_top).offset(0);
        
    }];
    
    [self.identifyLb mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.trailing.equalTo(self).offset(-10);
        make.leading.equalTo(self.headimage.mas_trailing).offset(10);
        make.top.equalTo(self.nameLb.mas_bottom).offset(10);
        
    }];
    
    [self.identifyLb mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.trailing.equalTo(self).offset(-10);
        make.leading.equalTo(self.headimage.mas_trailing).offset(10);
        make.top.equalTo(self.nameLb.mas_bottom).offset(10);
        
    }];
    
    
    
}

-(UILabel*)nameLb{
    if (!_nameLb) {
        _nameLb = [[UILabel alloc]init];
        _nameLb.text = @"哈哈哈哈哈";
        _nameLb.textColor = LBHexadecimalColor(0x666666);
        _nameLb.font = [UIFont systemFontOfSize:13];
    }
    return _nameLb;
}

-(UILabel*)identifyLb{
    if (!_identifyLb) {
        _identifyLb = [[UILabel alloc]init];
        _identifyLb.text = @"DZ111111";
        _identifyLb.textColor = LBHexadecimalColor(0x808080);
        _identifyLb.font = [UIFont systemFontOfSize:10];
    }
    return _identifyLb;
}

-(UILabel*)contentLb{
    if (!_contentLb) {
        _contentLb = [[UILabel alloc]init];
        _contentLb.text = @"你的间距的时刻打打闹闹数学课面对山明水秀开心时刻";
        _contentLb.textColor = LBHexadecimalColor(0x333333);
        _contentLb.font = [UIFont systemFontOfSize:14];
        _contentLb.numberOfLines = 0;
    }
    return _contentLb;
}


-(UIImageView*)headimage{
    if (!_headimage) {
        _headimage = [[UIImageView alloc]initWithFrame:CGRectMake(10, 15, 40, 40)];
        _headimage.backgroundColor = [UIColor redColor];
        _headimage.layer.cornerRadius = 20;
    }
    return _headimage;
}

-(XHStarRateView*)starRateView{
    if (!_starRateView) {
        _starRateView = [[XHStarRateView alloc] initWithFrame:CGRectMake(UIScreenWidth - 90, CGRectGetMinY(self.headimage.frame), 80, 13)];
        _starRateView.isAnimation = YES;
        _starRateView.rateStyle = IncompleteStar;
        _starRateView.backgroundColor = [UIColor clearColor];
        _starRateView.currentScore = 4.5;
    }
    return _starRateView;
}

@end
