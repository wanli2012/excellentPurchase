//
//  GLMine_Team_HistoryDateChooseView.h
//  excellentPurchase
//
//  Created by 龚磊 on 2018/1/18.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 日期选择,只有年和月份
 */
@interface GLMine_Team_HistoryDateChooseView : UIView

+ (instancetype)showDateChooseViewWith:(void(^)(NSString *dateStr))dateBlock;

@end
