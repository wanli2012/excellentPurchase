//
//  LBMineOrderDetailAdressTableViewCell.h
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/1/22.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LBMyOrdersDetailModel.h"

@interface LBMineOrderDetailAdressTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *rightimge;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *adressConstrait;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightImgeW;
@property (weak, nonatomic) IBOutlet UILabel *namelb;
@property (weak, nonatomic) IBOutlet UILabel *phonelb;
@property (weak, nonatomic) IBOutlet UILabel *adresslb;

@property (strong , nonatomic)LBMyOrdersDetailModel *model;

@end
