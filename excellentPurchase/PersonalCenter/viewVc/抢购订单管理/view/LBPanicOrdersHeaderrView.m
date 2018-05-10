//
//  LBPanicOrdersHeaderrView.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/4/17.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "LBPanicOrdersHeaderrView.h"

@interface LBPanicOrdersHeaderrView()


@end

@implementation LBPanicOrdersHeaderrView

-(instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [self initInterFace];//初始化界面
    }
    return self;
}

-(void)initInterFace{
    [self addSubview:self.label];
    [self addSubview:self.imagev];
    
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self).offset(10);
        make.centerY.equalTo(self);
    }];
    
    [self.imagev mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.label.mas_trailing).offset(10);
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(8, 8));
    }];
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapgeturemerchat)];
    [self.label addGestureRecognizer:gesture];
    
}
-(void)setModel:(LBPanicBuyingOdersGoodsModel *)model{
    _model = model;
    
    switch ([_model.store_type integerValue]) {
        case 1://厂家直供
        case 2://产地直供
        case 3://品牌加盟
        case 4://微商清仓
            self.label.text = [NSString stringWithFormat:@"%@",_model.store_name];
            self.imagev.hidden = NO;
            if ([NSString StringIsNullOrEmpty:self.label.text]) {
                self.label.text = @"商家暂无名称";
            }
            break;
        case 5://自营商城
            self.label.text = @"自营商城";
            self.imagev.hidden = YES;
            break;
        case 6://顺道商城
            self.label.text = @"顺道商城";
            self.imagev.hidden = YES;
            break;
        default:
            self.label.text = @"商家暂无名称";
            self.imagev.hidden = YES;
            break;
    }
    
}

-(void)tapgeturemerchat{
    switch ([_model.store_type integerValue]) {
        case 1://厂家直供
        case 2://产地直供
        case 3://品牌加盟
        case 4://微商清仓
            if (self.jumpmerchat) {
                self.jumpmerchat(_model.store_id);
            }
        case 5://自营商城
           
            break;
        case 6://顺道商城
    
            break;
        default:
            break;
    }
   
}

-(UILabel*)label{
    if (!_label) {
        _label = [[UILabel alloc]init];
        _label.font = [UIFont systemFontOfSize:14];
        _label.textColor = [UIColor darkGrayColor];
        _label.backgroundColor = [UIColor clearColor];
        _label.userInteractionEnabled = YES;
    }
    return _label;
}

-(UIImageView*)imagev{
    if (!_imagev) {
        _imagev = [[UIImageView alloc]init];
        _imagev.image = [UIImage imageNamed:@"jion"];
        _imagev.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _imagev;
}

@end
