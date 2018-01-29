//
//  LBImmediateRushBuyCollectionViewCell.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/1/9.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "LBImmediateRushBuyCollectionViewCell.h"
#import "UIButton+SetEdgeInsets.h"

@interface LBImmediateRushBuyCollectionViewCell ()

/**立即抢购按钮*/
@property (weak, nonatomic) IBOutlet UIButton *buyBt;

/**秒杀图片*/
@property (weak, nonatomic) IBOutlet UIImageView *skillImage;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *killImageHeight;
@property (weak, nonatomic) IBOutlet UILabel *goodsNameLabel;//商品名字
@property (weak, nonatomic) IBOutlet UILabel *subNameLabel;

@end

@implementation LBImmediateRushBuyCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.buyBt.layer.cornerRadius = 8;
    [self.buyBt horizontalCenterTitleAndImage:5];
    
    //图片自适应宽度
//    [self.skillImage setContentScaleFactor:[[UIScreen mainScreen] scale]];
//    self.skillImage.contentMode = UIViewContentModeScaleAspectFill;
//    self.skillImage.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    [self.goodsNameLabel setFont:[UIFont systemFontOfSize:CZH_ScaleWidth(15)]];
    self.subNameLabel.font = [UIFont systemFontOfSize:CZH_ScaleWidth(12)];
    self.killImageHeight.constant = CZH_ScaleWidth(15);
    

}

@end
