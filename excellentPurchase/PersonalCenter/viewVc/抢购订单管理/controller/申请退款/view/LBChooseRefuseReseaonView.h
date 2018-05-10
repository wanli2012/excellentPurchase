//
//  LBChooseRefuseReseaonView.h
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/4/23.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LBChooseRefuseReseaonView : UIView

+ (instancetype)showMenu:(NSArray *)dataArr controlFrame:(CGRect)rect andReturnBlock:(void(^)(NSString *selectstr,NSString *row))menuBlock;

@end
