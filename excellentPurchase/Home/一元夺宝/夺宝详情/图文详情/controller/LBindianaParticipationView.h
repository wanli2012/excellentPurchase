//
//  LBindianaParticipationView.h
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/5/5.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LBindianaParticipationView : UIView

@property (copy , nonatomic)void(^cancelEvent)(void);
@property (copy , nonatomic)void(^sureEvent)(NSString *num);

@end
