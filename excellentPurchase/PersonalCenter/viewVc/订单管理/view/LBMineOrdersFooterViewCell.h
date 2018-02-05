//
//  LBMineOrdersFooterViewCell.h
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/2/4.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LBMineOrderObligationmodel.h"

@interface LBMineOrdersFooterViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *describeLb;
@property (weak, nonatomic) IBOutlet UIButton *button1;
@property (weak, nonatomic) IBOutlet UIButton *button2;

@property (strong , nonatomic)NSIndexPath *indexpath;

@property (copy , nonatomic)void(^clickbuttonOneEvent)(NSIndexPath *indexpath);
@property (copy , nonatomic)void(^clickbuttonTwoEvent)(NSIndexPath *indexpath);

@property (strong , nonatomic)LBMineOrderObligationmodel *model;
@end
