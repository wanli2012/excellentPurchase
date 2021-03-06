//
//  LBDonationTableViewCell.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/1/11.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "LBDonationTableViewCell.h"

@interface LBDonationTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *IDNumberLabel;//id号
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;//日期
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;//类型
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;//数额

@end

@implementation LBDonationTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];

    

}

- (void)setModel:(GLDonationRecordModel *)model{
    _model = model;
    
    if (model.recordType == 1) {//转赠还是获赠 1.获赠 2.转赠
        self.IDNumberLabel.text = [NSString stringWithFormat:@"账号:%@", model.uname];
    }else{
        self.IDNumberLabel.text = [NSString stringWithFormat:@"账号:%@", model.cname];
    }
    
    self.dateLabel.text = [formattime formateTimeOfDate4:model.time];
    self.typeLabel.text = model.type;
    self.moneyLabel.text = model.money;
    
}

@end
