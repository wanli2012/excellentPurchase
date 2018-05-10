//
//  LBTodayTimeLimitModel.h
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/3/28.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
@class LBTodayTimeLimitActiveModel;
@class LBTodayBuyingTimeLimitActiveModel;
@class LBTodayWatTimeLimitActiveModel;
@class LBTodayBuyingListTimeLimitActiveModel;

typedef NS_ENUM(NSUInteger, LBTodayTimeLimitCellType) {
    LBTodayTimeLimitCellTypeBeing = 0,
    LBTodayTimeLimitCellTypeWating
};

@interface LBTodayTimeLimitModel : NSObject

@property (copy , nonatomic)NSArray<LBTodayWatTimeLimitActiveModel*> *wait;
@property (strong , nonatomic)LBTodayBuyingTimeLimitActiveModel *buying;

@end

@interface LBTodayTimeLimitActiveModel : NSObject

@property (copy , nonatomic)NSString *challenge_id;
@property (copy , nonatomic)NSString *challenge_end_time;
@property (copy , nonatomic)NSString *goods_id;
@property (copy , nonatomic)NSString *goods_name;
@property (copy , nonatomic)NSString *thumb;
@property (copy , nonatomic)NSString *channel;
@property (copy , nonatomic)NSString *rewardcounpons;
@property (copy , nonatomic)NSString *maa_status;
@property (copy , nonatomic)NSString *challenge_alowd_num;
@property (copy , nonatomic)NSString *marketprice;
@property (copy , nonatomic)NSString *costprice;

@end

@interface LBTodayBuyingTimeLimitActiveModel : NSObject

@property (copy , nonatomic)NSString *end_time;
@property (copy , nonatomic)NSString *now_time;
@property (assign , nonatomic)LBTodayTimeLimitCellType   cellType;
@property (copy , nonatomic)NSArray<LBTodayBuyingListTimeLimitActiveModel*> *data;

@end

@interface LBTodayBuyingListTimeLimitActiveModel : NSObject

@property (copy , nonatomic)NSString *challenge_id;
@property (copy , nonatomic)NSString *challenge_end_time;
@property (copy , nonatomic)NSString *goods_id;
@property (copy , nonatomic)NSString *goods_name;
@property (copy , nonatomic)NSString *thumb;
@property (copy , nonatomic)NSString *channel;
@property (copy , nonatomic)NSString *rewardcounpons;
@property (copy , nonatomic)NSString *marketprice;
@property (copy , nonatomic)NSString *costprice;
@property (copy , nonatomic)NSString *challenge_alowd_num;
@property (copy , nonatomic)NSString *sale_count;
@property (copy , nonatomic)NSString *start_time_chinese;

@end

@interface LBTodayWatTimeLimitActiveModel : NSObject

@property (copy , nonatomic)NSString *time;
@property (copy , nonatomic)NSString *start;
@property (copy , nonatomic)NSString *start_time;
@property (assign , nonatomic)LBTodayTimeLimitCellType   cellType;
@property (copy , nonatomic)NSArray<LBTodayTimeLimitActiveModel*> *active;

@end
