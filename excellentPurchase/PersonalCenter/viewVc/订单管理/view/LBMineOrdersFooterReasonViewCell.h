//
//  LBMineOrdersFooterReasonViewCell.h
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/2/5.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LBMineOrderObligationmodel.h"

@interface LBMineOrdersFooterReasonViewCell : UITableViewCell

@property (strong , nonatomic)LBMineOrderObligationmodel *model;
@property (weak, nonatomic) IBOutlet UILabel *describeLb;
@property (weak, nonatomic) IBOutlet UILabel *reasonlb;

@end
