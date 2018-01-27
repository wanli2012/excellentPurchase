//
//  LBShopProductClassifyReusableView.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/1/26.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "LBShopProductClassifyReusableView.h"
#import "JYCarousel.h"

@interface LBShopProductClassifyReusableView()

@property (weak, nonatomic) IBOutlet UIView *bannerView;
/**
 头部轮播
 */
@property (nonatomic, strong) JYCarousel *carouselView;

@end

@implementation LBShopProductClassifyReusableView

- (void)awakeFromNib {
    [super awakeFromNib];
 
     NSMutableArray *imageArray = [[NSMutableArray alloc] initWithArray: @[@"eat-picture1",@"eat-picture1"]];
    
    [self.bannerView addSubview:self.carouselView];
    //开始轮播
    [_carouselView startCarouselWithArray:imageArray];
    
}

-(JYCarousel*)carouselView{
    if (!_carouselView) {
        _carouselView= [[JYCarousel alloc] initWithFrame:CGRectMake(0, 0, UIScreenWidth, UIScreenWidth / 2.0) configBlock:^JYConfiguration *(JYConfiguration *carouselConfig) {
            carouselConfig.pageContollType = LabelPageControl;
            carouselConfig.interValTime = 3;
            return carouselConfig;
        } clickBlock:^(NSInteger index) {
            NSLog(@"%ld",index);
        }];
    }
    
     return _carouselView;
}


@end
