//
//  LBSetUpTableViewCell.h
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/1/12.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LBSetUpTableViewCell : UITableViewCell

/**
 标题
 */
@property (weak, nonatomic) IBOutlet UILabel *titleLb;

/**
 头像
 */
@property (weak, nonatomic) IBOutlet UIImageView *headimage;

/**
 箭头
 */
@property (weak, nonatomic) IBOutlet UIImageView *arrowImage;

/**
 缓存
 */
@property (weak, nonatomic) IBOutlet UILabel *cacheLB;

@end
