//
//  LBAddCounterView.h
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/1/25.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LBAddCounterView : UIView

+(LBAddCounterView*)addCounterFrame:(CGRect)frame textfBloack:(void(^)(NSString *textfiled))filedBlock;

@end
