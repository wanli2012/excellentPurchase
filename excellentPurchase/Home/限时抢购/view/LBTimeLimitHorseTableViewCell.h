//
//  LBTimeLimitHorseTableViewCell.h
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/3/1.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TXScrollLabelView.h"

@interface LBTimeLimitHorseTableViewCell : UITableViewCell

@property (strong , nonatomic)NSArray *dataArr;
@property (weak, nonatomic) IBOutlet UILabel *titilelb;
@property (nonatomic, strong)TXScrollLabelView *scrollLabelView;

@end
