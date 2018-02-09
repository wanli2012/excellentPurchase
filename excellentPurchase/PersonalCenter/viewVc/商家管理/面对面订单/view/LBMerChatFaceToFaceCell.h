//
//  LBMerChatFaceToFaceCell.h
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/2/9.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LBMerChatFaceToFacemodel.h"

@interface LBMerChatFaceToFaceCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imagev;
@property (weak, nonatomic) IBOutlet UILabel *userLb;
@property (weak, nonatomic) IBOutlet UILabel *methodlb;
@property (weak, nonatomic) IBOutlet UILabel *timelb;
@property (weak, nonatomic) IBOutlet UILabel *ratelb;
@property (weak, nonatomic) IBOutlet UILabel *paylb;

@property (strong , nonatomic)LBMerChatFaceToFacemodel *model;

@end
