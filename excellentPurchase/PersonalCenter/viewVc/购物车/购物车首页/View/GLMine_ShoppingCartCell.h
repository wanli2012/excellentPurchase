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

- (void)changeStatus:(NSInteger)index andSection:(NSInteger)section;

- (void)changeNum:(NSInteger)index andSection:(NSInteger)section andIsAdd:(BOOL)isAdd;

@end


@interface GLMine_ShoppingCartCell : UITableViewCell

@property (nonatomic, strong)GLMine_ShoppingCartModel *model;

@property (nonatomic, weak)id <GLMine_ShoppingCartCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet UITextField *amountTF;//编辑数量

@property (nonatomic, assign)NSInteger section;//组 下标
@property (nonatomic, assign)NSInteger index;//cell 行 下标

@end
