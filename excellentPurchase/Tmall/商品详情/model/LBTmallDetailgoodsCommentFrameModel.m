//
//  LBTmallDetailgoodsCommentFrameModel.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/2/1.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "LBTmallDetailgoodsCommentFrameModel.h"

@implementation LBTmallDetailgoodsCommentFrameModel

-(void)setCommentModel:(LBTmallProductDetailgoodsCommentModel *)CommentModel{
    _CommentModel = CommentModel;
    
    self.cellH = 60;
    
    if (_CommentModel.ord_spec_info.length <= 0) {

    }else{
        NSString  *str = [NSString stringWithFormat:@"规格：%@",_CommentModel.ord_spec_info];
        CGRect sizeapec=[str boundingRectWithSize:CGSizeMake(UIScreenWidth - 70, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11]} context:nil];//计算规格的高度
        self.cellH = self.cellH + sizeapec.size.height + 10;
        
    }
    
    
    CGRect sizecomment=[[_CommentModel.comment stringByRemovingPercentEncoding] boundingRectWithSize:CGSizeMake(UIScreenWidth - 70, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil];//计算评论内容的高度
    
    self.cellH = self.cellH + sizecomment.size.height + 13;
    self.cellH = self.cellH + 30;//下面时间的高度
    
    if ([NSString StringIsNullOrEmpty:[_CommentModel.reply stringByRemovingPercentEncoding]]) {//没有回复
        
    }else{//有回复
        NSString  *str  = [NSString stringWithFormat:@"商家回复：%@",[_CommentModel.reply stringByRemovingPercentEncoding]];
        CGFloat repalycellH = 0;
        CGRect sizeconent=[str boundingRectWithSize:CGSizeMake(UIScreenWidth - 80, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil];//计算评论cell的高度
        
        repalycellH = sizeconent.size.height + 10;
        
        
        self.cellH = self.cellH + repalycellH + 10;
        
    }
    
}

+(NSArray *)getIndustryModels:(NSArray *)infos{
    NSMutableArray *dataArr = [@[]mutableCopy];
    [infos enumerateObjectsUsingBlock:^(LBTmallProductDetailgoodsCommentModel*  _Nonnull dict, NSUInteger idx, BOOL * _Nonnull stop) {
        LBTmallDetailgoodsCommentFrameModel *model = [[LBTmallDetailgoodsCommentFrameModel alloc]init];
        model.CommentModel = dict;
        [dataArr addObject:model];
        
    }];
    return [dataArr mutableCopy];
}
@end
