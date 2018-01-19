//
//  GLMine_Team_HistoryHeader.h
//  excellentPurchase
//
//  Created by 龚磊 on 2018/1/18.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GLMine_Team_HistoryHeaderDelegate <NSObject>

- (void)dateChoose;

@end

@interface GLMine_Team_HistoryHeader : UIView

@property (nonatomic, weak)id <GLMine_Team_HistoryHeaderDelegate>delegate;

@end
