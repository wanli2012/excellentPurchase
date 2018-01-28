//
//  LBSaveLocationInfoModel.h
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/1/27.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LBSaveLocationInfoModel : NSObject

@property (nonatomic,copy)    NSString *currentCity;//城市
@property (nonatomic,copy)    NSString *strLatitude;//经度
@property (nonatomic,copy)    NSString *strLongitude;//维度

@property (nonatomic,copy)    NSString *cityid;//城市id

+(LBSaveLocationInfoModel*)defaultUser;

@end
