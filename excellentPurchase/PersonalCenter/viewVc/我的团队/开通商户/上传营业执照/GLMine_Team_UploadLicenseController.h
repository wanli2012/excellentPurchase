//
//  GLMine_Team_UploadLicenseController.h
//  excellentPurchase
//
//  Created by 龚磊 on 2018/1/19.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^GLMine_Team_UploadLicenseControllerBlock)(NSString *firstUrl);

@interface GLMine_Team_UploadLicenseController : UIViewController


@property (nonatomic, copy)GLMine_Team_UploadLicenseControllerBlock block;

@property (nonatomic, copy)NSString *firstUrl;//正面照url

@end
