//
//  LBPanicOrdersHeaderrView.h
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/4/17.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LBPanicBuyingOdersModel.h"

@interface LBPanicOrdersHeaderrView : UITableViewHeaderFooterView

@property (strong , nonatomic)UILabel *label;
@property (strong , nonatomic)UIImageView *imagev;
@property (copy , nonatomic)void(^jumpmerchat)(NSString *store_id);
@property (strong , nonatomic)LBPanicBuyingOdersGoodsModel *model;
@end
