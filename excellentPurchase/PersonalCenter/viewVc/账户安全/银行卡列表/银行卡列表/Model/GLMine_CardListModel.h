//
//  GLMine_CardListModel.h
//  excellentPurchase
//
//  Created by 龚磊 on 2018/1/28.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GLMine_CardModel : NSObject

@property (nonatomic, copy)NSString *bank_id;//银行卡id
@property (nonatomic, copy)NSString *banknumber;//银行卡号
@property (nonatomic, copy)NSString *is_default;//银行卡是否默认 1:是 2:否
@property (nonatomic, copy)NSString *bank_icon;//银行标识 1 中国农业银行 2 中国工商银行 3 中国建设银行 4 中国邮政银行 5 中国人民银行 6 中国民生银行 7 中国招商银行 8 中国银行 9 平安银行 10 交通银行 11 中信银行 12 兴业银行
@property (nonatomic, copy)NSString *bank_name;//银行名称
@property (nonatomic, copy)NSString *endnumber;//银行卡尾数

@end

@interface GLMine_CardListModel : NSObject

@property (nonatomic, copy)NSString *count;//总条数
@property (nonatomic, copy)NSArray<GLMine_CardModel *> *page_data;

@end
