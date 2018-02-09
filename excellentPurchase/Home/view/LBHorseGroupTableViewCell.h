//
//  LBHorseGroupTableViewCell.h
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/1/9.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GLHomeModel.h"


@protocol LBHorseGroupTableViewCellDelegate <NSObject>

//跳转到详情
- (void)toDetail:(NSInteger)index infoIndex:(NSInteger)infoIndex;

@end

@interface LBHorseGroupTableViewCell : UITableViewCell

@property (strong , nonatomic)UIImageView *imagev;
@property (nonatomic, assign)NSInteger index;

@property (nonatomic, copy)NSArray<GLHome_newsModel *> *newsModels;
@property (nonatomic, copy)NSArray <GLHome_ordersModel *>*orderModels;

@property (nonatomic, weak)id <LBHorseGroupTableViewCellDelegate>delegate;

@end

