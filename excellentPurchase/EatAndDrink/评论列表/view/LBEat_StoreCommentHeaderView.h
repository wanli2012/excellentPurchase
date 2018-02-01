//
//  LBEat_StoreCommentHeaderView.h
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/1/19.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LB_EatCommentFrameModel.h"


@interface LBEat_StoreCommentHeaderView : UITableViewHeaderFooterView

@property(nonatomic,strong)LB_EatCommentFrameModel *HomeInvestModel;

@property (copy , nonatomic)void(^showComments)(NSInteger section);

@property (copy , nonatomic)void(^pushCommentsListVc)(void);

@property (assign , nonatomic)NSInteger section;

@end
