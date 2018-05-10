//
//  LBHomeOneDolphinDetailHeaderView.h
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/3/12.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LBHomeOneDolphinDetailmodel.h"

@protocol LBHomeOneDolphinDetailHeaderdelegete <NSObject>

-(void)checkPictureWord;
-(void)sharegoodsinfo;
-(void)calculateEvent;

@end

@interface LBHomeOneDolphinDetailHeaderView : UIView

@property (strong, nonatomic)SDCycleScrollView *cycleScrollView;//banner
@property (strong , nonatomic)LBHomeOneDolphinDetailmodel *model;
@property (assign , nonatomic)id<LBHomeOneDolphinDetailHeaderdelegete> delegete;

@end
