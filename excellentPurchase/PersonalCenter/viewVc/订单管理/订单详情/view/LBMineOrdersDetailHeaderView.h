//
//  LBMineOrdersDetailHeaderView.h
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/1/23.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LBMyOrdersDetailModel.h"

@interface LBMineOrdersDetailHeaderView : UITableViewHeaderFooterView

@property (strong , nonatomic)UILabel *storeLb;//店名
@property (strong , nonatomic)UILabel *statusLb;//描述

@property (strong , nonatomic)LBMyOrdersDetailModel *model;

@end
