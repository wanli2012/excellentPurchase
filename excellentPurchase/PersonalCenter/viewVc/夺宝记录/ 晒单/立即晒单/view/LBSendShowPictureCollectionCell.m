//
//  LBSendShowPictureCollectionCell.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/5/10.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "LBSendShowPictureCollectionCell.h"

@implementation LBSendShowPictureCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (IBAction)delegetepicture:(UIButton *)sender {
    
    if (self.deletepic) {
        self.deletepic(self.indexpath);
    }
}

@end
