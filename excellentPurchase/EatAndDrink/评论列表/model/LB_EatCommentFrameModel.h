//
//  LB_EatCommentFrameModel.h
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/1/19.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LB_Eat_commentDataModel;


@interface LB_EatCommentFrameModel : NSObject

@property(nonatomic,assign)CGFloat  contentlH;//内容的高度

@property(nonatomic,strong)LB_Eat_commentDataModel *HomeInvestModel;

+(NSArray *)getIndustryModels:(NSArray *)infos;

@end


