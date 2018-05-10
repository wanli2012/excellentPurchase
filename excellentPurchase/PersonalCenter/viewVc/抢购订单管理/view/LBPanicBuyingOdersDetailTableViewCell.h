//
//  LBPanicBuyingOdersDetailTableViewCell.h
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/4/18.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LBMyOrdersDetailModel.h"

@interface LBPanicBuyingOdersDetailTableViewCell : UITableViewCell

@property (strong , nonatomic)LBMyOrdersDetailGoodsListModel *model;
@property (copy , nonatomic)void(^gotoReply)(void);
@property (weak, nonatomic) IBOutlet UIButton *replyBT;

@end
