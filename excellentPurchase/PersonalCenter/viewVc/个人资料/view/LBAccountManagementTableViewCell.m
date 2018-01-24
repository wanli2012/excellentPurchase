//
//  LBAccountManagementTableViewCell.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/1/10.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "LBAccountManagementTableViewCell.h"

@interface LBAccountManagementTableViewCell ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *valueLabelTrailing;//valueLabel右边约束
@property (weak, nonatomic) IBOutlet UIImageView *arrowImageV;//箭头

@end

@implementation LBAccountManagementTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];

}

- (void)setType:(NSInteger)type{
    _type = type;
    
    if(self.type == 1){//右箭头
        
        self.valueLabelTrailing.constant = 26;
        self.arrowImageV.hidden = NO;
        
    }else if(self.type == 0){//没箭头
        
        self.valueLabelTrailing.constant = 10;
        self.arrowImageV.hidden = YES;
        
    }else if(self.type == 2){//二维码
        
        self.arrowImageV.hidden = YES;
        self.valueLabel.hidden = YES;
        self.imageV.hidden = NO;
        
    }
    
}



@end
