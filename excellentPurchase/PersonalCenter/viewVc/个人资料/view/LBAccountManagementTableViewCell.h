//
//  LBAccountManagementTableViewCell.h
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/1/10.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LBAccountManagementTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;//左边的title
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;//右边的值
@property (weak, nonatomic) IBOutlet UIImageView *imageV;//图片

@property (nonatomic, assign)NSInteger type;//1:有右箭头 0:无右箭头

@end
