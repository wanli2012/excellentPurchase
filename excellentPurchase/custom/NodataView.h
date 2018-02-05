//
//  NodataView.h
//  PovertyAlleviation
//
//  Created by 四川三君科技有限公司 on 2017/2/22.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NodataView : UIView


@property (weak, nonatomic) IBOutlet UILabel *statusLb;
@property (weak, nonatomic) IBOutlet UIImageView *imagev;

///选择回调
@property (nonatomic, copy) void (^cancekBlock)(void);

@end
