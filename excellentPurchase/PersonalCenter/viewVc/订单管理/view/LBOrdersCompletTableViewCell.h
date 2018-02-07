//
//  LBOrdersCompletTableViewCell.h
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/1/27.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LBMineOrderObligationmodel.h"

@interface LBOrdersCompletTableViewCell : UITableViewCell


@property (strong , nonatomic)LBMineOrderObligationGoodsmodel *model;
@property (strong , nonatomic)NSIndexPath *indexpath;
@property (copy , nonatomic)void(^postComment)(NSIndexPath *indexpath);


@end
