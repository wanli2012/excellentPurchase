//
//  GLMine_Team_HistoryDateChooseView.h
//  excellentPurchase
//
//  Created by 龚磊 on 2018/1/18.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NSDate *(^dateChooseBlock)(void);

@interface GLMine_Team_HistoryDateChooseView : UIView

@property (nonatomic, copy)dateChooseBlock block;

+ (GLMine_Team_HistoryDateChooseView *)show;

@end
