//
//  LBAddOrEditProductChooseView.h
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/1/25.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LBAddOrEditProductChooseView : UIView

+ (instancetype)showWholeClassifyViewWith:(NSArray *)cateModels Block:(void(^)(NSInteger section,NSInteger row))bankBlock  cancelBlock:(void(^)(void))cancelBlock;

@end
