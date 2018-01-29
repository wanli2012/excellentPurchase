//
//  GLMine_AddressModel.h
//  excellentPurchase
//
//  Created by 龚磊 on 2018/1/29.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GLMine_AddressModel : NSObject

@property (nonatomic, copy)NSString *address_id;//收货地址ID
@property (nonatomic, copy)NSString *truename; //真实名字
@property (nonatomic, copy)NSString *phone; //电话号码
@property (nonatomic, copy)NSString *is_default;  //是否默认  1是 0否
@property (nonatomic, copy)NSString *address_province;//省
@property (nonatomic, copy)NSString *address_city;  //市
@property (nonatomic, copy)NSString *address_area; //区
@property (nonatomic, copy)NSString *address_address;//详细地址

@end
