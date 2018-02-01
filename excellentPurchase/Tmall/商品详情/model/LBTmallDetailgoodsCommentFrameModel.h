//
//  LBTmallDetailgoodsCommentFrameModel.h
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/2/1.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LBTmallProductDetailModel.h"

@interface LBTmallDetailgoodsCommentFrameModel : NSObject

@property(nonatomic,assign)CGFloat  cellH;//评论cell的高度

@property(nonatomic,strong)LBTmallProductDetailgoodsCommentModel *CommentModel;

+(NSArray *)getIndustryModels:(NSArray *)infos;

@end
