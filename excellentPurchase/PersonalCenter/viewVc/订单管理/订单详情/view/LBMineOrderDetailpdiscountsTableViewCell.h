//
//  LBMineOrderDetailpdiscountsTableViewCell.h
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/1/22.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LBMyOrdersDetailModel.h"

@interface LBMineOrderDetailpdiscountsTableViewCell : UITableViewCell

@property (strong , nonatomic)LBMyOrdersDetailModel *model;
@property (weak, nonatomic) IBOutlet UILabel *discountlb;
@property (weak, nonatomic) IBOutlet UILabel *allpricelb;


@end
