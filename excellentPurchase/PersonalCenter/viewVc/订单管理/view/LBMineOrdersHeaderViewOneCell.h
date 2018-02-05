//
//  LBMineOrdersHeaderViewOneCell.h
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/2/4.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LBMineOrderObligationmodel.h"

@interface LBMineOrdersHeaderViewOneCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *storeName;
@property (weak, nonatomic) IBOutlet UILabel *timeLb;
@property (weak, nonatomic) IBOutlet UIButton *selectBt;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *selectBtW;

@property (strong , nonatomic)LBMineOrderObligationmodel *model;

@property (strong , nonatomic)NSIndexPath *indexpath;

@property (copy , nonatomic)void(^refreshfata)(NSIndexPath *indexpath);
@end
