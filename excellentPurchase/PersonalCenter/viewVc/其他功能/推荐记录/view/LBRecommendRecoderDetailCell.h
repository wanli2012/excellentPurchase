//
//  LBRecommendRecoderDetailCell.h
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/2/2.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LBRecommendRecoderListModel.h"

@interface LBRecommendRecoderDetailCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *timelb;
@property (weak, nonatomic) IBOutlet UILabel *contentlb;

@property (strong , nonatomic)LBRecommendRecoderListModel *model;

@end
