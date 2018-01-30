//
//  LB_EatCommentFrameModel.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/1/19.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "LB_EatCommentFrameModel.h"
#import "LB_Eat'commentDataModel.h"


@implementation LB_EatCommentFrameModel

-(void)setHomeInvestModel:(LB_Eat_commentDataModel *)HomeInvestModel{
    _HomeInvestModel = HomeInvestModel;
     CGRect sizeconent=[_HomeInvestModel.comment boundingRectWithSize:CGSizeMake(UIScreenWidth - 70, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil];
    
    self.contentlH = sizeconent.size.height + 100;
    
}

+(NSArray *)getIndustryModels:(NSArray *)infos{
    NSMutableArray *dataArr = [@[]mutableCopy];
    [infos enumerateObjectsUsingBlock:^(LB_Eat_commentDataModel*  _Nonnull dict, NSUInteger idx, BOOL * _Nonnull stop) {
        LB_EatCommentFrameModel *model = [[LB_EatCommentFrameModel alloc]init];
        model.HomeInvestModel = dict;
        [dataArr addObject:model];
        
    }];
    return [dataArr mutableCopy];
}

@end


