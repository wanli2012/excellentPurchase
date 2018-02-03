//
//  LBAddCounterView.h
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/1/25.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LBAddCounterViewDelegate <NSObject>

- (void)popClassifyView:(void(^)(NSString *textfiled))filedBlock;


@end

@interface LBAddCounterView : UIView

@property (nonatomic, weak)id <LBAddCounterViewDelegate>delegate;

+(LBAddCounterView*)addCounterFrame:(CGRect)frame delegate:(id)delegate textfBloack:(void(^)(NSString *textfiled))filedBlock;


@end
