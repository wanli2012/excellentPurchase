//
//  LBTmallProductDetailModel.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/1/31.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "LBTmallProductDetailModel.h"

@implementation LBTmallProductDetailModel

+ (NSDictionary *)mj_objectClassInArray{
    return @{
                     @"comment_list" : @"LBTmallProductDetailgoodsCommentModel",
                     @"love" : @"LBTmallhomepageDataStructureModel",
                     @"goods_spec" : @"LBTmallProductDetailgoodsSpecModel"
              };
}

- (void)setValue:(id)value forKey:(NSString *)key {
    
    if ([value isKindOfClass:[NSNull class]]) {
        [super setValue:@"" forKey:key];
        return;
    }
    [super setValue:value forKey:key];
}

-(void)setComment_list:(NSArray<LBTmallProductDetailgoodsCommentModel *> *)comment_list{
   
    NSMutableArray *dataArr = [@[]mutableCopy];
    
    [comment_list enumerateObjectsUsingBlock:^(LBTmallProductDetailgoodsCommentModel*  _Nonnull model, NSUInteger idx, BOOL * _Nonnull stop) {
        
       CGFloat  cellH = 60;
        
        if (model.ord_spec_info.length <= 0) {
            
        }else{
            NSString  *str = [NSString stringWithFormat:@"规格：%@",model.ord_spec_info];
            CGRect sizeapec=[str boundingRectWithSize:CGSizeMake(UIScreenWidth - 70, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11]} context:nil];//计算规格的高度
            cellH = cellH + sizeapec.size.height + 10;
            
        }
        
        
        CGRect sizecomment=[[model.comment stringByRemovingPercentEncoding] boundingRectWithSize:CGSizeMake(UIScreenWidth - 70, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil];//计算评论内容的高度
        
        cellH = cellH + sizecomment.size.height + 13;
        cellH = cellH + 30;//下面时间的高度
        
        if ([NSString StringIsNullOrEmpty:[model.reply stringByRemovingPercentEncoding]]) {//没有回复
            
        }else{//有回复
            NSString  *str  = [NSString stringWithFormat:@"商家回复：%@",[model.reply stringByRemovingPercentEncoding]];
            CGFloat repalycellH = 0;
            CGRect sizeconent=[str boundingRectWithSize:CGSizeMake(UIScreenWidth - 80, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil];//计算评论cell的高度
            
            repalycellH = sizeconent.size.height + 10;
            
            
            cellH = cellH + repalycellH + 10;
            
        }
        
        model.cellH = cellH;
        
        [dataArr addObject:model];
        
    }];
    
    _comment_list = dataArr ;
    
}

@end

@implementation LBTmallProductDetailgoodsSpecModel

- (void)setValue:(id)value forKey:(NSString *)key {
    
    if ([value isKindOfClass:[NSNull class]]) {
        [super setValue:@"" forKey:key];
        return;
    }
    [super setValue:value forKey:key];
}

@end


@implementation LBTmallProductDetailgoodsCommentModel

@end


