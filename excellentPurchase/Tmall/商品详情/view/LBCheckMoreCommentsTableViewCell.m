//
//  LBCheckMoreCommentsTableViewCell.m
//  excellentPurchase
//
//  Created by 四川三君科技有限公司 on 2018/1/15.
//  Copyright © 2018年 四川三君科技有限公司. All rights reserved.
//

#import "LBCheckMoreCommentsTableViewCell.h"

@implementation LBCheckMoreCommentsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (IBAction)checkMoreComments:(UIButton *)sender {
    
    [self.delegate checkMoreComments];
}


@end
