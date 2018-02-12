//
//  LBEat_cateModel.h
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/1/28.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LBEat_cateModel : NSObject

@property (nonatomic, copy)NSString *cate_id;
@property (nonatomic, copy)NSString *catename;
@property (nonatomic, copy)NSArray *cate_banners;//图片

+(LBEat_cateModel*)defaultUser;
@end
