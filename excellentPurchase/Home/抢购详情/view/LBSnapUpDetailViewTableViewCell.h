//
//  LBSnapUpDetailViewTableViewCell.h
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/3/22.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LBTmallProductDetailModel.h"

@interface LBSnapUpDetailViewTableViewCell : UITableViewCell

@property (strong , nonatomic)LBTmallProductDetailModel *model;
@property (copy , nonatomic)void(^shareShoInfo)(void);

@end
