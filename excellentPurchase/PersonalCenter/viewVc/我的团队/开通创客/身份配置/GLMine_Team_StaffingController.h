//
//  GLMine_Team_StaffingController.h
//  excellentPurchase
//
//  Created by 龚磊 on 2018/1/25.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^GLMine_Team_StaffingControllerBlock)(NSString *citynumber,NSString *districtnumber,NSString *corenumber,NSString *regionnumber,NSString *makernumber);

@interface GLMine_Team_StaffingController : UIViewController

@property (nonatomic, copy)GLMine_Team_StaffingControllerBlock block;

@property (nonatomic, copy)NSString *group_id;

@end
