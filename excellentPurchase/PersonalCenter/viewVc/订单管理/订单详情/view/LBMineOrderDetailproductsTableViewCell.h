//
//  LBMineOrderDetailproductsTableViewCell.h
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/1/22.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LBMineSureOrdersModel.h"

@interface LBMineOrderDetailproductsTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *replayBt;
@property (strong , nonatomic)LBMineSureOrdersGoodInfoModel *model;

@end
