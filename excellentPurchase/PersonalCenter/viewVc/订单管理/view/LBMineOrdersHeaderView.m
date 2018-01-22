//
//  LBMineOrdersHeaderView.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/1/22.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "LBMineOrdersHeaderView.h"

@interface LBMineOrdersHeaderView()

@property (strong , nonatomic)UIView *containerView;//选中按钮
@property (strong , nonatomic)UIButton *chooseBt;//选中按钮
@property (strong , nonatomic)UILabel *storeNameLb;//店名
@property (strong , nonatomic)UIImageView *rightimage;//头像
@property (strong , nonatomic)UILabel *timeLb;//时间


@end

@implementation LBMineOrdersHeaderView

-(instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [self initInterFace];//初始化界面
    }
    return self;
}

-(void)initInterFace{
    
    [self addSubview:self.containerView];
     [self.containerView addSubview:self.chooseBt];
    [self.containerView addSubview:self.storeNameLb];
    [self.containerView addSubview:self.rightimage];
    [self.containerView addSubview:self.timeLb];
    
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.trailing.equalTo(self).offset(0);
        make.leading.equalTo(self).offset(0);
        make.top.equalTo(self).offset(1);
        make.bottom.equalTo(self).offset(-1);
    }];
    
    [self.timeLb mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.trailing.equalTo(self.rightimage.mas_leading).offset(0);
        make.centerY.equalTo(self.containerView);
        
    }];
    
    [self.storeNameLb mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.leading.equalTo(self.chooseBt.mas_trailing).offset(0);
        make.centerY.equalTo(self.containerView);
        make.trailing.equalTo(self.timeLb.mas_leading).offset(-10);
    }];
    
    [self.rightimage mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.trailing.equalTo(self).offset(-10);
        make.centerY.equalTo(self.containerView);
        make.width.equalTo(@13);
        make.height.equalTo(@13);
    }];
    
    
}

-(void)setTypeindex:(NSInteger)typeindex{
    
    _typeindex = typeindex;
    if (self.typeindex == 1) {
        self.chooseBt.hidden = NO;
        [self.chooseBt mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.leading.equalTo(self).offset(0);
            make.width.equalTo(@40);
            make.height.equalTo(@35);
            make.centerY.equalTo(self.containerView);
        }];
    }else {
        self.chooseBt.hidden = YES;
        [self.chooseBt mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.leading.equalTo(self).offset(10);
            make.width.equalTo(@0);
            make.height.equalTo(@0);
            make.centerY.equalTo(self.containerView);
        }];
    }
    
}

-(void)chooseEvent:(UIButton*)sender{
    
    sender.selected = !sender.selected;
    
    [self.delegate selectpay:sender.selected];
}

-(UIButton*)chooseBt{
    if (!_chooseBt) {
        _chooseBt = [[UIButton alloc]init];
        _chooseBt.backgroundColor = [UIColor whiteColor];
        [_chooseBt setImage:[UIImage imageNamed:@"MyTeam_select-n2"] forState:UIControlStateNormal];
        [_chooseBt setImage:[UIImage imageNamed:@"MyTeam_Select-y2"] forState:UIControlStateSelected];
        [_chooseBt addTarget:self action:@selector(chooseEvent:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _chooseBt;
}

-(UIView*)containerView{
    if (!_containerView) {
        _containerView = [[UIView alloc]init];
        _containerView.backgroundColor = [UIColor whiteColor];
    }
    return _containerView;
}

-(UILabel*)storeNameLb{
    if (!_storeNameLb) {
        _storeNameLb = [[UILabel alloc]init];
        _storeNameLb.text = @"你的间距的时刻打打闹闹数学课面对山明";
        _storeNameLb.textColor = LBHexadecimalColor(0x333333);
        _storeNameLb.font = [UIFont systemFontOfSize:14];
    }
    return _storeNameLb;
}

-(UILabel*)timeLb{
    if (!_timeLb) {
        _timeLb = [[UILabel alloc]init];
        _timeLb.text = @"下单时间: 2018-01-15  12:33:33";
        _timeLb.textColor = LBHexadecimalColor(0x666666);
        _timeLb.textAlignment = NSTextAlignmentRight;
        _timeLb.font = [UIFont systemFontOfSize:12];
    }
    return _timeLb;
}

-(UIImageView*)rightimage{
    if (!_rightimage) {
        _rightimage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"rightArrow"]];
        _rightimage.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _rightimage;
}

@end
