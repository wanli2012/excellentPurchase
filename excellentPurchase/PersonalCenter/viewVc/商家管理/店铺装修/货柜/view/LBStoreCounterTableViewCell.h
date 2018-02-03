//
//  LBStoreCounterTableViewCell.h
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/1/25.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GLStoreCounterModel.h"

@protocol LBStoreCounterdelegete<NSObject>

-(void)saleOutProduct:(NSInteger)index;
-(void)EditProduct:(NSInteger)index;

@end

@interface LBStoreCounterTableViewCell : UITableViewCell

@property (weak , nonatomic)id<LBStoreCounterdelegete>  delegete;
@property (assign , nonatomic)NSInteger rowindex;
@property (nonatomic, strong)GLStoreCounter_goodsModel *model;

@end
