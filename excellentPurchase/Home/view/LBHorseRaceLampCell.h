//
//  LBHorseRaceLampCell.h
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/1/9.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LBHorseRaceLampModel.h"

@interface LBHorseRaceLampCell : UITableViewCell

@property (strong , nonatomic)LBHorseRaceLampModel *model;

@property (strong , nonatomic)NSIndexPath *indexpath;

/**
 展示内容
 */
@property (weak, nonatomic) IBOutlet UILabel *contentLb;

@end
