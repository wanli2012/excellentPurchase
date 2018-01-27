//
//  LBShopProductClassifyMenuReusableView.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/1/26.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "LBShopProductClassifyMenuReusableView.h"
#import "UIButton+SetEdgeInsets.h"

@interface LBShopProductClassifyMenuReusableView()

@property (weak, nonatomic) IBOutlet UIButton *priceBt;
@property (weak, nonatomic) IBOutlet UIButton *allbt;
@property (weak, nonatomic) IBOutlet UIButton *salebt;
@property (weak, nonatomic) IBOutlet UIButton *reputationBt;

@property (strong, nonatomic) UIButton *currentBt;

@end

@implementation LBShopProductClassifyMenuReusableView

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.priceBt horizontalCenterTitleAndImage:5];
    self.currentBt = self.allbt;
}

- (IBAction)allEvent:(UIButton *)sender {
    self.currentBt.selected = NO;
    sender.selected = YES;
    self.currentBt = sender;
}
- (IBAction)saleEvent:(UIButton *)sender {
    self.currentBt.selected = NO;
    sender.selected = YES;
    self.currentBt = sender;
    
}
- (IBAction)priceEvnt:(UIButton *)sender {
    self.currentBt.selected = NO;
    sender.selected = YES;
    self.currentBt = sender;
    
}
- (IBAction)reputationEvent:(UIButton *)sender {
    self.currentBt.selected = NO;
    sender.selected = YES;
    self.currentBt = sender;
    
}


@end
