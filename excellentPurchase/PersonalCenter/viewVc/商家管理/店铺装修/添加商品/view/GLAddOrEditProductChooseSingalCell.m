//
//  GLAddOrEditProductChooseSingalCell.m
//  excellentPurchase
//
//  Created by 龚磊 on 2018/2/2.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "GLAddOrEditProductChooseSingalCell.h"

@implementation GLAddOrEditProductChooseSingalCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setBrandModel:(GLAddOrEditProductCate_brandModel *)brandModel{
    _brandModel = brandModel;
    self.titleLabel.text = brandModel.brand_name;
    
}

- (void)setLabeModel:(GLAddOrEditProductCate_labeModel *)labeModel{
    _labeModel = labeModel;
    self.titleLabel.text = labeModel.label_name;
}

- (void)setAttrModel:(GLAddOrEditProductCate_attrModel *)attrModel{
    _attrModel = attrModel;
    self.titleLabel.text = attrModel.attr_info;
}

@end
