//
//  GLAddOrEditProductChooseSingalCell.h
//  excellentPurchase
//
//  Created by 龚磊 on 2018/2/2.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GLAddOrEditProductCateModel.h"

@interface GLAddOrEditProductChooseSingalCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (nonatomic, strong)GLAddOrEditProductCate_brandModel *brandModel;
@property (nonatomic, strong)GLAddOrEditProductCate_labeModel *labeModel;
@property (nonatomic, strong)GLAddOrEditProductCate_attrModel *attrModel;

@end
