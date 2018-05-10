//
//  LBDolphincalculateDetailmodel.h
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/5/9.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
@class LBDolphincalculateDetailListmodel;

@interface LBDolphincalculateDetailmodel : NSObject

@property (copy , nonatomic)NSString *count;
@property (copy , nonatomic)NSString *except;
@property (copy , nonatomic)NSString *number;
@property (copy , nonatomic)NSString *stamp;
@property (copy , nonatomic)NSString *status;
@property (copy , nonatomic)NSString *code;
@property (copy , nonatomic)NSArray<LBDolphincalculateDetailListmodel*> *page_data;

@end

@interface LBDolphincalculateDetailListmodel : NSObject

@property (copy , nonatomic)NSString *lucky_number;
@property (copy , nonatomic)NSString *nickname;
@property (copy , nonatomic)NSString *times;

@end
