//
//  GLStoreInfomationModel.h
//  excellentPurchase
//
//  Created by 龚磊 on 2018/2/4.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GLStoreInfomationModel : NSObject

@property (nonatomic, copy)NSString *store_id;//商铺id
@property (nonatomic, copy)NSString *store_name;//商铺名
@property (nonatomic, copy)NSString *store_pre;//手机地区码
@property (nonatomic, copy)NSString *store_phone;//商铺联系电话
@property (nonatomic, copy)NSString *store_address;//商铺地址
@property (nonatomic, copy)NSString *store_longitude;//商铺经度
@property (nonatomic, copy)NSString *store_latitude;//商铺纬度
@property (nonatomic, copy)NSString *store_license_pic;//营业执照图片

@end
