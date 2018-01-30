//
//  LBHorseRaceLampCell.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/1/9.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "LBHorseRaceLampCell.h"

@interface LBHorseRaceLampCell()

///**
// 标题图片
// */
//@property (weak, nonatomic) IBOutlet UIImageView *titltImage;

/**
 商品展示图片
 */
@property (weak, nonatomic) IBOutlet UIImageView *goodsImage;

/**
 内容距离商品图片的间距
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentLeadIng;

@end

@implementation LBHorseRaceLampCell

- (void)awakeFromNib {
    [super awakeFromNib];
   
}


-(void)setModel:(LBHorseRaceLampModel *)model{
    
    _model = model;
    self.contentLb.text = model.contentstr;

}

@end
