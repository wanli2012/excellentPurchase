//
//  GLHomeModel.h
//  excellentPurchase
//
//  Created by 龚磊 on 2018/1/29.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GLHome_bannerModel : NSObject

@property (nonatomic, copy)NSString *banner_id;
@property (nonatomic, copy)NSString *banner_pic;

@end

@interface GLHome_newsModel : NSObject

@property (nonatomic, copy)NSString *news_id;//公告ID
@property (nonatomic, copy)NSString *title;//公告内容

@end

@interface GLHome_ordersModel : NSObject

@property (nonatomic, copy)NSString *title;//公告内容

@end


@interface GLHomeModel : NSObject

@property (nonatomic, copy)NSArray <GLHome_bannerModel *>*banner;
@property (nonatomic, copy)NSArray <GLHome_newsModel *>*news;
@property (nonatomic, copy)NSArray <GLHome_ordersModel *>*orders;

@end
