//
//  LBEat_StoreCommentHeaderView.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/1/19.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "LBEat_StoreCommentHeaderView.h"
#import "XHStarRateView.h"
#import "LB_Eat'commentDataModel.h"
#import "formattime.h"

@interface LBEat_StoreCommentHeaderView()

@property (strong , nonatomic)UIImageView *headimage;//头像

@property (strong , nonatomic)UILabel *nameLb;//呢称

@property (strong , nonatomic)UILabel *identifyLb;//ID

@property (strong, nonatomic) XHStarRateView *starRateView;//评分

@property (strong , nonatomic)UILabel *contentLb;//内容

@property (strong , nonatomic)UILabel *timeLb;//时间

@property (strong , nonatomic)UIButton *replayBt;//回复按钮

@end

@implementation LBEat_StoreCommentHeaderView

-(instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self initInterFace];//初始化界面
    }
    return self;
}

-(void)setHomeInvestModel:(LB_EatCommentFrameModel *)HomeInvestModel{
    _HomeInvestModel = HomeInvestModel;

    [self.headimage sd_setImageWithURL:[NSURL URLWithString:_HomeInvestModel.HomeInvestModel.pic] placeholderImage:nil];
    
    if ([NSString StringIsNullOrEmpty:_HomeInvestModel.HomeInvestModel.nickname] == NO) {
        self.nameLb.text = [NSString stringWithFormat:@"%@",_HomeInvestModel.HomeInvestModel.nickname];
    }else{
        self.nameLb.text = [NSString stringWithFormat:@"无呢称"];
    }
    _starRateView.currentScore = [_HomeInvestModel.HomeInvestModel.mark floatValue];
    
    self.contentLb.text = [NSString stringWithFormat:@"%@",_HomeInvestModel.HomeInvestModel.comment];
    
    self.identifyLb.text = [NSString stringWithFormat:@"%@",_HomeInvestModel.HomeInvestModel.user_name];
    
    self.timeLb.text = [formattime formateTimeYM:_HomeInvestModel.HomeInvestModel.addtime];
}

-(void)tapgestureSelf{
    if (self.pushCommentsListVc) {
        self.pushCommentsListVc();
    }
}

-(void)showComment{
    self.showComments(self.section);
}

-(void)initInterFace{
    [self addSubview:self.headimage];
    [self addSubview:self.starRateView];
    [self addSubview:self.nameLb];
    [self addSubview:self.identifyLb];
    [self addSubview:self.contentLb];
    [self addSubview:self.timeLb];
    
    //[self addSubview:self.replayBt];
    
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
    
    [self.contentLb mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.trailing.equalTo(self).offset(-10);
        make.leading.equalTo(self.headimage.mas_trailing).offset(10);
        make.top.equalTo(self.identifyLb.mas_bottom).offset(13);
        
    }];
    [self.timeLb mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.leading.equalTo(self.headimage.mas_trailing).offset(10);
        make.top.equalTo(self.contentLb.mas_bottom).offset(13);
        
    }];
    
//    [self.replayBt mas_makeConstraints:^(MASConstraintMaker *make) {
//
//        make.trailing.equalTo(self).offset(-10);
//        make.centerY.equalTo(self.timeLb);
//
//    }];
    
    UITapGestureRecognizer *tapgesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapgestureSelf)];
    [self addGestureRecognizer:tapgesture];
    
}

-(UILabel*)nameLb{
    if (!_nameLb) {
        _nameLb = [[UILabel alloc]init];
        _nameLb.textColor = LBHexadecimalColor(0x666666);
        _nameLb.font = [UIFont systemFontOfSize:13];
    }
    return _nameLb;
}

-(UILabel*)identifyLb{
    if (!_identifyLb) {
        _identifyLb = [[UILabel alloc]init];
        _identifyLb.textColor = LBHexadecimalColor(0x808080);
        _identifyLb.font = [UIFont systemFontOfSize:10];
    }
    return _identifyLb;
}

-(UILabel*)contentLb{
    if (!_contentLb) {
        _contentLb = [[UILabel alloc]init];
        _contentLb.textColor = LBHexadecimalColor(0x333333);
        _contentLb.font = [UIFont systemFontOfSize:14];
        _contentLb.numberOfLines = 0;
    }
    return _contentLb;
}
-(UILabel*)timeLb{
    if (!_timeLb) {
        _timeLb = [[UILabel alloc]init];
        _timeLb.textColor = LBHexadecimalColor(0x999999);
        _timeLb.font = [UIFont systemFontOfSize:10];
    }
    return _timeLb;
}

-(UIImageView*)headimage{
    if (!_headimage) {
        _headimage = [[UIImageView alloc]initWithFrame:CGRectMake(10, 15, 40, 40)];
        _headimage.backgroundColor = [UIColor groupTableViewBackgroundColor];
        _headimage.layer.cornerRadius = 20;
        _headimage.clipsToBounds = YES;
    }
    return _headimage;
}

-(UIButton*)replayBt{
    if (!_replayBt) {
        _replayBt = [[UIButton alloc]init];
        _replayBt.bounds = CGRectMake(0, 0, 35, 25);
        _replayBt.backgroundColor = [UIColor whiteColor];
        [_replayBt setImage:[UIImage imageNamed:@"eat-pinglun"] forState:UIControlStateNormal];
        [_replayBt addTarget:self action:@selector(showComment) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _replayBt;
}

-(XHStarRateView*)starRateView{
    if (!_starRateView) {
        _starRateView = [[XHStarRateView alloc] initWithFrame:CGRectMake(UIScreenWidth - 90, CGRectGetMinY(self.headimage.frame), 80, 13)];
        _starRateView.isAnimation = YES;
        _starRateView.rateStyle = IncompleteStar;
        _starRateView.backgroundColor = [UIColor clearColor];
    }
    return _starRateView;
}

@end
