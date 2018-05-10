//
//  GLMine_ShoppingCartfailureHeader.h
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/3/26.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GLMine_ShoppingCartModel.h"

@interface GLMine_ShoppingCartfailureHeader : UIView

@property (weak, nonatomic) IBOutlet UILabel *pastlb;
@property (strong , nonatomic)NSArray<GLMine_ShoppingCartModel *> *dataarr;
@property (copy , nonatomic)void(^refreshData)(void);
@property (strong , nonatomic)id Target;

@end
