//
//  LBSwitchAccountTableViewCell.h
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/1/12.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LBSwitchAccountTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *picImageV;//图片
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;//昵称
@property (weak, nonatomic) IBOutlet UILabel *groupNameLabel;//身份名
@property (weak, nonatomic) IBOutlet UILabel *IDNumberLabel;//ID号
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;//手机号

@end
