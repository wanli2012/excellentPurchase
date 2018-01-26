//
//  GLMine_ShoppingCartGuessCell.h
//  excellentPurchase
//
//  Created by 龚磊 on 2018/1/22.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GLMine_ShoppingCartGuessCellDelegate <NSObject>

- (void)toGoodsDetail:(NSInteger)index;

@end

@interface GLMine_ShoppingCartGuessCell : UITableViewCell

@property (nonatomic, weak)id <GLMine_ShoppingCartGuessCellDelegate>delegate;

@property (nonatomic, assign)NSInteger index;

@end
