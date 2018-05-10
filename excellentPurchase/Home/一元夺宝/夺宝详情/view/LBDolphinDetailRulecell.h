//
//  LBDolphinDetailRulecell.h
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/5/8.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LBHomeOneDolphinDetailmodel.h"

@interface LBDolphinDetailRulecell : UITableViewCell

@property (strong , nonatomic)LBHomeOneDolphinDetailmodel *model;
@property (weak, nonatomic) IBOutlet UILabel *titilelb;

@end
