//
//  GLMine_Message_PropertyModel.h
//  excellentPurchase
//
//  Created by 龚磊 on 2018/1/20.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GLMine_Message_PropertyModel : NSObject

//@property (nonatomic, copy)NSString *changeType;//变动类型
//@property (nonatomic, copy)NSString *date;//日期
//@property (nonatomic, copy)NSString *orderNum;//订单号
//@property (nonatomic, copy)NSString *amount;//数额
//@property (nonatomic, copy)NSString *goodsName;//商品名字

@property (nonatomic, copy)NSString *log_id;//消息ID
@property (nonatomic, copy)NSString *log_content;//信息
@property (nonatomic, copy)NSString *log_money;//积分数量
@property (nonatomic, copy)NSString *log_addtime;//添加时间
@property (nonatomic, copy)NSString *log_is_read;//是否阅读
@property (nonatomic, copy)NSString *sign;//0:资金流出 1:资金流入
@property (nonatomic, copy)NSString *action;//操作



@end
