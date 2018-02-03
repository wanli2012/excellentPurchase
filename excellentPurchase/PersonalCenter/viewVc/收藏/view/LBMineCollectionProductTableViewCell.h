//
//  LBMineCollectionProductTableViewCell.h
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/1/23.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LBMineCollectionProductModel.h"

@interface LBMineCollectionProductTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *backView;

@property (copy , nonatomic)void(^addShopCar)(NSIndexPath *indexpath);

@property (strong , nonatomic)NSIndexPath *indexpath;

@property (strong , nonatomic)LBMineCollectionProductModel *model;
@property (weak, nonatomic) IBOutlet UIButton *carbt;

@end
