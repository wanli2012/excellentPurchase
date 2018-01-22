//
//  GLMine_ShoppingCartCell.h
//  excellentPurchase
//
//  Created by 龚磊 on 2018/1/22.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GLMine_ShoppingCartModel.h"

@protocol GLMine_ShoppingCartCellDelegate <NSObject>

- (void)changeStatus:(NSInteger)index;

@end


@interface GLMine_ShoppingCartCell : UITableViewCell

@property (nonatomic, strong)GLMine_ShoppingCartModel *model;

@property (nonatomic, weak)id <GLMine_ShoppingCartCellDelegate> delegate;

@property (nonatomic, assign)NSInteger index;

@end
