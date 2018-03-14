//
//  LBMineCenterFlyNoticeModel.h
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/2/7.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
@class LBMineCenterFlyNoticeDetailModel;

@interface LBMineCenterFlyNoticeModel : NSObject

@property (copy , nonatomic)NSString *wl_status;
@property (copy , nonatomic)NSString *wl_num;
@property (copy , nonatomic)NSArray<LBMineCenterFlyNoticeDetailModel*> *wl_info;

@end

@interface LBMineCenterFlyNoticeDetailModel : NSObject

@property (copy , nonatomic)NSString *time;
@property (copy , nonatomic)NSString *status;

@end
