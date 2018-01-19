//
//  LBEat_storeDetailInfomationTableViewCell.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/1/18.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "LBEat_storeDetailInfomationTableViewCell.h"
#import "XHStarRateView.h"

@interface LBEat_storeDetailInfomationTableViewCell()

@property (weak, nonatomic) IBOutlet UIView *starView;
@property (strong, nonatomic) XHStarRateView *starRateView;
@property (weak, nonatomic) IBOutlet UIView *commentView;//评论view

@end

@implementation LBEat_storeDetailInfomationTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];

    _starRateView = [[XHStarRateView alloc] initWithFrame:CGRectMake(0, 0, 80, 13)];
    _starRateView.isAnimation = YES;
    _starRateView.rateStyle = IncompleteStar;
    _starRateView.backgroundColor = [UIColor whiteColor];
    _starRateView.currentScore = 3.0;
    [self.starView addSubview:_starRateView];
    
    UITapGestureRecognizer *tapgesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapgesturecomments)];
    [self.commentView addGestureRecognizer:tapgesture];
}

-(void)tapgesturecomments{
    [self.delegate tapgesturecomments];
}

@end
