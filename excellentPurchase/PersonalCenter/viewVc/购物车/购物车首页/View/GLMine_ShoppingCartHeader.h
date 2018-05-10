//
//  GLMine_ShoppingCartHeader.h
//  excellentPurchase
//
//  Created by 龚磊 on 2018/1/22.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GLMine_ShoppingCartModel.h"

@protocol GLMine_ShoppingCartHeaderDelegate <NSObject>

- (void)goToStore:(NSInteger)section;
- (void)selectStoreGoods:(NSInteger)section;

@end

@interface GLMine_ShoppingCartHeader : UIView

@property (nonatomic, weak)id <GLMine_ShoppingCartHeaderDelegate>delegate;

@property (weak, nonatomic) IBOutlet UIImageView *signImageV;

@property (nonatomic, strong)GLMine_ShoppingCartModel *model;

@property (assign , nonatomic)BOOL  ishidesignImageV;

@property (nonatomic, assign)NSInteger section;

@end
