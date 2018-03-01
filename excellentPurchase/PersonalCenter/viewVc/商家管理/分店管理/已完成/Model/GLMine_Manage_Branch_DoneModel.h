//
//  GLMine_Manage_Branch_DoneModel.h
//  excellentPurchase
//
//  Created by 龚磊 on 2018/1/24.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GLMine_Manage_Branch_DoneModel : NSObject

@property (nonatomic, copy)NSString *sname;//店铺名
@property (nonatomic, copy)NSString *thumb;//图片
@property (nonatomic, copy)NSString *uname;//账号
@property (nonatomic, copy)NSString *type;//类型 收益类型 1收益自营 2其它店铺收益
@property (nonatomic, copy)NSString *fullmoon;//当月销售额
@property (nonatomic, copy)NSString *goodsmoney;//累计销售额

@property (nonatomic, copy)NSString *reason;//失败原因
@property (nonatomic, copy)NSString *sid;//商铺id

@property (nonatomic, assign)NSInteger controllerType;//1:申请中 0:已冻结
@property (nonatomic, assign)NSInteger index;//cell下标

@end
