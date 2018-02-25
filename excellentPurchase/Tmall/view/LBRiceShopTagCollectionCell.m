//
//  LBRiceShopTagCollectionCell.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/2/25.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "LBRiceShopTagCollectionCell.h"

@interface LBRiceShopTagCollectionCell()
@property (weak, nonatomic) IBOutlet UIImageView *imagev;
@property (weak, nonatomic) IBOutlet UILabel *titleLb;

@end

@implementation LBRiceShopTagCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}

-(void)setModel:(LBTmallSeconedClassifyModel *)model{
    _model = model;
    [self.imagev sd_setImageWithURL:[NSURL URLWithString:_model.cate_img] placeholderImage: [UIImage imageNamed:@"shangpinxiangqing"]];
    self.titleLb.text = _model.catename;
}

@end
