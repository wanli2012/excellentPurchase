//
//  LBMineOrdersFooterView.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/1/22.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "LBMineOrdersFooterView.h"

@interface LBMineOrdersFooterView()

@property (strong , nonatomic)UILabel *resonLb;//取消原因
@property (strong , nonatomic)UILabel *moneyLb;//总价
@property (strong , nonatomic)UIView *lineview;//
@property (strong , nonatomic)UIView *lineview1;//
@property (strong , nonatomic)UIButton *Btone;
@property (strong , nonatomic)UIButton *BtTwo;
@end

@implementation LBMineOrdersFooterView

-(instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self initInterFace];//初始化界面
    }
    return self;
}

-(void)initInterFace{
    [self addSubview:self.moneyLb];
    [self addSubview:self.lineview];
    [self addSubview:self.Btone];
    [self addSubview:self.resonLb];
    [self addSubview:self.lineview1];
    [self addSubview:self.BtTwo];
    
    [self.moneyLb mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.trailing.equalTo(self).offset(-10);
        make.leading.equalTo(self).offset(10);
        make.top.equalTo(self).offset(10);
    }];
    
    [self.lineview mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.trailing.equalTo(self).offset(0);
        make.leading.equalTo(self).offset(0);
        make.top.equalTo(self.moneyLb.mas_bottom).offset(10);
        make.height.equalTo(@1);
    }];
    
    [self.Btone mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.trailing.equalTo(self).offset(-10);
        make.top.equalTo(self.lineview).offset(10);
        make.height.equalTo(@30);
        make.width.equalTo(@80);
    }];
    
    [self.resonLb mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.trailing.equalTo(self.Btone.mas_leading).offset(-10);
        make.leading.equalTo(self).offset(10);
         make.centerY.equalTo(self.Btone);
    }];
    
    [self.lineview1 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.trailing.equalTo(self).offset(0);
        make.leading.equalTo(self).offset(0);
        make.bottom.equalTo(self).offset(0);
        make.height.equalTo(@5);
    }];
    
    [self.BtTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.trailing.equalTo(self.Btone.mas_leading).offset(-10);
        make.height.equalTo(@30);
        make.width.equalTo(@80);
        make.centerY.equalTo(self.Btone);
    }];
    
}

-(void)setTypeindex:(NSInteger)typeindex{
    
    _typeindex = typeindex;
    if (self.typeindex == 1) {
        self.resonLb.hidden = YES;
        self.BtTwo.hidden = NO;
        [self.BtTwo setTitle:@"取消订单" forState:UIControlStateNormal];
        [self.Btone setTitle:@"去付款" forState:UIControlStateNormal];
    }else if (self.typeindex == 2){
        self.resonLb.hidden = YES;
        self.BtTwo.hidden = NO;
        [self.BtTwo setTitle:@"查看物流" forState:UIControlStateNormal];
        [self.Btone setTitle:@"确认收货" forState:UIControlStateNormal];
    }else if (self.typeindex == 3){
        self.resonLb.hidden = YES;
        self.BtTwo.hidden = NO;
        [self.BtTwo setTitle:@"查看物流" forState:UIControlStateNormal];
        [self.Btone setTitle:@"待评价" forState:UIControlStateNormal];
    }else if (self.typeindex == 4){
        self.resonLb.hidden = NO;
        self.BtTwo.hidden = YES;
        [self.Btone setTitle:@"重新下单" forState:UIControlStateNormal];
    }
    
}

-(UILabel*)moneyLb{
    if (!_moneyLb) {
        _moneyLb = [[UILabel alloc]init];
        _moneyLb.text = @"共1件商品，合计¥100000 (含运费5元)";
        _moneyLb.textColor = LBHexadecimalColor(0x808080);
        _moneyLb.font = [UIFont systemFontOfSize:12];
        _moneyLb.textAlignment = NSTextAlignmentRight;
    }
    return _moneyLb;
}

-(UIView*)lineview{
    if (!_lineview) {
        _lineview = [[UIView alloc]init];
        _lineview.backgroundColor = [UIColor groupTableViewBackgroundColor];
    }
    return _lineview;
}
-(UIButton*)Btone{
    if (!_Btone) {
        _Btone = [[UIButton alloc]init];
        _Btone.backgroundColor = MAIN_COLOR;
        [_Btone setTitle:@"重新下单" forState:UIControlStateNormal];
        [_Btone setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _Btone.titleLabel.font = [UIFont systemFontOfSize:14];
        _Btone.layer.cornerRadius = 15;
        _Btone.clipsToBounds = YES;
        [_Btone addTarget:self action:@selector(chooseEvent:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _Btone;
}

-(UIButton*)BtTwo{
    if (!_BtTwo) {
        _BtTwo = [[UIButton alloc]init];
        _BtTwo.backgroundColor = MAIN_COLOR;
        [_BtTwo setTitle:@"重新下单" forState:UIControlStateNormal];
        [_BtTwo setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _BtTwo.titleLabel.font = [UIFont systemFontOfSize:14];
        _BtTwo.layer.cornerRadius = 15;
        _BtTwo.clipsToBounds = YES;
        [_BtTwo addTarget:self action:@selector(chooseEvent:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _BtTwo;
}

-(UILabel*)resonLb{
    if (!_resonLb) {
        _resonLb = [[UILabel alloc]init];
        _resonLb.text = @"取消原因: 尽其所能走起现实物品重庆批次弄破";
        _resonLb.textColor = LBHexadecimalColor(0x333333);
        _resonLb.font = [UIFont systemFontOfSize:13];
    }
    return _resonLb;
}
-(UIView*)lineview1{
    if (!_lineview1) {
        _lineview1 = [[UIView alloc]init];
        _lineview1.backgroundColor = [UIColor groupTableViewBackgroundColor];
    }
    return _lineview1;
}
@end
