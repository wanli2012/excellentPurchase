//
//  LBMineCenterFlyNoticeDetailTableViewCell.h
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/3/30.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LBMineCenterFlyNoticeModel.h"

@interface LBMineCenterFlyNoticeDetailTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *statusLb;
@property (weak, nonatomic) IBOutlet UILabel *codelb;
@property (weak, nonatomic) IBOutlet UIImageView *imagev;

@property (strong , nonatomic)LBMineCenterFlyNoticeModel *model;

@end
