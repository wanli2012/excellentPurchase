//
//  GLMine_PaySuccessView.h
//  excellentPurchase
//
//  Created by 龚磊 on 2018/1/23.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GLMine_PaySuccessViewDelegate <NSObject>

- (void)completed;
- (void)checkOutOrder;

@end

@interface GLMine_PaySuccessView : UICollectionReusableView

@property (nonatomic, weak)id <GLMine_PaySuccessViewDelegate> delegate;

@end
