//
//  LBShowWinningPictureCell.h
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/5/10.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LBShowWinningPicturemodel.h"

@interface LBShowWinningPictureCell : UITableViewCell

@property (strong , nonatomic)LBShowWinningPicturemodel *model;
@property (copy , nonatomic)void(^bigpicture)(NSInteger index,NSArray *imagerr);

@end
