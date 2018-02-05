//
//  LBMineSureOrdermessageTableViewCell.h
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/1/23.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LBMineSureOrdersModel.h"

@interface LBMineSureOrdermessageTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *placeholderLb;

@property (strong , nonatomic)NSIndexPath *indexpath;

@property (copy , nonatomic)void(^returntextview)(NSString *text , NSIndexPath *indexpath);

@end
