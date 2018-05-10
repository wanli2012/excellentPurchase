//
//  LBDolphinDetailThreeHeaderView.h
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/3/19.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZDProgressView.h"

@interface LBDolphinDetailThreeHeaderView : UIView

@property (weak, nonatomic) IBOutlet UILabel *alertLb;
@property (weak, nonatomic) IBOutlet UIView *jionView;
@property (weak, nonatomic) IBOutlet UIView *NotJoinView;
@property (weak, nonatomic) IBOutlet UILabel *numbers;
@property (weak, nonatomic) IBOutlet UILabel *peoplelb;
@property (weak, nonatomic) IBOutlet UILabel *progresslb;
@property (weak, nonatomic) IBOutlet UILabel *goodname;
@property (weak, nonatomic) IBOutlet UILabel *mycount;
@property (weak, nonatomic) IBOutlet UILabel *mynubers;
@property (weak, nonatomic) IBOutlet UIView *shareview;
@property (weak, nonatomic) IBOutlet UIView *shareoneview;
@property (weak, nonatomic) IBOutlet UIView *progressV;
@property (nonatomic,strong) ZDProgressView *zdProgressView;

@end
