//
//  GLMine_Manage_Branch_ApplyCell.h
//  excellentPurchase
//
//  Created by 龚磊 on 2018/1/24.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GLMine_Manage_Branch_DoneModel.h"

@protocol GLMine_Manage_Branch_ApplyCellDelegate <NSObject>

@optional
//取消申请
- (void)cancelApply:(NSInteger)index;
//解冻账号
- (void)unfrezzAccount:(NSInteger)index;

@end

@interface GLMine_Manage_Branch_ApplyCell : UITableViewCell

@property (nonatomic, strong)GLMine_Manage_Branch_DoneModel *model;

@property (nonatomic, weak)id <GLMine_Manage_Branch_ApplyCellDelegate> delegate;

@end
