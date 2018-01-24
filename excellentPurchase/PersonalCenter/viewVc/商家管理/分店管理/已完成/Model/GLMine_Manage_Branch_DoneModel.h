//
//  GLMine_Manage_Branch_DoneModel.h
//  excellentPurchase
//
//  Created by 龚磊 on 2018/1/24.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GLMine_Manage_Branch_DoneModel : NSObject

@property (nonatomic, copy)NSString *storeName;//店铺名
@property (nonatomic, copy)NSString *picName;//图片
@property (nonatomic, copy)NSString *account;//账号
@property (nonatomic, copy)NSString *type;//类型
@property (nonatomic, copy)NSString *month_Money;//当月销售额
@property (nonatomic, copy)NSString *total_Money;//累计销售额

@end
