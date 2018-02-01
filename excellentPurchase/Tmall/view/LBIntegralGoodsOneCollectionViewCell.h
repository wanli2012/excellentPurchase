//
//  LBIntegralGoodsOneCollectionViewCell.h
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/10/11.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LBTmallhomepageDataModel.h"

@interface LBIntegralGoodsOneCollectionViewCell : UICollectionViewCell

@property (copy , nonatomic)LBTmallhomepageDataStructureModel *model;

@property (copy , nonatomic)void(^refrshDatasorece)(void);

@end
