//
//  LBMineOrdersDetailHeaderView.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/1/23.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "LBMineOrdersDetailHeaderView.h"

@interface LBMineOrdersDetailHeaderView()

@property (strong , nonatomic)UILabel *storeLb;//店名
@property (strong , nonatomic)UILabel *statusLb;//描述
@property (strong , nonatomic)UIView *lineview;//

@end

@implementation LBMineOrdersDetailHeaderView

-(instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self initInterFace];//初始化界面
    }
    return self;
}

-(void)initInterFace{
    [self addSubview:self.statusLb];
    [self addSubview:self.storeLb];
    [self addSubview:self.lineview];
    
    [self.statusLb mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.trailing.equalTo(self).offset(-10);
        make.centerY.equalTo(self);
    }];
    
    [self.storeLb mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.trailing.equalTo(self.statusLb.mas_leading).offset(-10);
        make.leading.equalTo(self).offset(10);
        make.centerY.equalTo(self);
    }];
    
    [self.lineview mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.trailing.equalTo(self).offset(0);
        make.leading.equalTo(self).offset(0);
        make.bottom.equalTo(self).offset(-1);
        make.height.equalTo(@1);
    }];
}

-(UILabel*)storeLb{
    if (!_storeLb) {
        _storeLb = [[UILabel alloc]init];
        _storeLb.text = @"吕兵的店";
        _storeLb.textColor = LBHexadecimalColor(0x333333);
        _storeLb.font = [UIFont systemFontOfSize:13];
        _storeLb.textAlignment = NSTextAlignmentLeft;
    }
    return _storeLb;
}

-(UILabel*)statusLb{
    if (!_statusLb) {
        _statusLb = [[UILabel alloc]init];
        _statusLb.text = @"交易完成";
        _statusLb.textColor = MAIN_COLOR;
        _statusLb.font = [UIFont systemFontOfSize:13];
        _statusLb.textAlignment = NSTextAlignmentRight;
    }
    return _statusLb;
}

-(UIView*)lineview{
    if (!_lineview) {
        _lineview = [[UIView alloc]init];
        _lineview.backgroundColor = [UIColor groupTableViewBackgroundColor];
    }
    return _lineview;
}

@end
