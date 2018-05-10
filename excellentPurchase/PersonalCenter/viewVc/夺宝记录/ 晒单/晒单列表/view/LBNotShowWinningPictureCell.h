//
//  LBNotShowWinningPictureCell.h
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/5/10.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LBNotShowWinningPicturemodel.h"

@interface LBNotShowWinningPictureCell : UITableViewCell

@property (copy , nonatomic)void(^jumpShowpic)(LBNotShowWinningPicturemodel *model);
@property (strong , nonatomic)LBNotShowWinningPicturemodel *model;

@end
