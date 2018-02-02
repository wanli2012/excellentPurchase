//
//  LBIntegralGoodsTwoCollectionViewCell.h
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/1/13.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LBTmallhomepageDataModel.h"

@interface LBIntegralGoodsTwoCollectionViewCell : UICollectionViewCell

@property (copy , nonatomic)LBTmallhomepageDataStructureModel *model;

@property (copy , nonatomic)void(^refrshDatasorece)(void);

@property (weak, nonatomic) IBOutlet UILabel *scanNum;

@end
