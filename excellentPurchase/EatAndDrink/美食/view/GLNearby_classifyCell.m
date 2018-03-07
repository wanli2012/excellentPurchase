//
//  GLNearby_classifyCell.m
//  Universialshare
//
//  Created by 龚磊 on 2017/5/15.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "GLNearby_classifyCell.h"
#import "XHStarRateView.h"

@interface GLNearby_classifyCell ()

@property (weak, nonatomic) IBOutlet UIImageView *picImageV;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *starLb;
@property (weak, nonatomic) IBOutlet UIView *starView;
@property (strong, nonatomic) XHStarRateView *starRateView;
@property (weak, nonatomic) IBOutlet UILabel *adressLb;
@property (weak, nonatomic) IBOutlet UILabel *phonelb;
@property (weak, nonatomic) IBOutlet UILabel *scanLb;


@end

@implementation GLNearby_classifyCell

- (void)awakeFromNib {
    [super awakeFromNib];
   
    _starRateView = [[XHStarRateView alloc] initWithFrame:CGRectMake(0, 0, 80, 13)];
    _starRateView.isAnimation = YES;
    _starRateView.rateStyle = IncompleteStar;
    _starRateView.backgroundColor = [UIColor whiteColor];
    _starRateView.currentScore = 4.5;
    [self.starView addSubview:_starRateView];

}

-(void)setModel:(LBEat_cateDataModel *)model{
    _model = model;
    
    [self.picImageV sd_setImageWithURL:[NSURL URLWithString:_model.store_thumb] placeholderImage:[UIImage imageNamed:@"shangpinxiangqing"]];
    self.nameLabel.text = [NSString stringWithFormat:@"%@",_model.store_name];
    self.starLb.text = [NSString stringWithFormat:@"%@分",_model.store_score];
    self.starRateView.currentScore = [_model.store_score floatValue];
    if (_model.p_name.length >0  && _model.s_name.length > 0) {
         self.adressLb.text = [NSString stringWithFormat:@"%@|%@",_model.p_name,_model.s_name];
    }else{
        self.adressLb.text = [NSString stringWithFormat:@"%@%@",_model.p_name,_model.s_name];
    }
   
    self.phonelb.text = [NSString stringWithFormat:@"%@",_model.store_phone];
    if ([_model.limit floatValue] < 100.0) {
        self.distanceLabel.text = [NSString stringWithFormat:@"<%@m",_model.limit];
    }else if ([_model.limit floatValue] >= 1000.0){
        self.distanceLabel.text = [NSString stringWithFormat:@"%.1fkm",[_model.limit floatValue] / 1000.0];
    }else if ([_model.limit floatValue] >= 100.0 && [_model.limit floatValue] < 1000.0){
        self.distanceLabel.text = [NSString stringWithFormat:@"%@m",_model.limit];
    }
    
    if ([_model.store_clicks floatValue] < 10000) {
        self.scanLb.text = [NSString stringWithFormat:@"%@",_model.store_clicks];
    }else if ([_model.store_clicks floatValue] >= 1000){
        self.scanLb.text = [NSString stringWithFormat:@"%.1f万",[_model.store_clicks floatValue] / 10000.0];
    }
}

@end
