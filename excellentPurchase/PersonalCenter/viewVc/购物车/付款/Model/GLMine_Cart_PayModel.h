//
//  GLMine_Cart_PayModel.h
//  excellentPurchase
//
//  Created by 龚磊 on 2018/1/23.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GLMine_Cart_PayModel : NSObject

@property (nonatomic, copy)NSString *picName;//图片

@property (nonatomic, copy)NSString *title;//支付方式

@property (nonatomic, copy)NSString *detail;//详细秒速

@property (nonatomic, assign)BOOL isSelected;//是否被选中

@end
