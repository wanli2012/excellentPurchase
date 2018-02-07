//
//  LBCommentListsTableViewCell.h
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/1/15.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LBTmallProductDetailModel.h"

@interface LBCommentListsTableViewCell : UITableViewCell

@property (strong , nonatomic)LBTmallProductDetailgoodsCommentModel *model;

@property (strong , nonatomic)NSIndexPath *indexpath;

@property (copy , nonatomic)void(^replyComment)(NSIndexPath *indexpath,NSString *str);

@property (strong , nonatomic)UIButton *replayBt;//回复按钮
@end
