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


@end
