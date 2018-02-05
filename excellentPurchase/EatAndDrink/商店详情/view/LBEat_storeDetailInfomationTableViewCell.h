//
//  LBEat_storeDetailInfomationTableViewCell.h
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/1/18.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LBEat_StoreDetailDataModel.h"

@protocol LBEat_storeDetailInfomationdelegete<NSObject>

-(void)tapgesturecomments;// 点击评论
-(void)ComeStorePay;// 面对面支付
-(void)gotoStoreAdress;//导航

@end

@interface LBEat_storeDetailInfomationTableViewCell : UITableViewCell

@property (nonatomic, assign)id<LBEat_storeDetailInfomationdelegete> delegate;
@property (strong , nonatomic)LBEat_StoreDetailDataModel *model;

@end
