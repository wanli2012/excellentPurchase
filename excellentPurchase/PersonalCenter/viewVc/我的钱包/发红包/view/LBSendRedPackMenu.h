//
//  LBSendRedPackMenu.h
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/1/11.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LBSendRedPackMenu;

@protocol LBSendRedPackMenuDelegate <NSObject>

@optional

- (void)pageMenu:(LBSendRedPackMenu *)pageMenu itemSelectedFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex;

@end

@interface LBSendRedPackMenu : UIView

/** 选中的item下标 */
@property (nonatomic) NSUInteger selectedItemIndex;
/** 代理 */
@property (nonatomic, weak) id<LBSendRedPackMenuDelegate> delegate;

@end
