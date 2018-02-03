//
//  LBStoreAmendPhotosCell.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/1/25.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "LBStoreAmendPhotosCell.h"

@implementation LBStoreAmendPhotosCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (IBAction)deletephoto:(UIButton *)sender {
    
    self.deleteBlock(self.index);
}

@end
